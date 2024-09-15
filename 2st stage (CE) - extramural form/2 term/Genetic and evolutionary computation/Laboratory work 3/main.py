import sys
from PyQt5.QtWidgets import *
from PyQt5 import QtCore
from pyqtgraph import PlotWidget, plot
import pyqtgraph as pg
import typing as tp
import math
import random
import numpy as np
import matplotlib.pyplot as plt
import tsplib95

np.random.seed(42)
random.seed(42)


class CitiesDataset:

    def __init__(self, dataset_path):
        self.problem = tsplib95.load(dataset_path)
        self.as_dict = self.problem.as_dict()
        self.nodes_num = self.as_dict['dimension']
        coords = self.as_dict['node_coords']
        self.x = [coords[i][0] for i in range(1, self.nodes_num + 1)]
        self.y = [coords[i][1] for i in range(1, self.nodes_num + 1)]

    class Route:
        def __init__(self, citiesOrder, owner):
            self.order = citiesOrder
            if len(self.order) != owner.nodes_num:
                raise RuntimeError('Invalid route size: ', len(self.order))
            if len(set(self.order)) != owner.nodes_num:
                raise RuntimeError('Invalid route(cycles): ', self.order)
            self.owner = owner
            self._calculate_cost_impl()

        def __getitem__(self, idx):
            x = self.owner.x[self.order[idx]]
            y = self.owner.y[self.order[idx]]
            return (x, y)

        def get_coords_matrix(self):
            nodes_num = self.owner.nodes_num
            return np.array(list(map(self.__getitem__, range(nodes_num))))

        def _calculate_cost_impl(self):
            coords = self.get_coords_matrix()
            pointwise_diff = coords[1:] - coords[:-1]
            squared = pointwise_diff ** 2
            pointwise_dist = np.sum(squared, axis=1) ** 0.5
            self.cost_value = pointwise_dist.sum()

        @property
        def cost(self):
            return self.cost_value

        def __str__(self):
            incr = [x + 1 for x in self.order]
            return str(incr)

        def __repr__(self) -> str:
            return self.__str__()

        def _get_split_pos(self, low_bound):
            num_cities = self.owner.nodes_num

            def random_split():
                return np.random.randint(low_bound, num_cities)

            left_bound = random_split()
            right_bound = random_split()
            while right_bound == left_bound:
                right_bound = random_split()
            if left_bound > right_bound:
                right_bound, left_bound = left_bound, right_bound
            return left_bound, right_bound

        def crossingover(self, other):
            # return self, other
            num_cities = self.owner.nodes_num
            left_bound, right_bound = self._get_split_pos(1)

            direct_map = dict()
            rev_map = dict()
            for i in range(left_bound, right_bound):
                node_left = self.order[i]
                node_right = other.order[i]
                direct_map[node_left] = node_right
                rev_map[node_right] = node_left

            def create_successor(ancestor1, ancestor2, lookup):
                successor = []
                common = ancestor2[left_bound:right_bound]
                for i in range(num_cities):
                    next_value = None
                    if left_bound <= i < right_bound:
                        next_value = ancestor2[i]
                    else:
                        next_value = ancestor1[i]
                        if next_value in lookup:
                            next_value = lookup[next_value]
                            if next_value in common:  # supress conflict
                                next_value = None
                    successor.append(next_value)
                unmatched_nodes = set(range(num_cities)).difference(set(successor))
                unmatched_nodes = list(unmatched_nodes)
                random.shuffle(unmatched_nodes)
                if unmatched_nodes:
                    for i, v in enumerate(successor):
                        if v is None:
                            successor[i] = unmatched_nodes[0]
                            del unmatched_nodes[0]
                return self.owner.create_route(successor)

            successor1 = create_successor(self.order, other.order, rev_map)
            successor2 = create_successor(other.order, self.order, direct_map)
            return successor1, successor2

        def mutate(self):
            left_bound, right_bound = self._get_split_pos(0)
            self.order[left_bound], self.order[right_bound] = self.order[right_bound], self.order[left_bound]

    def create_route(self, cities_order):
        return self.Route(list(cities_order), self)

    def render(self, graph_widget):
        pen = pg.mkPen(color=(0, 0, 255))
        scatter = pg.ScatterPlotItem(pen=pen)
        scatter.setData(self.x, self.y)
        graph_widget.addItem(scatter)

    def render_route(self, graph, route):
        pen = pg.mkPen(color=(255, 0, 0))
        points = route.get_coords_matrix()

        x = points[:, 0]
        y = points[:, 1]

        graph.plot(x, y, pen=pen)

    def calculate_route_cost(self, route):
        return route.cost


DATASET = CitiesDataset('berlin52.tsp')


class Generation:
    def __init__(self, entities: tp.List[CitiesDataset.Route], p_cross: float, p_mut: float):
        self.entities = entities
        self.p_cross = p_cross
        self.p_mut = p_mut

        self.costs = np.array([DATASET.calculate_route_cost(r)
                               for r in self.entities])
        self.best_value = self.costs.min()
        self.mean_value = self.costs.mean()
        self.best_route = self.entities[0]
        for r in self.entities:
            if r.cost < self.best_route.cost:
                self.best_route = r

    def render_on_graph(self, graph: pg.PlotWidget):
        for e in self.entities:
            if e.cost == self.best_value:
                DATASET.render_route(graph, e)

    def reproduce_random_wheel(self):
        costs = self.costs
        normalized_costs = costs / costs.sum()
        binded_entities = list(zip(self.entities, normalized_costs))
        sorted_entites = sorted(binded_entities, key=lambda x: x[1])
        new_entites = list(map(lambda x: x[0], sorted_entites))
        new_probabilities = list(map(lambda x: x[1], sorted_entites))
        new_probabilities = new_probabilities[::-1]

        new_generation = np.random.choice(
            new_entites, len(self.entities), new_probabilities)
        return list(new_generation)

    def reproduce_softmax(self):
        costs = self.costs
        costs /= costs.min()
        exp_cost = np.exp(-costs)
        probabilities = exp_cost / exp_cost.sum()

        new_generation = np.random.choice(
            self.entities, len(self.entities), list(probabilities))
        return list(new_generation)

    def reproduce(self):
        return self.reproduce_softmax()

    def crossingover(self, prev_gen):
        def erase_entity(entities, idx):
            v = entities[idx]
            del entities[idx]
            return v

        def choose_entity(entities):
            idx = np.random.randint(0, len(entities))
            return erase_entity(entities, idx)

        new_generation = []
        while len(prev_gen) >= 2:
            entity1 = choose_entity(prev_gen)
            entity2 = choose_entity(prev_gen)

            if np.random.uniform() > self.p_cross:
                new_generation += [entity1, entity2]
            else:
                new_generation += list(entity1.crossingover(entity2))

        new_generation += prev_gen  # те кто не поучаствовал в кроссинговре
        return new_generation

    def mutate(self, entities):
        for entity in entities:
            if np.random.uniform() <= self.p_mut:
                entity.mutate()

    def algorithm(self):
        intermidiate_gen = self.reproduce()
        intermidiate_gen = self.crossingover(intermidiate_gen)
        self.mutate(intermidiate_gen)

        return Generation(list(intermidiate_gen), self.p_cross, self.p_mut)


class Lab1(QWidget):
    MAX_ENTITIES = 1000

    def __init__(self):
        super().__init__()
        self.objects = dict()
        self.lockable_objects = set()
        self.generations = []
        self.current_gen_id = None
        self.max_gens = None

        self.initUI()
        self.render_cities_map()

    def render_cities_map(self):
        DATASET.render(self.graph)

    def initUI(self):

        self.setGeometry(300, 300, 1200, 800)
        self.setMinimumSize(1200, 800)
        self.setWindowTitle('Lab3')

        self.top_level_layout = QHBoxLayout(self)
        self.left_layout = QVBoxLayout()
        self.right_layout = QVBoxLayout()
        self.right_layout.setAlignment(QtCore.Qt.AlignTop)

        self.top_level_layout.addLayout(self.left_layout, stretch=5)
        self.top_level_layout.addLayout(self.right_layout, stretch=2)

        cfgLabel = QLabel('Настройки')
        cfgLabel.setAlignment(QtCore.Qt.AlignCenter)
        self.right_layout.addWidget(cfgLabel)

        self._add_slider('numEntities', 'Мощность популяции:',
                         1, self.MAX_ENTITIES, lambda val: val)
        self._add_slider('probCross', 'Вероятность кроссинговера:',
                         0, 100, lambda val: val / 100)
        self._add_slider('probMut', 'Вероятность мутации:',
                         0, 100, lambda val: val / 100)
        self._add_slider('numGen', 'Max N поколений:', 2, 100, lambda val: val)

        self.sim_button = QPushButton('Начать симуляцию')
        self.sim_button.released.connect(self.onSimulatePress)
        self.right_layout.addWidget(self.sim_button)
        self.lockable_objects.add(self.sim_button)

        self.prev_gen_button = QPushButton('Предыдущее поколение')
        self.prev_gen_button.setEnabled(False)
        self.prev_gen_button.released.connect(self.on_show_prev)

        self.next_gen_button = QPushButton('Следующее поколение')
        self.next_gen_button.setEnabled(False)
        self.next_gen_button.released.connect(self.on_show_next)

        ctrlButtonsLayout = QHBoxLayout()
        ctrlButtonsLayout.addWidget(self.prev_gen_button)
        ctrlButtonsLayout.addWidget(self.next_gen_button)
        self.right_layout.addLayout(ctrlButtonsLayout)

        self.best_label = QLabel('Лучшее значение:')
        self.best_label.setWordWrap(True)
        self.right_layout.addWidget(self.best_label)

        self.graphs_layout = QVBoxLayout()

        self.gen_label = QLabel('Текущее поколение:')
        self.gen_label.setAlignment(QtCore.Qt.AlignCenter)

        self.graph = pg.PlotWidget()
        self.graph.setBackground('w')
        self.graph.showGrid(x=True, y=True)
        self.graph_pen = pg.mkPen(color=(255, 0, 0))

        self.history_graph = pg.PlotWidget()
        self.history_graph.setBackground('w')
        self.history_graph.showGrid(x=True, y=True)
        self.history_graph.addLegend()

        self.graphs_layout.addWidget(self.gen_label)
        self.graphs_layout.addWidget(self.graph, stretch=5)
        self.graphs_layout.addWidget(self.history_graph, stretch=1)

        self.left_layout.addLayout(self.graphs_layout)

        self.show()

    def on_show_prev(self):
        if self.current_gen_id == 0:
            return
        self.current_gen_id -= 1

        if self.current_gen_id == 0:
            self.prev_gen_button.setEnabled(False)

        if self.current_gen_id + 1 == self.max_gens:
            self.next_gen_button.setEnabled(True)

        self.render_graphs()

    def on_show_next(self):
        if self.current_gen_id + 1 == self.max_gens:
            return

        if self.current_gen_id == 0:
            self.prev_gen_button.setEnabled(True)
        if self.current_gen_id + 2 == self.max_gens:
            self.next_gen_button.setEnabled(False)

        self.current_gen_id += 1
        self.render_graphs()

    def _add_label(self, parent: QLayout, key_word: str, content: str):
        label = QLabel()
        label.setText(content)
        self.objects[f'{key_word}_label'] = label

        value_label = QLabel()
        value_label.setFixedWidth(35)
        self.objects[f'{key_word}_value_label'] = value_label

        parent.addWidget(label)
        parent.addWidget(value_label)

    def _add_slider(self, key_word: str, label_content: str, min_value: int, max_value: int, converter: tp.Callable,
                    extra_callback: tp.Optional[tp.Callable] = None):
        local_layout = QHBoxLayout()
        self._add_label(local_layout, key_word, label_content)

        slider = QSlider(QtCore.Qt.Horizontal)
        slider.setMinimum(min_value)
        slider.setMaximum(max_value)
        slider.setTickPosition(QSlider.TickPosition.NoTicks)
        self.objects[f'{key_word}_slider'] = slider

        def createCallback(objects, key, extra_cb):
            def callback(slider_value: int):
                value = converter(slider_value)
                objects[f'{key}_value'] = value
                objects[f'{key}_value_label'].setText(str(value))
                if extra_cb is not None:
                    extra_cb()

            return callback

        on_action_callback = createCallback(
            self.objects, key_word, extra_callback)
        slider.valueChanged.connect(on_action_callback)
        init_value = (min_value + max_value) // 2
        slider.setValue(init_value)

        self.lockable_objects.add(slider)

        local_layout.addWidget(slider)

        self.right_layout.addLayout(local_layout)

    def _get_value(self, key: str):
        return self.objects[f'{key}_value']

    def render_graphs(self):
        self.gen_label.setText(f'Текущее поколение: {self.current_gen_id}')
        self.graph.clear()
        self.history_graph.clear()
        self.render_cities_map()

        if self.current_gen_id is not None:
            gen = self.generations[self.current_gen_id]
            gen.render_on_graph(self.graph)
            label_content = f'Лучший маршрут {gen.best_route}'
            self.best_label.setText(label_content)

        self.history_graph.plot(self.gen_x_axis, np.array(self.best_vals) / 2.8,
                                name='Лучшее значение', pen=pg.mkPen(color=(255, 0, 0)))
        self.history_graph.plot(self.gen_x_axis, np.array(self.mean_vals) / 2.8,
                                name='Среднее значение', pen=pg.mkPen(color=(0, 0, 255)))

    def _create_gen0(self):
        base_arr = np.array(range(DATASET.nodes_num))
        gen0 = []
        for _ in range(self._get_value('numEntities')):
            np.random.shuffle(base_arr)
            next_gen = base_arr.copy()
            gen0.append(DATASET.create_route(next_gen))
        return gen0

    def onSimulatePress(self):
        self.next_gen_button.setEnabled(False)
        self.prev_gen_button.setEnabled(False)

        for widget in self.lockable_objects:
            widget.setEnabled(False)

        self.current_gen_id = 0

        gen0_entities = self._create_gen0()
        gen0 = Generation(gen0_entities, self._get_value(
            'probCross'), self._get_value('probMut'))

        self.generations = [gen0]
        self.max_gens = self._get_value('numGen')

        for _ in range(self.max_gens):
            last_gen = self.generations[-1]
            new_gen = last_gen.algorithm()

            self.generations.append(new_gen)

        self.best_vals = [gen.best_value for gen in self.generations]
        self.mean_vals = [gen.mean_value for gen in self.generations]
        self.gen_x_axis = range(len(self.generations))

        for widget in self.lockable_objects:
            widget.setEnabled(True)

        self.render_graphs()
        self.next_gen_button.setEnabled(True)


def main():
    app = QApplication(sys.argv)
    ex = Lab1()
    sys.exit(app.exec_())


if __name__ == '__main__':
    main()
