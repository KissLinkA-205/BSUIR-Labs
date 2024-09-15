#pragma once
#include "libraries.h"

template<typename T>
class QuadMatrix
{
public:
	T**** matrix;
	int lines;
	int columns;
	int includedLines;
	int includedColumns;

public:
	QuadMatrix(int lines, int columns, int includedLines, int includedColumns);
	~QuadMatrix();
	boolean equals(QuadMatrix<T>* anotherMatrix);

	void printToConsole();
	void fillWithRandomNumbers();
};

#include "QuadMatrix.inl"