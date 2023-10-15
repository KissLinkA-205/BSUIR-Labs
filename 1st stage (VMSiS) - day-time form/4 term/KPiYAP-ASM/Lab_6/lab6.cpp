#include "stdio.h"
#include "windows.h"

#define SIZE 10
float array[SIZE];

void inputArray();
void outputArray();
void asmAlgorithm();

int main() {
	inputArray();
	printf("Input array: \n");
	outputArray();

	asmAlgorithm();

	printf("\nResult array: \n");
	outputArray();

	return 0;
}

void inputArray() {
	int res;
	printf("Input 10 elements: \n");

	for (int i = 0; i < SIZE; ++i) {
		do {
			res = scanf_s("%f", &array[i]);
			while (getchar() != '\n');
			if (res != 1) printf("Invalid input\n");
		} while (res != 1);
	}
}

void outputArray() {
	for (int i = 0; i < SIZE; ++i) {
		printf("%.3f ", array[i]);
	}
}

void asmAlgorithm() {
	__asm {
		finit //инициализация сопроцессора

		xor ecx, ecx
		mov ecx, SIZE / 2
		lea ebx, array

		calculate_loop:
			fld[ebx] //загрузить ebx в стек
			fsin 
			fstp[ebx] //cохранить вещественное значение с извлечением из стека

			add ebx, 4

			fld[ebx] //загрузить ebx в стек
			fcos 
			fstp[ebx] //cохранить вещественное значение с извлечением из стека

			add ebx, 4
		loop calculate_loop

		fwait //синхронизировать
	}
}