import numpy as np


def coagulate(y, h, M):
    result = np.array(y).copy()
    for i in range(M, np.size(y) // 2 + 1):
        result[i] = 0
        for j in range(M):
            result[i] = result[i] + y[i - j] * h[j]
            result[np.size(y) - i] = result[i]

    return result
