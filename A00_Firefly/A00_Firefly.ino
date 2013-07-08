/*
 * log the raw data of time and voltage, 
 and use Processing to convert the raw data.
 
 * Todo: add correct timestamp
 * 10 sets = one page + 1byte parity
 
 * 24LC256 = 32k-byte
 * Page Write Time 5 ms Max
 * 64-Byte Page Write Buffer
 * Active current 400 uA, typical
 * VCC range: 1.7-5.5V
 * the SDA bus requires a pull-up resistor to VCC,
 typical 10k for 100 kHz, 2k for 400 kHz and 1 MHz.
 
 * asm volatile("nop"); // stop
 
 * Structure
 * setup:
 * start time: year-month-day-hour-minute-second = unsigned long = 4-byte
 * loop:
 * time: hour5-minute6-second6 = 17-bit = unsigned long = 4-byte
 * voltage: 0-1023 = 10-bit = unsigned int = 2-byte
 * one page one parity: 8-bit = unsigned char = 1-byte
 * total: 7-byte; 10 sets + 1 parity = one page.
 */

#include <Wire.h>
#include "LowPower.h"

#define DEVICE_ADDRESS 0x50
#define UNIT_ID 0
#define NUM 10  // X sets per page
#define NUM_PAGE 5  // The EEPROM has 512 pages (32k/64)
#define PAGE_SIZE 64

int led = 12;
int EEPageAddress = 0;
unsigned int loopCounter = 0;
//unsigned char parity_temp,j;
struct Data {
  unsigned long timestamp[NUM];
  unsigned int voltage[NUM];
  unsigned char parity;
};
Data thisData;

void setup() {
  Wire.begin();
  Serial.begin(9600);
  pinMode(led, INPUT);
  digitalWrite(led, LOW);
  //  thisData.timestamp = 0;

  // Erase EEPROM
  char erase[PAGE_SIZE];
  for (int i = 0; i < PAGE_SIZE; i++){
    erase[i] = 0xFF;
  }
  for (int i = 0; i < NUM_PAGE; i++){
    i2c_eeprom_write_page(DEVICE_ADDRESS, EEPageAddress, (byte *)erase, PAGE_SIZE);
    EEPageAddress += PAGE_SIZE;
    delay(5); // Must delay 5ms
  }
  Serial.println("Done Erase");
  Serial.flush();
  EEPageAddress = 0;
}


void loop() {
  for(int i = 0; i < NUM; i++){
    loopCounter++;
    //    LowPower.powerDown(SLEEP_8S, ADC_OFF, BOD_OFF); // Will stop internal timer
    thisData.timestamp[i] = millis() + 2500*loopCounter;  // Timestamp
    Serial.print("time: ");
    Serial.println(thisData.timestamp[i]);
    thisData.voltage[i] = analogRead(A0);  // Voltage

    // Discharge: Light up the LED for __ms
    pinMode(led, OUTPUT);
    //LowPower.powerDown(SLEEP_500MS, ADC_OFF, BOD_OFF);
    pinMode(led, INPUT);

    if(i == NUM-1){
      // Parity
      unsigned char *pointer = (unsigned char *)&thisData;
      unsigned char parity_temp = 0;
      for(unsigned char j = 0; j < sizeof(Data)-1; j++){
        parity_temp += *pointer;
        pointer++;
      }
      parity_temp = ~parity_temp;
      thisData.parity = parity_temp;

      // Write EEPROM
      i2c_eeprom_write_page(DEVICE_ADDRESS, EEPageAddress, (byte *)&thisData, sizeof(thisData));
      EEPageAddress += PAGE_SIZE;
      Serial.println("Memory written");
      Serial.flush();
    }
  }
}




