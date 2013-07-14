#include <Wire.h>
//#include <EEPROM.h>
#include "LowPower.h"

#define SAMPLE_PIN A0 // measure the capacitor connected to piezo
//#define DISCHARGE_PIN A1 // Light the LED
#define POWER_DETECT_PIN 2
//#define DATA_MAX_LEN 65536  //MAX of EEPROM
#define DATA_MAX_LEN 1024

#define UNIQUE_ID 2


// Change to 6 to disable the green LED
unsigned char led = 5; // the blinking green LED coonect to chip

union Data_16
{
  unsigned int value[16];
  unsigned char buf[32];
};

union Data_16 eeprom_data_out, eeprom_data;
//union Data eeprom_data; 
unsigned int data_ptr = 0;
boolean last_loop_plugged = false;
unsigned char send_value_interval_counter = 0;

void setup() {                
  Serial.begin(115200);
  Wire.begin();
  // initialize the digital pin as an output.
  pinMode(led, OUTPUT);  

  pinMode(POWER_DETECT_PIN, INPUT);   
  digitalWrite(POWER_DETECT_PIN, LOW);   
  //  digitalWrite(DISCHARGE_PIN, LOW);  // Light the LED
  digitalWrite(SAMPLE_PIN, LOW); 

  /* // reset restore // not working
   unsigned int eeprom_swap1, eeprom_swap2; 
   eeprom_swap1=EEPROM.read(0)+EEPROM.read(1)<<8;
   eeprom_swap2=EEPROM.read(2)+EEPROM.read(3)<<8;
   if (eeprom_swap1==(~eeprom_swap2)) data_ptr=eeprom_swap1;
   */

  /*for (unsigned char i=0;i<100;i++){  //test reset problem
   digitalWrite(led, HIGH);  
   delay(5);
   digitalWrite(led, LOW);  
   delay(5);
   }*/
}

void loop() {
  // connected mode ----------------------------------------------
  if (digitalRead(POWER_DETECT_PIN)==HIGH){
    unsigned long previousMillis = millis(); 
    if(last_loop_plugged == false){
      while (Serial.read() != -1);  //clear serial buffer (read until -1)
    }
    send_value_interval_counter++;
    if (send_value_interval_counter==20){  // only affect the coonecting mode
      send_one_int_value(analogRead(0));  //send a value every n*100 ms
      send_value_interval_counter=0;
    }
    else{
      Serial.write('\n');  //just send a heartbeat
    }

    digitalWrite(led, HIGH);
    if(send_value_interval_counter==0) pinMode(SAMPLE_PIN, OUTPUT);  
    while(millis()-previousMillis<10); // discharge 10ms after each sample being sent
    if(send_value_interval_counter==0) pinMode(SAMPLE_PIN, INPUT); 
    digitalWrite(led, LOW); 
    if (Serial.available() > 0) {
      unsigned char incomingByte = Serial.read();
      if (incomingByte=='\a'){
        send_eeprom();
      }
      else if (incomingByte==0x18){
        data_ptr=0;
        // EEPROM.write(0, 0);EEPROM.write(1, 0);EEPROM.write(2, ~0);EEPROM.write(3, ~0);
      }
    }

    while(millis()-previousMillis<100); // loop every 100ms

    last_loop_plugged = true;
  }

  // remote mode ----------------------------------------------
  else{
    eeprom_data_out.value[data_ptr&(16-1)] = analogRead(0); // calculate the 16's remainder
    digitalWrite(led, HIGH); // green LED blink for 15ms
    digitalWrite(SAMPLE_PIN, OUTPUT); 
    LowPower.powerDown(SLEEP_15Ms, ADC_OFF, BOD_OFF);  // discharge for 15ms
    digitalWrite(led, LOW);
    digitalWrite(SAMPLE_PIN, INPUT);

    if (data_ptr<DATA_MAX_LEN){
      data_ptr++;
      if ((data_ptr&(16-1))==0){
        //move data to external eeprom
        i2c_eeprom_write_page(0x50, (data_ptr-16)*2, (byte *)eeprom_data_out.buf, 32); // write to EEPROM 
        //store ptr
        // EEPROM.write(0, (data_ptr&0xFF));EEPROM.write(1, (data_ptr>>8));EEPROM.write(2, ~(data_ptr&0xFF)); EEPROM.write(3, ~(data_ptr>>8));
      }
    }
    last_loop_plugged = false;
    //LowPower.powerDown(SLEEP_120MS, ADC_OFF, BOD_OFF); //debuging
    LowPower.powerDown(SLEEP_2S, ADC_OFF, BOD_OFF); 
  }

  //LowPower.powerDown(SLEEP_8S, ADC_OFF, BOD_OFF);  

}

void send_eeprom(){
  
  //send id
  Serial.write('~');
  send_one_int_value(UNIQUE_ID);
  
  
  // invert check
  send_one_int_value_no_newline(data_ptr);
  send_one_int_value(~data_ptr);

  unsigned int pages=0;
  if (data_ptr>0) pages=(data_ptr)/16;

  for (unsigned int i=0;i<pages;i++){
    i2c_eeprom_read_buffer(0x50, i*32, (byte *)eeprom_data.buf, 32); // write to EEPROM 
    send_page();
  }  
}

// convert 0-15 to 0-9, A-F
#define toHex(i) (((i) <= 9)?('0' +(i)):((i)+'@'-9))
void send_page(){
  char buf[4];
  unsigned char temp;
  for (unsigned char i=0;i<16;i++){
    temp=(unsigned char)(eeprom_data.value[i]>>8);
    buf[0]=toHex(temp>>4);   
    buf[1]=toHex(temp&0x0F);
    temp=(unsigned char)eeprom_data.value[i];
    buf[2]=toHex(temp>>4);
    buf[3]=toHex(temp&0x0F); 
    Serial.write((const uint8_t*)buf,4);
  }
  Serial.write('\n');
}

void send_one_int_value(unsigned int value){
  send_one_int_value_no_newline(value);
  Serial.write('\n');
}

void send_one_int_value_no_newline(unsigned int value){
  char buf[4];
  unsigned char temp;
  temp=(unsigned char)(value>>8);
  buf[0]=toHex(temp>>4);   
  buf[1]=toHex(temp&0x0F);
  temp=(unsigned char)value;
  buf[2]=toHex(temp>>4);
  buf[3]=toHex(temp&0x0F); 
  Serial.write((const uint8_t*)buf,4);
}

// check the voltage on adrino // not use
boolean voltage_over_3_3(){
  // REFS1 REFS0          --> 0 1, AVcc internal ref.
  // MUX3 MUX2 MUX1 MUX0  --> 1110 1.1V (VBG)
  ADMUX = (0<<REFS1) | (1<<REFS0) | (0<<ADLAR) | (1<<MUX3) | (1<<MUX2) | (1<<MUX1) | (0<<MUX0);
  ADCSRA |= _BV( ADSC );
  while (bit_is_set(ADCSRA, ADSC));
  int value=ADC;
  Serial.println(value);
  return value<(1024*1.1*0.9)/3.3; //10% error tolerance
}

// WARNING: address is a page address, 6-bit end will wrap around
// also, data can be maximum of about 30 bytes, because the Wire library has a buffer of 32 bytes
// To change the wire library: libraries/Wire/Wire.h & libraries/Wire/utility/twi.h, from 32 to 96
void i2c_eeprom_write_page( int deviceaddress, unsigned int eeaddresspage, byte* data, byte length ) {
  Wire.beginTransmission(deviceaddress);
  Wire.write((int)(eeaddresspage >> 8)); // MSB
  Wire.write((int)(eeaddresspage & 0xFF)); // LSB
  byte c;
  for ( c = 0; c < length; c++)
    Wire.write(data[c]);
  Wire.endTransmission();
}

void i2c_eeprom_read_buffer( int deviceaddress, unsigned int eeaddress, byte *buffer, int length ) {
  Wire.beginTransmission(deviceaddress);
  Wire.write((int)(eeaddress >> 8)); // MSB
  Wire.write((int)(eeaddress & 0xFF)); // LSB
  Wire.endTransmission();
  Wire.requestFrom(deviceaddress,length);
  int c = 0;
  for ( c = 0; c < length; c++ )
    if (Wire.available()) buffer[c] = Wire.read();
}
