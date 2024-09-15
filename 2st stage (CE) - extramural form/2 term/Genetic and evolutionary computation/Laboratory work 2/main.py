import math
import random
import sys
import typing as tp
from enum import Enum

import numpy as np
import pyqtgraph as pg
from PyQt5.QtCore import Qt
from PyQt5.QtWidgets import *
from matplotlib import pyplot as plt
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from pyqtgraph import QtCore


class GraphColours(Enum):
    POINTS = pg.mkPen(color=(0, 0, 255))
    LINES = pg.mkPen(color=(255, 0, 0))


class StyleSheet(Enum):
    LAYOUT_TITLE_LABEL = "font-size: 16px; color: black; font-family: Arial; font-weight: bold;"
    LABEL = "font-size: 14px; color: black; font-family: Arial;"
    ENABLED_BUTTON = "font-size: 14px; color: black; font-family: Arial;"
    DISABLED_BUTTON = "font-size: 14px; color: gray; font-family: Arial;"


class ObjectKeyWord(Enum):
    POPULATION_SIZE_SLIDER = "population_size_slider"
    POPULATION_SIZE_SLIDER_VALUE = "population_size_slider_value"
    POPULATION_SIZE_SLIDER_VALUE_LABEL = "population_size_slider_value_label"

    CHROMOSOMES_SIZE_SLIDER = "chromosomes_size_slider"
    CHROMOSOMES_SIZE_SLIDER_VALUE = "chromosomes_size_slider_value"
    CHROMOSOMES_SIZE_SLIDER_VALUE_LABEL = "chromosomes_size_slider_value_label"

    CROSSOVER_PROBABILITY_SLIDER = "crossover_probability_slider"
    CROSSOVER_PROBABILITY_SLIDER_VALUE = "crossover_probability_slider_value"
    CROSSOVER_PROBABILITY_SLIDER_VALUE_LABEL = "crossover_probability_slider_value_label"

    MUTATION_PROBABILITY_SLIDER = "mutation_probability_slider"
    MUTATION_PROBABILITY_SLIDER_VALUE = "mutation_probability_slider_value"
    MUTATION_PROBABILITY_SLIDER_VALUE_LABEL = "mutation_probability_slider_value_label"

    MAX_GENERATIONS_NUMBER_SLIDER = "max_generations_number_slider"
    MAX_GENERATIONS_NUMBER_SLIDER_VALUE = "max_generations_number_slider_value"
    MAX_GENERATIONS_NUMBER_SLIDER_VALUE_LABEL = "max_generations_number_slider_value_label"

    CURRENT_GENERATION_NUMBER_VALUE_LABEL = "current_generation_number_value_label"

    MAX_X1_VALUE_LABEL = "max_x1_value_label"
    MAX_X2_VALUE_LABEL = "max_x2_value_label"
    MAX_F_VALUE_LABEL = "max_f_value_label"

    START_SIMULATION_BUTTON = "start_simulation_button"
    STOP_SIMULATION_BUTTON = "stop_simulation_button"
    PREVIOUS_GENERATION_BUTTON = "previous_generation_button"
    NEXT_GENERATION_BUTTON = "next_generation_button"

    FUNCTION_FIGURE = "function_figure"
    FUNCTION_FIGURE_CANVAS = "function_figure_canvas"
    FUNCTION_FIGURE_AXES = "function_figure_axes"
    FUNCTION_FIGURE_SCATTER = "function_figure_scatter"
    FUNCTION_FIGURE_CONTOUR = "function_figure_contour"

    VALUE_GRAPH = "value_graph"

    CURRENT_GENERATION_NUMBER = "current_generation_number"
    GENERATIONS_X1_VALUES = "generations_x1_values"
    GENERATIONS_X2_VALUES = "generations_x2_values"


TARGET_FUNCTION_MIN_VALUE = -100
TARGET_FUNCTION_MAX_VALUE = 100
TARGET_FUNCTION_POINTS_NUMBER = 5000


def target_function(x1: float, x2: float) -> float:
    return (x1 ** 2 + x2 ** 2) ** 0.25 * (math.sin(50 ** (x1 ** 2 + x2 ** 2) ** 0.1) ** 2 + 1)


def target_function_np(x1, x2):
    return (x1 ** 2 + x2 ** 2) ** 0.25 * (np.sin(50 ** (x1 ** 2 + x2 ** 2) ** 0.1) ** 2 + 1)


class Lab2Application(QWidget):

    def __init__(self):
        super().__init__()

        self.ui_objects = dict()
        self.top_level_layout = None
        self.right_layout = None
        self.left_layout = None

        self.show_ui()

    def show_ui(self):
        self.setGeometry(300, 300, 1200, 800)
        self.setMinimumSize(1200, 800)
        self.setWindowTitle('Деркач А.В. гр. 355841 - Лабораторная работа №2')

        self.top_level_layout = QHBoxLayout(self)
        self.left_layout = QVBoxLayout()
        self.right_layout = QVBoxLayout()

        self.right_layout.setSpacing(15)

        self.right_layout.setAlignment(QtCore.Qt.AlignTop)

        self.top_level_layout.addLayout(self.left_layout, stretch=4)
        self.top_level_layout.addLayout(self.right_layout, stretch=3)

        self.add_label(self.right_layout, None, 'Настройки', StyleSheet.LAYOUT_TITLE_LABEL.value, QtCore.Qt.AlignCenter)

        self.add_slider(self.right_layout, ObjectKeyWord.POPULATION_SIZE_SLIDER.value, 'Размер популяции:', 1, 500,
                        lambda val: val)
        self.add_slider(self.right_layout, ObjectKeyWord.CHROMOSOMES_SIZE_SLIDER.value, 'Количество генов-бит:', 6, 18,
                        lambda val: val)
        self.add_slider(self.right_layout, ObjectKeyWord.CROSSOVER_PROBABILITY_SLIDER.value,
                        'Вероятность кроссинговера:', 0, 100, lambda val: val / 100)
        self.add_slider(self.right_layout, ObjectKeyWord.MUTATION_PROBABILITY_SLIDER.value, 'Вероятность мутации:', 0,
                        100, lambda val: val / 100)
        self.add_slider(self.right_layout, ObjectKeyWord.MAX_GENERATIONS_NUMBER_SLIDER.value,
                        'Максимальное количество поколений', 2, 100, lambda val: val)
        self.add_button(self.right_layout, ObjectKeyWord.START_SIMULATION_BUTTON.value, 'Начать симуляцию', True,
                        self.start_button_callback)
        self.add_button(self.right_layout, ObjectKeyWord.STOP_SIMULATION_BUTTON.value, 'Остановить симуляцию', False,
                        self.stop_button_callback)

        generations_control_buttons_layout = QHBoxLayout()
        self.add_button(generations_control_buttons_layout, ObjectKeyWord.PREVIOUS_GENERATION_BUTTON.value,
                        'Предыдущее поколение', False, self.previous_generation_button_callback)
        self.add_button(generations_control_buttons_layout, ObjectKeyWord.NEXT_GENERATION_BUTTON.value,
                        'Следующее поколение', False, self.next_generation_button_callback)
        self.right_layout.addLayout(generations_control_buttons_layout)

        self.right_layout.addSpacing(30)
        self.add_label(self.right_layout, None, 'Максимум', StyleSheet.LAYOUT_TITLE_LABEL.value, QtCore.Qt.AlignCenter)

        max_x1_layout = QHBoxLayout()
        self.add_label(max_x1_layout, None, 'x1: ', StyleSheet.LABEL.value, QtCore.Qt.AlignLeft, 15)
        self.add_label(max_x1_layout, ObjectKeyWord.MAX_X1_VALUE_LABEL.value, '-', StyleSheet.LABEL.value,
                       QtCore.Qt.AlignLeft)
        self.right_layout.addLayout(max_x1_layout)

        max_x2_layout = QHBoxLayout()
        self.add_label(max_x2_layout, None, 'x2: ', StyleSheet.LABEL.value, QtCore.Qt.AlignLeft, 15)
        self.add_label(max_x2_layout, ObjectKeyWord.MAX_X2_VALUE_LABEL.value, '-', StyleSheet.LABEL.value,
                       QtCore.Qt.AlignLeft)
        self.right_layout.addLayout(max_x2_layout)

        max_f_layout = QHBoxLayout()
        self.add_label(max_f_layout, None, 'F: ', StyleSheet.LABEL.value, QtCore.Qt.AlignLeft, 15)
        self.add_label(max_f_layout, ObjectKeyWord.MAX_F_VALUE_LABEL.value, '-', StyleSheet.LABEL.value,
                       QtCore.Qt.AlignLeft)
        self.right_layout.addLayout(max_f_layout)

        current_generation_layout = QHBoxLayout()
        self.add_label(current_generation_layout, None, 'Текущее поколение: ', StyleSheet.LABEL.value,
                       QtCore.Qt.AlignRight)
        self.add_label(current_generation_layout, ObjectKeyWord.CURRENT_GENERATION_NUMBER_VALUE_LABEL.value, '-',
                       StyleSheet.LABEL.value, QtCore.Qt.AlignLeft)
        self.left_layout.addLayout(current_generation_layout)

        self.add_target_function_figure(self.left_layout, 5, ObjectKeyWord.FUNCTION_FIGURE.value)
        self.add_graph(self.left_layout, 1, ObjectKeyWord.VALUE_GRAPH.value)

        self.show()

    def add_target_function_figure(self, parent: QLayout, layout_stretch: int, fig_key_word: str):
        fig, axes = plt.subplots()

        x1, x2 = np.meshgrid(np.linspace(TARGET_FUNCTION_MIN_VALUE, TARGET_FUNCTION_MAX_VALUE, 500),
                             np.linspace(TARGET_FUNCTION_MIN_VALUE, TARGET_FUNCTION_MAX_VALUE, 500))
        f = target_function_np(x1, x2)

        contour = axes.contour(x1, x2, f, levels=50, cmap='viridis')
        axes.set_xlabel('x1')
        axes.set_ylabel('x2')
        fig.colorbar(contour)

        scatter = axes.scatter([], [])
        canvas = FigureCanvas(fig)

        self.ui_objects[fig_key_word] = fig
        self.ui_objects[f'{fig_key_word}_canvas'] = canvas
        self.ui_objects[f'{fig_key_word}_axes'] = axes
        self.ui_objects[f'{fig_key_word}_scatter'] = scatter
        self.ui_objects[f'{fig_key_word}_contour'] = contour

        parent.addWidget(canvas, stretch=layout_stretch)

    def add_graph(self, parent: QLayout, layout_stretch: int, graph_key_word: str):
        graph = pg.PlotWidget()
        graph.setBackground('white')
        graph.showGrid(x=True, y=True)
        graph.addLegend()

        self.ui_objects[graph_key_word] = graph
        parent.addWidget(graph, stretch=layout_stretch)

    def add_slider(self, parent: QLayout, slider_key_word: str, slider_description: str, min_value: int, max_value: int,
                   value_converter: tp.Callable):
        slider = QSlider(QtCore.Qt.Horizontal)
        slider.setMinimum(min_value)
        slider.setMaximum(max_value)
        slider.setTickPosition(QSlider.TickPosition.NoTicks)
        init_value = (min_value + max_value) // 2
        slider.setValue(init_value)

        self.ui_objects[slider_key_word] = slider
        slider.valueChanged.connect(self.build_slider_callback(slider_key_word, value_converter))

        slider_layout = QHBoxLayout()
        self.add_label(slider_layout, None, slider_description, StyleSheet.LABEL.value, QtCore.Qt.AlignLeft)
        self.add_label(slider_layout, f'{slider_key_word}_value_label', f'{value_converter(init_value)}',
                       StyleSheet.LABEL.value, QtCore.Qt.AlignLeft, 32)
        self.ui_objects[f'{slider_key_word}_value'] = value_converter(init_value)

        slider_layout.addWidget(slider)
        parent.addLayout(slider_layout)

    def build_slider_callback(self, slider_key_word: str, value_converter: tp.Callable):
        def callback(slider_value: int):
            value = value_converter(slider_value)
            self.ui_objects[f'{slider_key_word}_value'] = value
            self.ui_objects[f'{slider_key_word}_value_label'].setText(str(value))

        return callback

    def add_label(self, parent: QLayout, label_key_word: str, label_content: str, style_sheet: str,
                  alignment: Qt.Alignment, size: int = None):
        label = QLabel()
        label.setText(label_content)
        label.setStyleSheet(style_sheet)
        label.setAlignment(alignment)

        if size is not None:
            label.setFixedWidth(size)

        if label_key_word is not None:
            self.ui_objects[label_key_word] = label

        parent.addWidget(label)

    def add_button(self, parent: QLayout, button_key_word: str, button_description: str, is_enabled: bool,
                   button_callback: tp.Callable):
        button = QPushButton(button_description)
        button.released.connect(button_callback)

        if button_key_word is not None:
            self.ui_objects[button_key_word] = button

        self.enable_button(button_key_word, is_enabled)

        parent.addWidget(button)

    def enable_button(self, button_key_word: str, is_enabled: bool):
        button = self.ui_objects[button_key_word]

        button.setEnabled(is_enabled)
        if is_enabled:
            button.setStyleSheet(StyleSheet.ENABLED_BUTTON.value)
        else:
            button.setStyleSheet(StyleSheet.DISABLED_BUTTON.value)

    def enable_slider(self, slider_key_word: str, is_enabled: bool):
        self.ui_objects[slider_key_word].setEnabled(is_enabled)

    def render_graphs_and_figures(self):
        current_generation = self.ui_objects[ObjectKeyWord.CURRENT_GENERATION_NUMBER.value]
        current_generation_x1_chromosomes = self.ui_objects[ObjectKeyWord.GENERATIONS_X1_VALUES.value][
            current_generation - 1]
        current_generation_x2_chromosomes = self.ui_objects[ObjectKeyWord.GENERATIONS_X2_VALUES.value][
            current_generation - 1]
        current_generation_f = [target_function(chromosome_x1, chromosome_x2) for chromosome_x1, chromosome_x2 in
                                zip(current_generation_x1_chromosomes, current_generation_x2_chromosomes)]
        max_x1 = np.max(current_generation_x1_chromosomes)
        max_x2 = np.max(current_generation_x2_chromosomes)
        max_f = np.max(current_generation_f)

        self.ui_objects[ObjectKeyWord.MAX_X1_VALUE_LABEL.value].setText(str(max_x1))
        self.ui_objects[ObjectKeyWord.MAX_X2_VALUE_LABEL.value].setText(str(max_x2))
        self.ui_objects[ObjectKeyWord.MAX_F_VALUE_LABEL.value].setText(str(max_f))

        self.ui_objects[ObjectKeyWord.CURRENT_GENERATION_NUMBER_VALUE_LABEL.value].setText(str(current_generation))

        self.ui_objects[ObjectKeyWord.VALUE_GRAPH.value].clear()

        self.ui_objects[ObjectKeyWord.FUNCTION_FIGURE_SCATTER.value].remove()
        scatter = self.ui_objects[ObjectKeyWord.FUNCTION_FIGURE_AXES.value].scatter(current_generation_x1_chromosomes, current_generation_x2_chromosomes, color='red', marker='o', s=10, zorder=10)
        self.ui_objects[ObjectKeyWord.FUNCTION_FIGURE_SCATTER.value] = scatter
        self.ui_objects[ObjectKeyWord.FUNCTION_FIGURE_CANVAS.value].draw()

        best_f_values = []
        medium_f_values = []
        for generation_index in range(self.ui_objects[ObjectKeyWord.MAX_GENERATIONS_NUMBER_SLIDER_VALUE.value]):
            generation_x1_chromosomes = self.ui_objects[ObjectKeyWord.GENERATIONS_X1_VALUES.value][generation_index]
            generation_x2_chromosomes = self.ui_objects[ObjectKeyWord.GENERATIONS_X2_VALUES.value][generation_index]
            generation_f = [target_function(chromosome_x1, chromosome_x2) for chromosome_x1, chromosome_x2 in
                            zip(generation_x1_chromosomes, generation_x2_chromosomes)]

            best_f_values.append(np.max(generation_f))
            medium_f_values.append(np.mean(generation_f))

        self.ui_objects[ObjectKeyWord.VALUE_GRAPH.value].plot(range(len(best_f_values)), best_f_values,
                                                              name='Лучшее значение', pen=GraphColours.POINTS.value)
        self.ui_objects[ObjectKeyWord.VALUE_GRAPH.value].plot(range(len(medium_f_values)), medium_f_values,
                                                              name='Среднее значение', pen=GraphColours.LINES.value)

    def start_button_callback(self):
        self.ui_objects[ObjectKeyWord.CURRENT_GENERATION_NUMBER.value] = 1

        self.enable_button(ObjectKeyWord.NEXT_GENERATION_BUTTON.value, True)
        self.enable_button(ObjectKeyWord.START_SIMULATION_BUTTON.value, False)
        self.enable_button(ObjectKeyWord.STOP_SIMULATION_BUTTON.value, True)
        self.enable_slider(ObjectKeyWord.POPULATION_SIZE_SLIDER.value, False)
        self.enable_slider(ObjectKeyWord.CHROMOSOMES_SIZE_SLIDER.value, False)
        self.enable_slider(ObjectKeyWord.CROSSOVER_PROBABILITY_SLIDER.value, False)
        self.enable_slider(ObjectKeyWord.MUTATION_PROBABILITY_SLIDER.value, False)
        self.enable_slider(ObjectKeyWord.MAX_GENERATIONS_NUMBER_SLIDER.value, False)

        population_size = self.ui_objects[ObjectKeyWord.POPULATION_SIZE_SLIDER_VALUE.value]
        chromosomes_size = self.ui_objects[ObjectKeyWord.CHROMOSOMES_SIZE_SLIDER_VALUE.value]
        chromosomes_x1 = [int(random.uniform(0, 2 ** chromosomes_size)) for _ in range(population_size)]
        chromosomes_x2 = [int(random.uniform(0, 2 ** chromosomes_size)) for _ in range(population_size)]

        self.ui_objects[ObjectKeyWord.GENERATIONS_X1_VALUES.value] = [
            self.convert_to_floats(chromosomes_x1, chromosomes_size)]
        self.ui_objects[ObjectKeyWord.GENERATIONS_X2_VALUES.value] = [
            self.convert_to_floats(chromosomes_x2, chromosomes_size)]

        current_generation_x1_population = chromosomes_x1
        current_generation_x2_population = chromosomes_x2
        for generation_index in range(self.ui_objects[ObjectKeyWord.MAX_GENERATIONS_NUMBER_SLIDER_VALUE.value]):
            new_generation_x1_population = self.simple_genetic_algorithm(current_generation_x1_population,
                                                                         chromosomes_size)
            new_generation_x2_population = self.simple_genetic_algorithm(current_generation_x2_population,
                                                                         chromosomes_size)

            current_generation_x1_population = new_generation_x1_population
            current_generation_x2_population = new_generation_x1_population
            self.ui_objects[ObjectKeyWord.GENERATIONS_X1_VALUES.value].append(
                self.convert_to_floats(new_generation_x1_population, chromosomes_size))
            self.ui_objects[ObjectKeyWord.GENERATIONS_X2_VALUES.value].append(
                self.convert_to_floats(new_generation_x2_population, chromosomes_size))

        self.render_graphs_and_figures()

    def stop_button_callback(self):
        self.enable_button(ObjectKeyWord.START_SIMULATION_BUTTON.value, True)
        self.enable_button(ObjectKeyWord.STOP_SIMULATION_BUTTON.value, False)
        self.enable_button(ObjectKeyWord.NEXT_GENERATION_BUTTON.value, False)
        self.enable_button(ObjectKeyWord.PREVIOUS_GENERATION_BUTTON.value, False)

        self.enable_slider(ObjectKeyWord.POPULATION_SIZE_SLIDER.value, True)
        self.enable_slider(ObjectKeyWord.CHROMOSOMES_SIZE_SLIDER.value, True)
        self.enable_slider(ObjectKeyWord.CROSSOVER_PROBABILITY_SLIDER.value, True)
        self.enable_slider(ObjectKeyWord.MUTATION_PROBABILITY_SLIDER.value, True)
        self.enable_slider(ObjectKeyWord.MAX_GENERATIONS_NUMBER_SLIDER.value, True)

    def previous_generation_button_callback(self):
        current_generation = self.ui_objects[ObjectKeyWord.CURRENT_GENERATION_NUMBER.value]

        current_generation -= 1
        self.ui_objects[ObjectKeyWord.CURRENT_GENERATION_NUMBER.value] = current_generation
        self.enable_button(ObjectKeyWord.NEXT_GENERATION_BUTTON.value, True)

        if current_generation <= 1:
            self.enable_button(ObjectKeyWord.PREVIOUS_GENERATION_BUTTON.value, False)

        self.render_graphs_and_figures()

    def next_generation_button_callback(self):
        current_generation = self.ui_objects[ObjectKeyWord.CURRENT_GENERATION_NUMBER.value]
        max_generation = self.ui_objects[ObjectKeyWord.MAX_GENERATIONS_NUMBER_SLIDER_VALUE.value]

        current_generation += 1
        self.ui_objects[ObjectKeyWord.CURRENT_GENERATION_NUMBER.value] = current_generation
        self.enable_button(ObjectKeyWord.PREVIOUS_GENERATION_BUTTON.value, True)

        if current_generation >= max_generation:
            self.enable_button(ObjectKeyWord.NEXT_GENERATION_BUTTON.value, False)

        self.render_graphs_and_figures()

    def simple_genetic_algorithm(self, chromosomes: list[int], chromosomes_size: int) -> list[int]:
        intermediate_chromosomes = self.reproduction_operator(chromosomes, chromosomes_size)
        intermediate_chromosomes = self.crossover_operator(intermediate_chromosomes, chromosomes_size)

        return self.mutation_operator(intermediate_chromosomes, chromosomes_size)

    def reproduction_operator(self, chromosomes: list[int], chromosomes_size: int) -> list[int]:
        float_chromosomes = self.convert_to_floats(chromosomes, chromosomes_size)
        f_values = [target_function(chromosome, 1) for chromosome in float_chromosomes]
        exp_f_value = np.exp(f_values)

        num_choices = len(chromosomes)
        total_weight = sum(exp_f_value)
        probabilities = [w / total_weight for w in exp_f_value]

        return random.choices(chromosomes, probabilities, k=num_choices)

    def crossover_operator(self, chromosomes: list[int], chromosomes_size: int):
        previous_population = chromosomes

        def erase_chromosome(population, idx):
            v = population[idx]
            del population[idx]
            return v

        def choose_chromosome(population):
            idx = np.random.randint(0, len(population))
            return erase_chromosome(population, idx)

        new_population = []
        while len(previous_population) >= 2:
            chromosome1 = choose_chromosome(previous_population)
            chromosome2 = choose_chromosome(previous_population)
            crossover_probability = self.ui_objects[ObjectKeyWord.CROSSOVER_PROBABILITY_SLIDER_VALUE.value]

            if np.random.uniform() > crossover_probability:
                new_population += [chromosome1, chromosome2]
            else:
                frmt = f'0{chromosomes_size}b'
                bin1 = format(chromosome1, frmt)
                bin2 = format(chromosome2, frmt)
                k = np.random.randint(0, chromosomes_size)
                new_chromosome1 = bin1[:k] + bin2[k:]
                new_chromosome2 = bin2[:k] + bin1[k:]
                new_population += [int(new_chromosome1, 2), int(new_chromosome2, 2)]

        new_population += previous_population
        return new_population

    def mutation_operator(self, chromosomes: list[int], chromosomes_size: int):
        new_chromosomes = chromosomes[:]
        mutation_probability = self.ui_objects[ObjectKeyWord.MUTATION_PROBABILITY_SLIDER_VALUE.value]

        for i in range(len(new_chromosomes)):
            if np.random.uniform() <= mutation_probability:
                k = np.random.randint(0, chromosomes_size)
                new_chromosomes[i] ^= (1 << k)

        return new_chromosomes

    def convert_to_floats(self, numbers: list[int], bits_length: int) -> list[float]:
        float_numbers = []
        for number in numbers:
            float_numbers.append(self.convert_to_float(number, bits_length))

        return float_numbers

    def convert_to_float(self, number: int, bits_length: int) -> float:
        return TARGET_FUNCTION_MIN_VALUE + number * (TARGET_FUNCTION_MAX_VALUE - TARGET_FUNCTION_MIN_VALUE) / (
                2 ** bits_length)


def main():
    app = QApplication(sys.argv)
    ex = Lab2Application()
    sys.exit(app.exec_())


if __name__ == '__main__':
    main()
