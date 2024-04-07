from .core import *

if __name__ == "__main__":
    network = Network()
    # set 3 anchors and 1 normal
    network[0] = Anchor(x=0, y=0, range=0)
    network[1] = Anchor(x=0, y=1, range=0)
    network[2] = Anchor(x=1, y=0, range=0)
    network[3] = Normal(x=1, y=1, range=0)
    # add neighbors
    network[3].add_neighbor(0, network[0].coord, network.distance(3, 0, 0.1))
    network[3].add_neighbor(1, network[1].coord, network.distance(3, 1, 0.1))
    network[3].add_neighbor(2, network[2].coord, network.distance(3, 2, 0.1))
    # update
    network[3].update()
    # draw
    network.draw_all()