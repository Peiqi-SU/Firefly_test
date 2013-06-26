#include "LowPower.h"

int led = 12;
long previousMillis = 0;
long ledLighting = 10; // LED lights up for 2ms for discharging the capcitor

void setup() {
  Serial.begin(9600);
  pinMode(led, INPUT);
  digitalWrite(led, LOW);
}


void loop() {
  LowPower.powerDown(SLEEP_2S, ADC_OFF, BOD_OFF);
  // read data per 1sec
  Serial.println(analogRead(A0) * (3.3 / 1024.0));
  Serial.flush();
  // discharge for 2ms
  pinMode(led, OUTPUT);
  unsigned long currentMillis = millis();
  if(currentMillis - previousMillis > ledLighting) {
    previousMillis = currentMillis;
    pinMode(led, INPUT);
  }
}



