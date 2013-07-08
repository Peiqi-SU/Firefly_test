#include <Time.h>
#include <EEPROMEx.h>
#include "i2c.h"  // not the wire library, can't use pull-ups

// The MMA8452 breakout board defaults to 1, set to 0 if SA0 jumper on the bottom of the board is set
#define SA0 1
#if SA0
#define MMA8452_ADDRESS 0x50  // SA0 is high, 0x1C if low
#else
#define MMA8452_ADDRESS 0x1C
#endif

#define THIS_BUG_ID 0

// Set the accel ----------------------------------------------------
const byte SCALE = 2;  // Sets full-scale range to +/-2, 4, or 8g. Used to calc real g values.
// Set the output data rate below. Value should be between 0 and 7
const byte dataRate = 0;  // 0=800Hz, 1=400, 2=200, 3=100, 4=50, 5=12.5, 6=6.25, 7=1.56

int int1Pin = 2;  // These can be changed, 2 and 3 are the Arduinos ext int pins
int int2Pin = 3;
int accelCount[3];  // Stores the 12-bit signed value
float accelG[3];  // Stores the real accel value in g's

// Set the EEPROM ----------------------------------------------------
/*
   byte accelStatus:
 0     Portrait up, Back, Z-tilt
 1     Portrait up, Front, Z-tilt
 2     Portrait up, Back, !Z-tilt
 3     Portrait up, Front, !Z-tilt
 4-7   Portrait Down
 8-11  Landscape Right
 12-15 Landscape Left
 */
int address = 0;
struct accelValues {
  int bugID;
  int runningTime;  // How long since the bug is active, in sec
  int thisAddress;
  float accelX;
  float accelY;
  float accelZ;
  byte accelStatus;
  float examine;
};
accelValues accelValuesInput;
accelValues accelValuesOutput;

const int maxAllowedWrites = 80;
const int memBase          = 0;
int addressStruct(); // Get the available address
void issuedAddresses(); // Show addresses that have been issued
void readAndWriteStruct(); // Read and write different data primitives
void errorChecking(int address); // Test error checking 

void setup()
{
  Serial.begin(9600);
  // The accel ----------------------------------------------------
  byte c;
  // Set up the interrupt pins, they're set as active high, push-pull
  pinMode(int1Pin, INPUT);
  digitalWrite(int1Pin, LOW);
  pinMode(int2Pin, INPUT);
  digitalWrite(int2Pin, LOW);

  // Read the WHO_AM_I register, this is a good test of communication
  c = readRegister(0x0D);  // Read WHO_AM_I register
  if (c == 0x2A) // WHO_AM_I should always be 0x2A
  {  
    initMMA8452(SCALE, dataRate);  // init the accelerometer if communication is OK
    Serial.println("MMA8452Q is online...");
  }
  else
  {
    Serial.print("Could not connect to MMA8452Q: 0x");
    Serial.println(c, HEX);
    while(1) ; // Loop forever if communication doesn't happen
  }

  // The EEPROM ----------------------------------------------------
  // start reading from position memBase (address 0) of the EEPROM. Set maximumSize to 256kb 
  // Writes before membase or beyond EEPROMSizeUno will only give errors when _EEPROMEX_DEBUG is set
  EEPROM.setMemPool(memBase, 65535);  //setMemPool(int base, int memSize); int is 2bytes = 1024*64
  // Set maximum allowed writes to maxAllowedWrites. 
  // More writes will only give errors when _EEPROMEX_DEBUG is set
  EEPROM.setMaxAllowedWrites(maxAllowedWrites);
  Serial.println("EEPROM is ready!");
  Serial.print("The structure takes:");
  Serial.print(addressStruct());
  Serial.println("byte.");
  
  accelValuesInput.bugID = THIS_BUG_ID;
  accelValuesInput.runningTime = 1;
  accelValuesInput.thisAddress = 0;
  accelValuesInput.accelX = 0;
  accelValuesInput.accelY = 0;
  accelValuesInput.accelZ = 0;
  accelValuesInput.accelStatus = 0;
  accelValuesInput.examine = 0;
}

void loop()
{  
  // The accel ----------------------------------------------------
  static byte source;

  // If int1 goes high, all data registers have new data
  if (digitalRead(int1Pin)==1)  // Interrupt pin, should probably attach to interrupt function
  {
    readAccelData(accelCount);  // Read the x/y/z adc values

    /* 
     //Below we'll print out the ADC values for acceleration
     for (int i=0; i<3; i++)
     {
     Serial.print(accelCount[i]);
     Serial.print("\t\t");
     }
     Serial.println();
     */

    // Now we'll calculate the accleration value into actual g's
    for (int i=0; i<3; i++)
      accelG[i] = (float) accelCount[i]/((1<<12)/(2*SCALE));  // get actual g value, this depends on scale being set
    // Print out values
    for (int i=0; i<3; i++)
    {
//      Serial.print(accelG[i], 4);  // Print g values
//      Serial.print("\t\t");  // tabs in between axes
    }
//    Serial.println();
  }

  // If int2 goes high, either p/l has changed or there's been a single/double tap
  if (digitalRead(int2Pin)==1)
  {
    source = readRegister(0x0C);  // Read the interrupt source reg.
    if ((source & 0x10)==0x10)  // If the p/l bit is set, go check those registers
      portraitLandscapeHandler();
    else if ((source & 0x08)==0x08)  // Otherwise, if tap register is set go check that
      tapHandler();
  }

  // The EEPROM ----------------------------------------------------
  // Read and write different data primitives
  readAndWriteStruct(); 
  // Test error checking
//  errorChecking(address); 
  // Read and write
  EEPROM.readBlock(address, accelValuesOutput);
  Serial.print(accelValuesOutput.bugID);
  Serial.print(",");
  Serial.print(accelValuesOutput.runningTime);
  Serial.print(",");
  Serial.print(accelValuesOutput.thisAddress);
  Serial.print(",");
  Serial.print(accelValuesOutput.accelX);
  Serial.print(",");
  Serial.print(accelValuesOutput.accelY);
  Serial.print(",");
  Serial.print(accelValuesOutput.accelZ);
  Serial.print(",");
  Serial.print(accelValuesOutput.accelStatus);
  Serial.print(",");
  Serial.print(accelValuesOutput.examine);
  Serial.println();
  
  // Go to next address 
  address += 23;
  
  delay(500);  // Delay here for visibility
}












