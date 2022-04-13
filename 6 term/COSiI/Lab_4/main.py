import matplotlib.pyplot as plt
import numpy as np

import fourier_transforms as ft
import signal_filter as sf

N = 64
PERIOD = 2 * np.pi
arguments = np.linspace(0, PERIOD, N)
initial_sequence = list(map(lambda x: np.sin(2 * x) + np.cos(7 * x), arguments))
noise = list(map(lambda x: np.sin(PERIOD * 15 * x), arguments))
noise_sequence = [i + j for (i, j) in zip(initial_sequence, noise)]

M = 20
BW = 0.004
f = 0.5

result_low_pass_hamming_window_filter = sf.low_pass_hamming_window_filter(noise_sequence, M, N)

result_bandpass_narrowband_filter_noise = sf.bandpass_narrowband_filter(noise_sequence, BW, f)
result_bandpass_narrowband_filter = sf.bandpass_narrowband_filter(noise_sequence, 0.0666, 3.12)
result_bandpass_narrowband_filter_cos = sf.bandpass_narrowband_filter(noise_sequence, 0.0090, 0.109)

def main():
    gridsize = (20, 4)
    fig = plt.figure(figsize=(15, 10))
    fig.suptitle('Лабораторная работа №4', fontfamily='serif', fontstyle='italic', fontsize=30)

    ax1 = plt.subplot2grid(gridsize, (1, 0), colspan=2, rowspan=2)
    ax1.set_title('График исходного сигнала (sin(2x) + cos(7x))', fontsize=20)
    ax1.grid()
    ax1.plot(arguments, initial_sequence)

    ax2 = plt.subplot2grid(gridsize, (1, 2), colspan=2, rowspan=2)
    ax2.set_title('АЧХ исходного сигнала', fontsize=20)
    ax2.grid()
    ax2.plot(arguments, np.absolute(ft.fft_dif(initial_sequence, 1)))

    ax3 = plt.subplot2grid(gridsize, (5, 0), colspan=2, rowspan=2)
    ax3.set_title('График шума', fontsize=20)
    ax3.grid()
    ax3.plot(arguments, noise)

    ax4 = plt.subplot2grid(gridsize, (5, 2), colspan=2, rowspan=2)
    ax4.set_title('АЧХ шума', fontsize=20)
    ax4.grid()
    ax4.plot(arguments, np.absolute(ft.fft_dif(noise, 1)))

    ax5 = plt.subplot2grid(gridsize, (9, 0), colspan=2, rowspan=2)
    ax5.set_title('График искаженного сигнала', fontsize=20)
    ax5.grid()
    ax5.plot(arguments, noise_sequence)

    ax6 = plt.subplot2grid(gridsize, (9, 2), colspan=2, rowspan=2)
    ax6.set_title('АЧХ искаженного сигнала', fontsize=20)
    ax6.grid()
    ax6.plot(arguments, np.absolute(ft.fft_dif(noise_sequence, 1)))

    ax7 = plt.subplot2grid(gridsize, (13, 0), colspan=2, rowspan=2)
    ax7.set_title('График сигнала после КИХ фильтра', fontsize=20)
    ax7.grid()
    ax7.plot(arguments, result_low_pass_hamming_window_filter)

    ax8 = plt.subplot2grid(gridsize, (13, 2), colspan=2, rowspan=2)
    ax8.set_title('АЧХ сигнала после КИХ фильтра', fontsize=20)
    ax8.grid()
    ax8.plot(arguments, np.absolute(ft.fft_dif(result_low_pass_hamming_window_filter, 1)))

    ax9 = plt.subplot2grid(gridsize, (17, 0), colspan=2, rowspan=2)
    ax9.set_title('График сигнала после БИХ фильтра', fontsize=20)
    ax9.grid()
    ax9.plot(arguments, result_bandpass_narrowband_filter_noise)

    ax10 = plt.subplot2grid(gridsize, (17, 2), colspan=2, rowspan=2)
    ax10.set_title('АЧХ сигнала после БИХ фильтра', fontsize=20)
    ax10.grid()
    ax10.plot(arguments, np.absolute(ft.fft_dif(result_bandpass_narrowband_filter_noise, 1)))

    plt.show()


if __name__ == '__main__':
    main()
