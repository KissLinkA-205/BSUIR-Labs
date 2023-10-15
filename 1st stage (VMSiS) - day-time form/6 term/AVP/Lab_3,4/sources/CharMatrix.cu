//
// Created by Anzhalika Dziarkach on 23.02.2022.
//

#include <iostream>
#include "CharMatrix.cuh"

#define FRAGMENT_SIZE 5

CharMatrix::CharMatrix(long long lines, long long columns) {
    if (lines <= 0 || columns <= 0) {
        std::cerr << "Exception (CharMatrix constructor): matrix dimensions must be greater than 0!" << std::endl;
        this->lines = 0;
        this->columns = 0;
        this->matrix = new char[0];
        return;
    }
    this->lines = lines;
    this->columns = columns;

    this->matrix = new char[lines * columns * sizeof(char)];
    for (auto i = 0; i < lines * columns; i++) {
        matrix[i] = '0';
    }
}

CharMatrix::~CharMatrix() {
    free(this->matrix);
}

char *CharMatrix::getMatrix() {
    return this->matrix;
}

long long CharMatrix::getLines() {
    return this->lines;
}

long long CharMatrix::getColumns() {
    return this->columns;
}

bool CharMatrix::equals(const CharMatrix &anotherMatrix) {
    if (this->lines != anotherMatrix.lines || this->columns != anotherMatrix.columns) {
        return false;
    }

    for (auto i = 0; i < this->lines * this->columns; i++) {
        if (this->matrix[i] != anotherMatrix.matrix[i]) {
            return false;
        }
    }

    return true;
}

void CharMatrix::printToConsole() {
    for (auto i = 0; i < this->lines; i++) {
        for (auto j = 0; j < this->columns; j++) {
            std::cout << matrix[i * columns + j] << ' ';
        }
        std::cout << '\n';
    }
}

void CharMatrix::printFragmentToConsole() {
    for (auto i = 0; i < FRAGMENT_SIZE; i++) {
        for (auto j = 0; j < FRAGMENT_SIZE; j++) {
            std::cout << matrix[i * columns + j] << ' ';
        }
        std::cout << '\n';
    }
}

void CharMatrix::fillWithRandomSymbols() {
    for (auto i = 0; i < this->lines; i++) {
        for (auto j = 0; j < this->columns; j++) {
            matrix[i * columns + j] = rand() % 100 + '0';
        }
    }
}
