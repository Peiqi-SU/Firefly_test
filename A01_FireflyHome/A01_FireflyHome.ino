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
  char somedata[] = "000010231111102322221023000010231111102322221023";
  i2c_eeprom_write_page(0x50, 0, (byte *)somedata, sizeof(somedata));
  delay(100); 
  Serial.println("Memory written");
  // for debug ----------end
  establishContact();
}

void loop() {
  for(int i = 0; i < 3; i++) {
    char thisBuffer[6];
    i2c_eeprom_read_buffer(0x50, addr, (byte *)thisBuffer, sizeof(thisBuffer));
    Serial.println(thisBuffer);
    addr+=6;
    delay(100);
  }
}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.write('A');   // send a capital A
    delay(100);
  }
}
