import matplotlib.pyplot as plt
import numpy as np

import signal_operations as so

N = 16
PERIOD = 2 * np.pi
X = np.linspace(0, PERIOD, N)
Y = list(map(lambda x: np.sin(2 * x), X))
Z = list(map(lambda x: np.cos(7 * x), X))

def main():
    gridsize = (12, 4)
    fig = plt.figure(figsize=(15, 10))
    fig.suptitle('Лабораторная работа №2', fontfamily='serif', fontstyle='italic', fontsize=30)

    ax1 = plt.subplot2grid(gridsize, (1, 0), colspan=2, rowspan=2)
    ax1.set_title('График исходной функции y = sin(2x)', fontsize=20)
    ax1.grid()
    ax1.plot(X, Y)

    ax2 = plt.subplot2grid(gridsize, (1, 2), colspan=2, rowspan=2)
    ax2.set_title('График исходной функции z = cos(7x)', fontsize=20)
    ax2.grid()
    ax2.plot(X, Z)

    ax3 = plt.subplot2grid(gridsize, (5, 0), colspan=2, rowspan=2)
    ax3.set_title('График свёртки', fontsize=20)
    ax3.grid()
    ax3.plot(X, so.correlate_coagulate(Y, Z, -1))

    ax4 = plt.subplot2grid(gridsize, (5, 2), colspan=2, rowspan=2)
    ax4.set_title('График корреляции', fontsize=20)
    ax4.grid()
    ax4.plot(X, so.correlate_coagulate(Y, Z, 1))

    ax5 = plt.subplot2grid(gridsize, (9, 0), colspan=2, rowspan=2)
    ax5.set_title('График свёртки на основе БПФ', fontsize=20)
    ax5.grid()
    ax5.plot(X, so.correlate_coagulate_using_fft(Y, Z, -1))

    ax6 = plt.subplot2grid(gridsize, (9, 2), colspan=2, rowspan=2)
    ax6.set_title('График корреляции на основе БПФ', fontsize=20)
    ax6.grid()
    ax6.plot(X, so.correlate_coagulate_using_fft(Y, Z, 1))

    plt.show()

if __name__ == '__main__':
    main()
