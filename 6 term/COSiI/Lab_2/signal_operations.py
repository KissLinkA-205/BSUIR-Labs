import numpy as np

import fourier_transforms as ft

def correlate_coagulate(first_sequence, second_sequence, operation):
    if operation != 1 and operation != -1:
        raise Exception('Operation must be 1 (correlation) or -1 (coagulation)! Got {}'.format(operation))

    if len(first_sequence) != len(second_sequence):
        raise Exception('Sequence lengths must be equal! The length of the first sequence is {}, the second {}'
                        .format(len(first_sequence), len(second_sequence)))

    result = []
    N = len(first_sequence)

    for i in range(N):
        temp = 0
        for j in range(N):
            if i + operation * j > N - 1:
                temp += first_sequence[j] * second_sequence[- N + i + operation * j]
            else:
                temp += first_sequence[j] * second_sequence[i + operation * j]

        result.append(temp / N)

    return result


def correlate_coagulate_using_fft(first_sequence, second_sequence, operation):
    if operation != 1 and operation != -1:
        raise Exception('Operation must be 1 (correlation) or -1 (coagulation)! Got {}'.format(operation))

    if len(first_sequence) != len(second_sequence):
        raise Exception('Sequence lengths must be equal! The length of the first sequence is {}, the second {}'
                        .format(len(first_sequence), len(second_sequence)))

    first_sequence_fft = ft.fft_dif(first_sequence, 1)
    second_sequence_fft = ft.fft_dif(second_sequence, 1)

    if operation == 1:
        first_sequence_fft = np.conj(first_sequence_fft)

    result = np.multiply(first_sequence_fft, second_sequence_fft)

    return ft.fft_dif(result, -1)
