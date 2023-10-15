import numpy as np

def fft_dif(sequence, operation):
    if operation != 1 and operation != -1:
        raise Exception('Operation must be 1 (FFT) or -1 (reverse FFT)! Got {}'.format(operation))

    N = len(sequence)
    if N == 1 or (N & (N - 1)) != 0: return sequence

    count = (int)(np.log2(N))
    result = []
    for i in range(N):
        result.append(complex(sequence[i]))

    for i in range(count, 0, -1):
        n = 2 ** i // 2
        w = 1
        wN = np.exp(operation * -2j * np.pi / (2 ** i))
        for k in range(n):
            for j in range(0, N, 2 ** i):
                b = result[j + k]
                c = result[j + k + n]
                result[j + k] = b + c
                result[j + k + n] = (b - c) * w
            w *= wN

    result = binary_invert(result)

    if operation == 1:
        for i in range(N):
            result[i] /= N
    return result


def binary_invert(data):
    N = len(data)

    result = data
    for i in range(N):
        s = format(i, '0>4b')
        reversed_i = int(s[::-1], 2)
        if reversed_i > i:
            temp = result[reversed_i]
            result[reversed_i] = result[i]
            result[i] = temp

    return result