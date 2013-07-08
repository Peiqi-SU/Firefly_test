#include <Wire.h>

#define UNIT_ID 0

int addr = 0;
struct Data {
  unsigned long timestamp;
  unsigned int voltage;
  unsigned char parity;
};
Data thisData;

void setup() 
{
  Wire.begin(); 
  Serial.begin(9600);

  // for debug ----------
  char somedata[] = "aaaabbcaaaabbc";
  i2c_eeprom_write_page(0x50, 0, (byte *)somedata, sizeof(somedata));
  delay(100); 
  Serial.println("Memory written");
  // for debug ----------end
}

void loop() {
  for(int i = 0; i < 100; i++) {
    char thisBuffer[7];
    i2c_eeprom_read_buffer(0x50, addr, (byte *)thisBuffer, sizeof(thisBuffer));
    Serial.println(thisBuffer);
    // Get the timastamp and voltage
    String theData = thisBuffer;
    thisData.timestamp = (long)theData.substring(0, 3);
    // Parity
    
    addr+=7;
    delay(5);
  }
}
