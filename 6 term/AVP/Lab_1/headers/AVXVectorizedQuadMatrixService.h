#pragma once
#include "QuadMatrix.h"

template<typename T>
class AVXVectorizedQuadMatrixService
{
private:
	void sumSubmatrices(T** firstMatrix, T** secondMatrix, int lines, int columns, T** resultMatrix);
	void multiplySubmatrices(T** firstMatrix, int firstMatrixLines, int firstMatrixColumns, T** secondMatrix, int secondMatrixColumns, T** resultMatrix);

public:
	QuadMatrix<T>* multiplyMatrices(QuadMatrix<T>& firstMatrix, QuadMatrix<T>& secondMatrix);
};

#include "AVXVectorizedQuadMatrixService.inl"