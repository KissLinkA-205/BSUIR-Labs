#include "QuadMatrix.h"
#include "AutoVectorizedQuadMatrixService.h"
#include "NotVectorizedQuadMatrixService.h"
#include "AVXVectorizedQuadMatrixService.h"

#define GREEN 0x02
#define RED 0x0C
#define WHITE 0x07
#define YELLOW 0x06

void changeConsoleColor(int color)
{
	HANDLE hConsole = GetStdHandle(STD_OUTPUT_HANDLE);
	SetConsoleTextAttribute(hConsole, (WORD)((0 << 4) | color));
}

int main() {
	srand(time(0));
	changeConsoleColor(WHITE);
	using namespace std::chrono;
	AutoVectorizedQuadMatrixService<float> autoVectorizedService = AutoVectorizedQuadMatrixService<float>();
	NotVectorizedQuadMatrixService<float> notVectorizedService = NotVectorizedQuadMatrixService<float>();
	AVXVectorizedQuadMatrixService<float> avxVectorizedService = AVXVectorizedQuadMatrixService<float>();

	QuadMatrix<float> a = QuadMatrix<float>(140, 140, 8, 2);
	QuadMatrix<float> b = QuadMatrix<float>(140, 140, 2, 8);
	QuadMatrix<float>* c = new QuadMatrix<float>(a.lines, b.columns, a.includedLines, b.includedColumns);
	QuadMatrix<float>* d = new QuadMatrix<float>(a.lines, b.columns, a.includedLines, b.includedColumns);
	a.fillWithRandomNumbers();
	b.fillWithRandomNumbers();

	high_resolution_clock::time_point t1 = high_resolution_clock::now();
	c = notVectorizedService.multiplyMatrices(a, b);
	high_resolution_clock::time_point t2 = high_resolution_clock::now();
	duration<double> time_span = duration_cast<duration<double>>(t2 - t1);
	std::cout << "Without vectorization: ";
	changeConsoleColor(RED);
	std::cout << time_span.count() << " seconds.";
	std::cout << std::endl;

	changeConsoleColor(WHITE);
	high_resolution_clock::time_point t3 = high_resolution_clock::now();
	c = autoVectorizedService.multiplyMatrices(a, b);
	high_resolution_clock::time_point t4 = high_resolution_clock::now();
	duration<double> time_span2 = duration_cast<duration<double>>(t4 - t3);
	std::cout << "Auto vectorization: ";
	changeConsoleColor(YELLOW);
	std::cout << time_span2.count() << " seconds.";
	std::cout << std::endl;

	changeConsoleColor(WHITE);
	high_resolution_clock::time_point t5 = high_resolution_clock::now();
	d = avxVectorizedService.multiplyMatrices(a, b);
	high_resolution_clock::time_point t6 = high_resolution_clock::now();
	duration<double> time_span3 = duration_cast<duration<double>>(t6 - t5);
	std::cout << "SSE vectorization: ";
	changeConsoleColor(GREEN);
	std::cout << time_span3.count() << " seconds.";
	std::cout << std::endl << std::endl;

	if (c->equals(d) == true) {
		changeConsoleColor(GREEN);
		std::cout << "Matrices are the same :)" << std::endl;
	} else {
		changeConsoleColor(RED);
		std::cout << "Matrices are not the same :(" << std::endl;
	}
	changeConsoleColor(WHITE);

	return 0;
}