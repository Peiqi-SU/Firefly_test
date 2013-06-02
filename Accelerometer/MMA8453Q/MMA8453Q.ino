#include <Wire.h>

#include <MMA8453_n0m1.h>

#include <I2C.h>

MMA8453_n0m1 accel;

void setup() {
  Serial.begin(9600);
  accel.dataMode(false, 2);
}

void loop() {
  accel.update();
  Serial.println(accel.x());
  Serial.println(accel.y());
  Serial.println(accel.z());
  delay(1000);
}


