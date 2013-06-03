#include <SD.h>

#include <EEPROMEx.h>

#define THIS_BUG_ID 0

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
accelValues accelValuesOutput;

const int maxAllowedWrites = 80;
const int memBase          = 0;

void setup()
{
  Serial.begin(9600);
  EEPROM.setMemPool(memBase, 1024);
  EEPROM.setMaxAllowedWrites(maxAllowedWrites);
  Serial.println("EEPROM is ready!");
}

void loop()
{  
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
  
  delay(200);  // Delay here for visibility
}
