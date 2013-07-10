#include <Wire.h>

#define UNIT_ID 0
#define PAGE_SIZE 64

int addr = 0;
int counter = 0;
struct Data {
  unsigned long timestamp;
  unsigned int voltage;
  unsigned char parity;
};
Data thisData;
char thisBuffer[PAGE_SIZE]; // for debug


void setup() 
{
  Wire.begin(); 
  Serial.begin(9600);

  // for debug ----------
  char somedata[] = "hello world";
  i2c_eeprom_write_page(0x50, 0, (byte *)somedata, sizeof(somedata));
  delay(100); 
  Serial.println("Memory written");
  // for debug ----------end
  //establishContact();  // comment for debug
}

void loop() {
  //    char thisBuffer[PAGE_SIZE]; // comment for debug

  byte b = i2c_eeprom_read_byte(0x50, addr);
  Serial.print((char)b); //print content to serial port
  addr++; //increase address
  delay(100);
}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.write('A');   // send a capital A
    delay(100);
  }
}




