from __future__ import annotations
from typing import Tuple, Dict
import numpy as np
import scipy as sp
from collections import namedtuple
from .kf import *
from copy import copy
import matplotlib.pyplot as plt

NeighborInfo = namedtuple("NeighborInfo", ["coord", "r"])


class Node:
    # these are actual data
    _x: float   # coord x
    _y: float   # coord y
    _range: float
    _network: Network

    def __init__(self, *, network, x, y, range):
        self._network = network
        self._x = x
        self._y = y
        self._range = range

    @property
    def coord(self) -> np.ndarray:
        return np.array([self._x, self._y])

    @property
    def range(self) -> float:
        return self._range


class Normal(Node):
    _x_hat: np.ndarray  # state vector
    _neighbors: Dict[int, NeighborInfo]
    _P: np.ndarray  # covariance matrix

    def __init__(self, *, network, x, y, range):
        super().__init__(network=network, x=x, y=y, range=range)
        self._x_hat = np.empty(2, dtype=np.float64)
        self._neighbors = {}
        self._P = np.eye(2, dtype=np.float64)

    @property
    def pcoord(self) -> np.ndarray:
        return self._x_hat

    @pcoord.setter
    def pcoord(self, value: Tuple[float, float]):
        self._x_hat[0] = value[0]
        self._x_hat[1] = value[1]

    def recv(self, id, coord, r):
        self._neighbors[id] = NeighborInfo(coord=coord, r=r)

    def remove(self, id):
        self._neighbors.pop(id)

    def update(self):
        # Jacobian Matrix: H = partial z / partial x
        H = np.empty((len(self._neighbors), 2), dtype=np.float64)
        # Measurement Vector: z = r
        z = np.empty(len(self._neighbors), dtype=np.float64)
        for i, info in enumerate(self._neighbors.values()):
            H[i] = (self.coord - info.coord) / np.linalg.norm(self.coord - info.coord)
            z[i] = info.r
        # Kalman Filter
        # Measurement Noise Covariance Matrix: R
        R = np.eye(len(self._neighbors), dtype=np.float64)
        self._x_hat, self._P = kalman_filter_no_time_update(self._x_hat, self._P, z, R, H)


class Anchor(Node):
    def __init__(self, *, network, x, y, range):
        super().__init__(network=network, x=x, y=y, range=range)

    @property
    def pcoord(self) -> np.ndarray:
        return self.coord   # anchor's pcoord is the same as coord

    def update(self):
        pass

    def recv(self, id, coord, r):
        pass


class Network:
    _nodes: Dict[int, Node]

    def __getitem__(self, id):
        return self._nodes[id]

    def __setitem__(self, id, node: Node):
        self._nodes[id] = node

    def __init__(self):
        self._nodes = {}

    def remove_node(self, id):
        self._nodes.pop(id)

    def distance(self, id1, id2, variance=0.0):
        return np.linalg.norm(self._nodes[id1].coord - self._nodes[id2].coord) + np.random.normal(0, variance)

    def send(self, id1, id2):
        # id1 sends data to id2
        self[id2].recv(id1, copy(self[id1].pcoord), self.distance(id1, id2))

    def broadcast(self, id):
        # id broadcasts data to all its neighbors
        source = self[id]
        for nid, node in self._nodes.items():
            if id == nid:
                continue
            # if the distance between source and node is less than source's range
            if np.linalg.norm(source.coord - node.coord) < source._range:
                self.send(id, nid)

    def draw_all(self):
        fig, ax = plt.subplots()
        for node in self._nodes.values():
            if isinstance(node, Anchor):
                ax.plot(node.coord[0], node.coord[1], "bo")
            elif isinstance(node, Normal):
                ax.plot(node.coord[0], node.coord[1], "ro")
                ax.plot(node.pcoord[0], node.pcoord[1], "rx")
                ax.plot([node.coord[0], node.pcoord[0]], [node.coord[1], node.pcoord[1]], 'r-')
        plt.show()

