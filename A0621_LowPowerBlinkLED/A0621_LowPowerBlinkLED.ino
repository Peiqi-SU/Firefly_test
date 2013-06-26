#include "LowPower.h"
int led = 13;

void setup()
{
  Serial.begin(9600);
  // No setup is required for this library
    pinMode(led, OUTPUT);
}

void loop() 
{
  // Enter power down state for 8 s with ADC and BOD module disabled
  LowPower.powerDown(SLEEP_1S, ADC_OFF, BOD_OFF);  

  digitalWrite(led, HIGH);
  delay(1);
  digitalWrite(led, LOW);
}

