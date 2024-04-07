from typing import Tuple
import scipy as sp

def kalman_filter_no_time_update(x_hat: sp.ndarray, P: sp.ndarray, z: sp.ndarray, R: sp.ndarray, H: sp.ndarray) -> Tuple[sp.ndarray, sp.ndarray]:
    # Kalman Gain
    K = P @ H.T @ sp.linalg.inv(H @ P @ H.T + R)
    # Update
    x_hat = x_hat + K @ (z - H @ x_hat)
    P = (sp.eye(len(x_hat)) - K @ H) @ P
    return x_hat, P