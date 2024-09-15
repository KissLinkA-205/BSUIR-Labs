#ifndef QUAD_MATRIX_INL
#define QUAD_MATRIX_INL

#include "QuadMatrix.h"

template<typename T>
QuadMatrix<T>::QuadMatrix(int lines, int columns, int includedLines, int includedColumns) {
	this->lines = lines;
	this->columns = columns;
	this->includedLines = includedLines;
	this->includedColumns = includedColumns;
	this->matrix = new T * **[lines];

	for (int i = 0; i < lines; i++) {
		this->matrix[i] = new T * *[columns];
		for (int j = 0; j < columns; j++) {
			this->matrix[i][j] = new T * [includedLines];
			for (int k = 0; k < includedLines; k++) {
				this->matrix[i][j][k] = new T[includedColumns];
				for (int t = 0; t < includedColumns; t++) {
					this->matrix[i][j][k][t] = 0;
				}
			}
		}
	}
}

template<typename T>
QuadMatrix<T>::~QuadMatrix() {
	for (auto i = 0; i < lines; i++) {
		for (auto j = 0; j < columns; j++) {
			for (auto k = 0; k < includedLines; k++) {
				delete[] this->matrix[i][j][k];
			}
			delete[] this->matrix[i][j];
		}
		delete[] this->matrix[i];
	}
	delete[] this->matrix;
}

template<typename T>
boolean QuadMatrix<T>::equals(QuadMatrix<T>* anotherMatrix) {
	if (this->lines != anotherMatrix->lines || this->columns != anotherMatrix->columns
		|| this->includedLines != anotherMatrix->includedLines || this->includedColumns != anotherMatrix->includedColumns) {
		return false;
	}

	for (auto m = 0; m < this->lines; m++) {
		for (auto n = 0; n < this->columns; n++) {
			for (auto i = 0; i < this->includedLines; i++) {
				for (auto j = 0; j < this->includedColumns; j++) {
					if (this->matrix[m][n][i][j] != anotherMatrix->matrix[m][n][i][j]) {
						return false;
					}
				}
			}
		}
	}
	return true;
}

template<typename T>
void QuadMatrix<T>::printToConsole() {
	for (int i = 0; i < this->lines; i++) {
		for (int j = 0; j < this->columns; j++) {
			std::cout << '{';
			for (int k = 0; k < this->includedLines; k++) {
				std::cout << '[';
				for (int t = 0; t < this->includedColumns; t++) {
					std::cout << matrix[i][j][k][t];
					if (t != this->includedColumns - 1) {
						std::cout << ' ';
					}
				}
				std::cout << ']';
			}
			std::cout << '}';
			if (j != this->columns - 1) {
				std::cout << ' ';
			}
		}
		std::cout << '\n';
	}
}

template<typename T>
void QuadMatrix<T>::fillWithRandomNumbers() {
	for (int i = 0; i < this->lines; i++) {
		for (int j = 0; j < this->columns; j++) {
			for (int k = 0; k < this->includedLines; k++) {
				for (int t = 0; t < this->includedColumns; t++) {
					matrix[i][j][k][t] = rand() % 10;
				}
			}
		}
	}
}

#endif