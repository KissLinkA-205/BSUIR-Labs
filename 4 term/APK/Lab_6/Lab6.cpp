#include <io.h>
#include <dos.h>
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>

int exit_flag = 0;

void interrupt(*old9)(...);
void interrupt new9(...);

void indicator(int mask);

void main() {
	old9 = getvect(0x09); // сохраняем указатель на старый обработчик
	setvect(0x09, new9); // меняем его на новый
	while (!exit_flag) {
		indicator(4); // вкл. индикатор Caps Lock
		delay(600);
		indicator(0); // выкл. все индикаторы
		delay(600);
		system("cls");
		printf("Press ESC to exit program");
		printf("\nPress any key: ");
		
	}
	indicator(0); // выкл. все индикаторы
	setvect(0x09, old9); // возвращаем старый обработчик
}

void interrupt new9(...) {
	char buf[5];
	unsigned char c = inp(0x60); // считываем скан-код из порта клавиатуры
	if (c == 0x01) exit_flag = 1; // если это ESC устанавливаем флаг завершения программы
	if (c != 0xFA && !exit_flag) { // иначе выводим скан-код в шестнадцатиричной форме
		itoa(c, buf, 16);
		cputs("0x");
		cputs(buf);
		cputs(" ");
	}
	(*old9)();
}

void indicator(int mask) {
// перед отправлением маски отправляем код 0xED - код команды управления светодиодами клавиатуры
	if (mask != 0xED) indicator(0xED);
	int i = 0;
// ждем подтверждения, что внутренняя очередь команд процессора клавиатуры пуста (считываем слово состояния)
	while((inp(0x64) & 2) != 0); // 1 бит должен быть 0
// отправляем маску в порт клавиатуры
	do {
		i++;
		outp(0x60, mask);
	} while (inp(0x60) == 0xFE && i < 3); // проверяем код возврата 0xFA - успешно, 0xFE - необходима повторная отправка
	if (i == 3) {
		cputs("\nError: 0xFE - can't send mask\n");
		exit_flag = 1; // установка флага завершения программы
	}
}