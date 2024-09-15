import math
import random
import sys
import typing as tp
from enum import Enum

import numpy as np
import pyqtgraph as pg
from PyQt5.QtCore import Qt
from PyQt5.QtWidgets import *
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

    EXTREMUM_T_VALUE_LABEL = "extremum_t_value_label"
    EXTREMUM_F_VALUE_LABEL = "extremum_f_value_label"

    START_SIMULATION_BUTTON = "start_simulation_button"
    STOP_SIMULATION_BUTTON = "stop_simulation_button"
    PREVIOUS_GENERATION_BUTTON = "previous_generation_button"
    NEXT_GENERATION_BUTTON = "next_generation_button"

    FUNCTION_GRAPH = "function_graph"
    VALUE_GRAPH = "value_graph"

    CURRENT_GENERATION_NUMBER = "current_generation_number"
    GENERATIONS_VALUES = "generations_values"


TARGET_FUNCTION_MIN_VALUE = 0
TARGET_FUNCTION_MAX_VALUE = 7
TARGET_FUNCTION_POINTS_NUMBER = 5000


def target_function(t: float) -> float:
    return (t + 1.3) * math.sin(0.5 * math.pi * t + 1)


class Lab1Application(QWidget):

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
        self.setWindowTitle('Деркач А.В. гр. 355841 - Лабораторная работа №1')

        self.top_level_layout = QHBoxLayout(self)
        self.left_layout = QVBoxLayout()
        self.right_layout = QVBoxLayout()

        self.right_layout.setSpacing(15)

        self.right_layout.setAlignment(QtCore.Qt.AlignTop)

        self.top_level_layout.addLayout(self.left_layout, stretch=4)
        self.top_level_layout.addLayout(self.right_layout, stretch=3)

        self.add_label(self.right_layout, None, 'Настройки', StyleSheet.LAYOUT_TITLE_LABEL.value, QtCore.Qt.AlignCenter)

        self.add_slider(self.right_layout, ObjectKeyWord.POPULATION_SIZE_SLIDER.value, 'Размер популяции:', 1, 500, lambda val: val)
        self.add_slider(self.right_layout, ObjectKeyWord.CHROMOSOMES_SIZE_SLIDER.value, 'Количество генов-бит:', 6, 18, lambda val: val)
        self.add_slider(self.right_layout, ObjectKeyWord.CROSSOVER_PROBABILITY_SLIDER.value, 'Вероятность кроссинговера:', 0, 100, lambda val: val / 100)
        self.add_slider(self.right_layout, ObjectKeyWord.MUTATION_PROBABILITY_SLIDER.value, 'Вероятность мутации:', 0, 100, lambda val: val / 100)
        self.add_slider(self.right_layout, ObjectKeyWord.MAX_GENERATIONS_NUMBER_SLIDER.value, 'Максимальное количество поколений', 2, 100, lambda val: val)
        self.add_button(self.right_layout, ObjectKeyWord.START_SIMULATION_BUTTON.value, 'Начать симуляцию', True, self.start_button_callback)
        self.add_button(self.right_layout, ObjectKeyWord.STOP_SIMULATION_BUTTON.value, 'Остановить симуляцию', False, self.stop_button_callback)

        generations_control_buttons_layout = QHBoxLayout()
        self.add_button(generations_control_buttons_layout, ObjectKeyWord.PREVIOUS_GENERATION_BUTTON.value, 'Предыдущее поколение', False, self.previous_generation_button_callback)
        self.add_button(generations_control_buttons_layout, ObjectKeyWord.NEXT_GENERATION_BUTTON.value,'Следующее поколение', False, self.next_generation_button_callback)
        self.right_layout.addLayout(generations_control_buttons_layout)

        self.right_layout.addSpacing(30)
        self.add_label(self.right_layout, None, 'Экстремум', StyleSheet.LAYOUT_TITLE_LABEL.value, QtCore.Qt.AlignCenter)

        extremum_t_layout = QHBoxLayout()
        self.add_label(extremum_t_layout, None, 'T: ', StyleSheet.LABEL.value, QtCore.Qt.AlignLeft, 15)
        self.add_label(extremum_t_layout, ObjectKeyWord.EXTREMUM_T_VALUE_LABEL.value, '-', StyleSheet.LABEL.value, QtCore.Qt.AlignLeft)
        self.right_layout.addLayout(extremum_t_layout)

        extremum_f_layout = QHBoxLayout()
        self.add_label(extremum_f_layout, None, 'F: ', StyleSheet.LABEL.value, QtCore.Qt.AlignLeft, 15)
        self.add_label(extremum_f_layout, ObjectKeyWord.EXTREMUM_F_VALUE_LABEL.value, '-', StyleSheet.LABEL.value, QtCore.Qt.AlignLeft)
        self.right_layout.addLayout(extremum_f_layout)

        current_generation_layout = QHBoxLayout()
        self.add_label(current_generation_layout, None, 'Текущее поколение: ', StyleSheet.LABEL.value, QtCore.Qt.AlignRight)
        self.add_label(current_generation_layout, ObjectKeyWord.CURRENT_GENERATION_NUMBER_VALUE_LABEL.value, '-', StyleSheet.LABEL.value, QtCore.Qt.AlignLeft)
        self.left_layout.addLayout(current_generation_layout)

        self.add_graph(self.left_layout, 5, ObjectKeyWord.FUNCTION_GRAPH.value)
        self.add_graph(self.left_layout, 1, ObjectKeyWord.VALUE_GRAPH.value)

        self.render_target_function_graph_plot(target_function, TARGET_FUNCTION_MIN_VALUE, TARGET_FUNCTION_MAX_VALUE, TARGET_FUNCTION_POINTS_NUMBER)
        self.show()

    def add_graph(self, parent: QLayout, layout_stretch: int, graph_key_word: str):
        graph = pg.PlotWidget()
        graph.setBackground('white')
        graph.showGrid(x=True, y=True)
        graph.addLegend()

        self.ui_objects[graph_key_word] = graph
        parent.addWidget(graph, stretch=layout_stretch)

    def add_slider(self, parent: QLayout, slider_key_word: str, slider_description: str, min_value: int, max_value: int, value_converter: tp.Callable):
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
        self.add_label(slider_layout, f'{slider_key_word}_value_label', f'{value_converter(init_value)}', StyleSheet.LABEL.value, QtCore.Qt.AlignLeft, 32)
        self.ui_objects[f'{slider_key_word}_value'] = value_converter(init_value)

        slider_layout.addWidget(slider)
        parent.addLayout(slider_layout)

    def build_slider_callback(self, slider_key_word: str, value_converter: tp.Callable):
        def callback(slider_value: int):
            value = value_converter(slider_value)
            self.ui_objects[f'{slider_key_word}_value'] = value
            self.ui_objects[f'{slider_key_word}_value_label'].setText(str(value))

        return callback

    def add_label(self, parent: QLayout, label_key_word: str, label_content: str, style_sheet: str, alignment: Qt.Alignment, size: int = None):
        label = QLabel()
        label.setText(label_content)
        label.setStyleSheet(style_sheet)
        label.setAlignment(alignment)

        if size is not None:
            label.setFixedWidth(size)

        if label_key_word is not None:
            self.ui_objects[label_key_word] = label

        parent.addWidget(label)

    def add_button(self, parent: QLayout, button_key_word: str, button_description: str, is_enabled: bool, button_callback: tp.Callable):
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

    def render_graphs(self):
        current_generation = self.ui_objects[ObjectKeyWord.CURRENT_GENERATION_NUMBER.value]
        current_generation_chromosomes = self.ui_objects[ObjectKeyWord.GENERATIONS_VALUES.value][current_generation - 1]
        current_generation_f = [target_function(chromosome) for chromosome in current_generation_chromosomes]
        extremum_t = np.max(current_generation_chromosomes)
        extremum_f = np.max(current_generation_f)

        self.ui_objects[ObjectKeyWord.EXTREMUM_T_VALUE_LABEL.value].setText(str(extremum_t))
        self.ui_objects[ObjectKeyWord.EXTREMUM_F_VALUE_LABEL.value].setText(str(extremum_f))

        self.ui_objects[ObjectKeyWord.CURRENT_GENERATION_NUMBER_VALUE_LABEL.value].setText(str(current_generation))

        self.ui_objects[ObjectKeyWord.FUNCTION_GRAPH.value].clear()
        self.ui_objects[ObjectKeyWord.VALUE_GRAPH.value].clear()

        self.render_target_function_graph_plot(target_function, TARGET_FUNCTION_MIN_VALUE, TARGET_FUNCTION_MAX_VALUE, TARGET_FUNCTION_POINTS_NUMBER)

        scatter = pg.ScatterPlotItem(pen=GraphColours.POINTS.value)
        scatter.setData(current_generation_chromosomes, current_generation_f)
        self.ui_objects[ObjectKeyWord.FUNCTION_GRAPH.value].addItem(scatter)

        best_f_values = []
        medium_f_values = []
        for generation_index in range(self.ui_objects[ObjectKeyWord.MAX_GENERATIONS_NUMBER_SLIDER_VALUE.value]):
            generation_chromosomes = self.ui_objects[ObjectKeyWord.GENERATIONS_VALUES.value][generation_index]
            generation_f = [target_function(chromosome) for chromosome in generation_chromosomes]

            best_f_values.append(np.max(generation_f))
            medium_f_values.append(np.mean(generation_f))

        self.ui_objects[ObjectKeyWord.VALUE_GRAPH.value].plot(range(len(best_f_values)), best_f_values, name='Лучшее значение', pen=GraphColours.POINTS.value)
        self.ui_objects[ObjectKeyWord.VALUE_GRAPH.value].plot(range(len(medium_f_values)), medium_f_values, name='Среднее значение', pen=GraphColours.LINES.value)

    def render_target_function_graph_plot(self, target_foo, t_min: float, t_max: float, num_point: int):
        scale = (t_max - t_min) / num_point
        trgt_x = [x * scale + t_min for x in range(num_point)]
        trgt_y = [target_foo(x) for x in trgt_x]
        trgt_x_range = (t_min, t_max)

        self.ui_objects[ObjectKeyWord.FUNCTION_GRAPH.value].setXRange(*trgt_x_range)
        self.ui_objects[ObjectKeyWord.FUNCTION_GRAPH.value].plot(trgt_x, trgt_y, pen=GraphColours.LINES.value)

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
        chromosomes = [int(random.uniform(0, 2 ** chromosomes_size)) for _ in range(population_size)]

        self.ui_objects[ObjectKeyWord.GENERATIONS_VALUES.value] = [self.convert_to_floats(chromosomes, chromosomes_size)]

        current_generation_population = chromosomes
        for generation_index in range(self.ui_objects[ObjectKeyWord.MAX_GENERATIONS_NUMBER_SLIDER_VALUE.value]):
            new_generation_population = self.simple_genetic_algorithm(current_generation_population, chromosomes_size)

            current_generation_population = new_generation_population
            self.ui_objects[ObjectKeyWord.GENERATIONS_VALUES.value].append(self.convert_to_floats(new_generation_population, chromosomes_size))

        self.render_graphs()

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

        self.render_graphs()

    def next_generation_button_callback(self):
        current_generation = self.ui_objects[ObjectKeyWord.CURRENT_GENERATION_NUMBER.value]
        max_generation = self.ui_objects[ObjectKeyWord.MAX_GENERATIONS_NUMBER_SLIDER_VALUE.value]

        current_generation += 1
        self.ui_objects[ObjectKeyWord.CURRENT_GENERATION_NUMBER.value] = current_generation
        self.enable_button(ObjectKeyWord.PREVIOUS_GENERATION_BUTTON.value, True)

        if current_generation >= max_generation:
            self.enable_button(ObjectKeyWord.NEXT_GENERATION_BUTTON.value, False)

        self.render_graphs()

    def simple_genetic_algorithm(self, chromosomes: list[int], chromosomes_size: int) -> list[int]:
        intermediate_chromosomes = self.reproduction_operator(chromosomes, chromosomes_size)
        intermediate_chromosomes = self.crossover_operator(intermediate_chromosomes, chromosomes_size)

        return self.mutation_operator(intermediate_chromosomes, chromosomes_size)

    def reproduction_operator(self, chromosomes: list[int], chromosomes_size: int) -> list[int]:
        float_chromosomes = self.convert_to_floats(chromosomes, chromosomes_size)
        f_values = [target_function(chromosome) for chromosome in float_chromosomes]
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
        return TARGET_FUNCTION_MIN_VALUE + number * (TARGET_FUNCTION_MAX_VALUE - TARGET_FUNCTION_MIN_VALUE) / (2 ** bits_length)


def main():
    app = QApplication(sys.argv)
    ex = Lab1Application()
    sys.exit(app.exec_())


if __name__ == '__main__':
    main()
