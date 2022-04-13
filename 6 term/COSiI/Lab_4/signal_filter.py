import numpy as np

import fourier_transforms as ft
import signal_operations as so


def hamming_window(N, n):
    result = 0.54 + 0.46 * np.cos(2 * np.pi * n / N)
    return result


def low_pass_hamming_window_filter(noise_sequence, M, N):
    Fc = 0.5
    fft = ft.fft_dif(noise_sequence, 1)
    filter_arguments = []
    for i in range(N):
        window = hamming_window(M, i)
        temp = i - M / 2
        if temp == 0:
            filter_arguments.append(2 * np.pi * Fc)
        else:
            filter_arguments.append(np.sin(2 * np.pi * Fc * temp) / temp)
        filter_arguments[i] = filter_arguments[i] * window

    result_filter_arguments = [element / np.sum(filter_arguments) for element in filter_arguments]

    coagulation = so.coagulate(fft, result_filter_arguments, int(M))
    result = ft.fft_dif(coagulation, -1)
    return result


def bandpass_narrowband_filter(noise_sequence, BW, f):
    R = 1 - 3 * BW
    K = (1 - 2 * R * np.cos(2 * np.pi * f) + (R ** 2)) / (2 - 2 * np.cos(2 * np.pi * f))

    a0 = 1 - K
    a1 = 2 * (K - R) * np.cos(2 * np.pi * f)
    a2 = R ** 2 - K
    b1 = 2 * R * np.cos(2 * np.pi * f)
    b2 = - (R ** 2)

    result = np.array(noise_sequence).copy()
    for i in range(2, np.size(noise_sequence)):
        result[i] = a0 * noise_sequence[i] + a1 * noise_sequence[i - 1] + a2 * noise_sequence[i - 2] + b1 * result[
            i - 1] + b2 * \
                    result[i - 2]

    for i in range(2, np.size(noise_sequence)):
        result[i] = result[i] / 60

    return result
