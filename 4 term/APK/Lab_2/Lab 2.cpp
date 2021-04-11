#include "stdio.h"
#include "windows.h"
#define SIZE 4

int main() {
	int ms1[SIZE][SIZE], ms2[SIZE][SIZE];
	int time0, time1, time2, time3, time4;
	long cnt = SIZE*SIZE;
	for (int i = 0; i < SIZE; i++) {
		for (int j = 0; j < SIZE; j++) {
			ms1[i][j] = i * SIZE + j * SIZE;
		}
	}
	printf("Entered matrix: \n");
	for (int i = 0; i < SIZE; i++) {
		for (int j = 0; j < SIZE; j++) {
			printf("%d ", ms1[i][j]);
		}
		printf("\n");
	}
	time0 = GetTickCount();

	printf("\nMMX:\n");
	for (int i = 0; i < 10000000; i++)
	{
		cnt = 16;
		__asm
		{
			push esi
			push edi
			mov ecx, [cnt]
			lea esi, [ms1 + ecx * 2]
			lea edi, [ms2 + ecx * 2]
			neg ecx
			loop1:
			movq mm0, [esi + ecx * 2]
			movq [edi + ecx * 2], mm0
			inc ecx
			jnz loop1
			emms
			pop edi
			pop esi
		}
	}
	printf("Matrix was copied...\n");
	time1 = GetTickCount() - time0;
	printf("Time = %d ms\n", time1);

	printf("\nAssembly:\n");
	for (int i = 0; i < 10000000; i++)
	{
		cnt = 16;
		__asm
		{
			push eax
			push ecx
			push esi
			xor esi, esi
			xor ecx, ecx
			loop2:
				movsx eax, ms1[esi]
				mov ms2[esi], eax
				add cx, ax
				add esi, 2
				sub cnt, 1
				jnz loop2
			pop esi
			pop ecx
			pop eax
		}
	}
	printf("Matrix was copied...\n");
	time2 = GetTickCount() - time0 - time1;
	printf("Time = %d ms\n", time2);

	printf("\nC:\n");
	for (int i = 0; i < 10000000; i++)
	{
		for (int i = 0; i < SIZE; i++) {
			for (int j = 0; j < SIZE; j++) {
				ms2[i][j] = ms1[i][j];
			}
		}
	}
	printf("Matrix was copied...\n");
	time3 = GetTickCount() - time0 - time1 - time2;
	printf("Time = %d ms\n", time3);

	printf("\nSSE:\n");
	for (int i = 0; i < 10000000; i++)
	{
		cnt = 16;
		__asm
		{
			push esi
			push edi
			mov ecx, [cnt]
			lea esi, [ms1 + ecx * 2] 
			lea edi, [ms2 + ecx * 2] 
			neg ecx
			loop3:
				movups xmm0, [esi + ecx * 2]
				movups [edi + ecx * 2], xmm0
				inc ecx
				jnz loop3
				emms
				pop edi
				pop esi
		}
	}
	printf("Matrix was copied...\n");
	time4 = GetTickCount() - time0 - time1 - time2-time3;
	printf("Time = %d ms\n", time4);
	return 0;
}