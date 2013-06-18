// Get the available address
int addressStruct(){
  /*
   int bugID;
   int runningTime;
   int thisAddress;
   float accelX;
   float accelY;
   float accelZ;
   byte accelStatus;
   float examine;
   */
  int addressInt0       = EEPROM.getAddress(sizeof(int));
  int addressInt1       = EEPROM.getAddress(sizeof(int));
  int addressInt2       = EEPROM.getAddress(sizeof(int));
  int addressFloat3     = EEPROM.getAddress(sizeof(float));
  int addressFloat4     = EEPROM.getAddress(sizeof(float));
  int addressFloat5     = EEPROM.getAddress(sizeof(float));
  int addressByte6      = EEPROM.getAddress(sizeof(byte));
  int addressFloat7     = EEPROM.getAddress(sizeof(float));
  return addressFloat7+4;
} 

// Read and write different data primitives
void readAndWriteStruct(){
  accelValuesInput.bugID = THIS_BUG_ID;
  accelValuesInput.runningTime ++;
  accelValuesInput.thisAddress = address;
  accelValuesInput.accelX = accelG[0];
  accelValuesInput.accelY = accelG[1];
  accelValuesInput.accelZ = accelG[2];
//  accelValuesInput.accelStatus = 0;
  accelValuesInput.examine = 0;
  
  EEPROM.writeBlock(address, accelValuesInput);
} 

// Test error checking 
void errorChecking(int address){

} 






