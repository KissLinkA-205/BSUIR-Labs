/*
  Скетч для приемника
  Подключите приемник к 11 контакту Arduino
*/

#include <VirtualWire.h>
#include <NewPing.h>

#define motor_IN1 4
#define motor_IN2 5
#define motor_IN3 6
#define motor_IN4 7

#define headlights 13
#define side_lights 12

#define light_sensor_D0 A1

#define trigPin  8
#define echoPin  9

#define MQ5_digitalSignal  2
#define MQ5_analogSignal  A0
#define soundPin  10

byte message[VW_MAX_MESSAGE_LEN]; // Массив входящих сообщений
byte messageLength = VW_MAX_MESSAGE_LEN; // Размер массива входящих сообщений

int stops;
boolean isGas; //переменная для хранения значения о присутствии газа
int gasValue = 0; //переменная для хранения количества газа

int PERMISSIBLE_GAS_VALUE = 300;
int MIN_DISTANCE_BEFORE_STOP = 12;

char BACK = '1';
char FORWARD = '2';
char LEFT = '3';
char RIGHT = '4';

void setup() {
  vw_setup(2000);
  vw_rx_start(); // Активировать процесс приемника.

  pinMode(motor_IN1, OUTPUT);
  pinMode(motor_IN2, OUTPUT);
  pinMode(motor_IN3, OUTPUT);
  pinMode(motor_IN4, OUTPUT);

  pinMode (light_sensor_D0, INPUT);
  pinMode(headlights, OUTPUT);

  pinMode(trigPin, OUTPUT); 
  pinMode(echoPin, INPUT); 
  pinMode(side_lights, OUTPUT);

  pinMode(MQ5_digitalSignal, INPUT);
  pinMode(soundPin, OUTPUT);
}

void loop() {
  checkIllumination();
  checkDistanceToObject();
  checkOfGas();

  if (vw_get_message(message, &messageLength)) {
    selectStateOfMotors(message[0]);
  }
}

void checkIllumination() {
  int xD0 = digitalRead (light_sensor_D0);

  if (xD0 == HIGH) {
    digitalWrite (headlights, HIGH);
  }
  else {
    digitalWrite (headlights, LOW);
  }
}

void checkDistanceToObject() {
  int duration, cm;
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);

  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  duration = pulseIn(echoPin, HIGH);

  cm = duration / 58; // вычисляем расстояние в сантиметрах

  if (cm < MIN_DISTANCE_BEFORE_STOP && cm > 0) {
    stops = 1;
    digitalWrite (side_lights, HIGH);

  } else {
    stops = 0;
    digitalWrite (side_lights, LOW);
  }
}

void checkOfGas() {
  isGas = digitalRead(MQ5_digitalSignal); //считываем значение о присутствии газа
  gasValue = analogRead(MQ5_analogSignal); // и о его количестве

  if (gasValue < PERMISSIBLE_GAS_VALUE) {
    turnOffSound();
  }
  else {
    turnOnSound();
  }
}

void turnOnSound() {
  digitalWrite(soundPin, 50); // включаем пьезодинамик
}

void turnOffSound() {
  digitalWrite(soundPin, 0); // отключаем пьезодинамик
}

void selectStateOfMotors(char state) {

  if (state == BACK) {
    mooveBack();

  } else if (state == FORWARD && stops == 0) {
    mooveForward();

  } else if (state == LEFT) {
    turnLeft();

  } else if (state == RIGHT) {
    turnRight();

  } else {
    stand();
  }
}

void mooveForward() {
  digitalWrite(motor_IN1, LOW);
  digitalWrite(motor_IN2, HIGH);
  digitalWrite(motor_IN3, LOW);
  digitalWrite(motor_IN4, HIGH);
}

void mooveBack() {
  digitalWrite(motor_IN1, HIGH);
  digitalWrite(motor_IN2, LOW);
  digitalWrite(motor_IN3, HIGH);
  digitalWrite(motor_IN4, LOW);
}

void turnLeft() {
  digitalWrite(motor_IN1, LOW);
  digitalWrite(motor_IN2, HIGH);

  digitalWrite(motor_IN3, HIGH);
  digitalWrite(motor_IN4, LOW);
}

void turnRight() {
  digitalWrite(motor_IN1, HIGH);
  digitalWrite(motor_IN2, LOW);

  digitalWrite(motor_IN3, LOW);
  digitalWrite(motor_IN4, HIGH);
}

void stand() {
  digitalWrite(motor_IN1, LOW);
  digitalWrite(motor_IN2, LOW);
  digitalWrite(motor_IN3, LOW);
  digitalWrite(motor_IN4, LOW);
}
