#ifndef AVX_VECTORIZED_QUAD_MATRIX_SERVICE_INL
#define AVX_VECTORIZED_QUAD_MATRIX_SERVICE_INL

#include "AVXVectorizedQuadMatrixService.h"

template<typename T>
QuadMatrix<T>* AVXVectorizedQuadMatrixService<T>::multiplyMatrices(QuadMatrix<T>& firstMatrix, QuadMatrix<T>& secondMatrix) {
	QuadMatrix<T>* resultMatrix = new QuadMatrix<T>(firstMatrix.lines, secondMatrix.columns, firstMatrix.includedLines, secondMatrix.includedColumns);
	T** __restrict temp = new T * [firstMatrix.includedLines];

	for (auto m = 0; m < firstMatrix.lines; m++) {
		for (auto n = 0; n < secondMatrix.columns; n++) {
			for (auto l = 0; l < firstMatrix.columns; l++) {
				multiplySubmatrices(firstMatrix.matrix[m][l], firstMatrix.includedLines, firstMatrix.includedColumns,
					secondMatrix.matrix[l][n], secondMatrix.includedColumns, resultMatrix->matrix[m][n]);
			}
		}
	}

	return resultMatrix;
}

template<typename T>
void AVXVectorizedQuadMatrixService<T>::multiplySubmatrices(T** firstMatrix, int firstMatrixLines, int firstMatrixColumns,
	T** secondMatrix, int secondMatrixColumns, T** resultMatrix) {
	for (auto i = 0; i < firstMatrixLines; i++) {
		for (auto k = 0; k < firstMatrixColumns; k++) {
			for (auto j = 0; j < secondMatrixColumns; j += 8) {
				_mm256_storeu_ps((float*)resultMatrix[i] + j, _mm256_add_ps(_mm256_loadu_ps((const float*)resultMatrix[i] + j), 
					_mm256_mul_ps(_mm256_set1_ps((const float)firstMatrix[i][k]), _mm256_loadu_ps((const float*)secondMatrix[k] + j))));
			}
		}
	}
}

template<typename T>
void AVXVectorizedQuadMatrixService<T>::sumSubmatrices(T** firstMatrix, T** secondMatrix, int lines, int columns, T** resultMatrix) {
	for (int i = 0; i < lines; i++) {
		for (int j = 0; j < columns; j += 8) {
			_mm256_storeu_ps((float*)resultMatrix[i] + j, _mm256_add_ps(_mm_loadu_ps((float*)firstMatrix[i] + j), _mm256_loadu_ps((float*)secondMatrix[i] + j)));
		}
	}
}

#endif