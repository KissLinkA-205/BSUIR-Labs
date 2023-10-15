/*
  Скетч для передатчика
  Подключите передатчик к 12 контакту Arduino
*/

#include <VirtualWire.h>

#define pinX A2  // ось X джойстика
#define pinY A1  // ось Y джойстика

const int MAX_AXIS_VALUE = 700;
const int MIN_AXIS_VALUE = 200;

char FORWARD = '1';
char BACK = '2';
char RIGHT = '3';
char LEFT = '4';
char STOP = '5'

char outputMessage[1];

void setup() {
  vw_setup(2000);

  pinMode(pinX, INPUT);
  pinMode(pinY, INPUT);
}

void loop() {
  int X = analogRead(pinX);
  int Y = analogRead(pinY);
  String output;

  if (X > MAX_AXIS_VALUE) {
    output = FORWARD;
  } else if (X < MIN_AXIS_VALUE) {
    output = BACK;
  } else if (Y > MAX_AXIS_VALUE) {
    output = RIGHT;
  } else if (Y < MIN_AXIS_VALUE) {
    output = LEFT;
  } else {
    output = STOP;
  }

  output.toCharArray(outputMessage, 2);
  send(outputMessage);
}

void send (char *message) {
  vw_send((uint8_t *)message, strlen(message)); //отправка сообщения
  vw_wait_tx(); // Ожидание полной отправки сообщения
}
