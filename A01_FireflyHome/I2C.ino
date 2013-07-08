void i2c_eeprom_read_buffer( int deviceaddress, unsigned int eeaddress, byte *buffer, int length ) {
  Wire.beginTransmission(deviceaddress);
  Wire.write((unsigned char)(eeaddress >> 8)); // MSB
  Wire.write((unsigned char)(eeaddress & 0xFF)); // LSB
  Wire.endTransmission();
  Wire.requestFrom(deviceaddress,length);
  int c = 0;
  for ( c = 0; c < length; c++ )
    if (Wire.available()) buffer[c] = Wire.read();
}

// for debug ----------
void i2c_eeprom_write_page( int deviceaddress, unsigned int eeaddresspage, byte *data, byte length ) {
  Wire.beginTransmission(deviceaddress);
  Wire.write((unsigned char)(eeaddresspage >> 8)); // MSB
  Wire.write((unsigned char)(eeaddresspage & 0xFF)); // LSB
  byte c;
  for ( c = 0; c < length; c++)
    Wire.write(data[c]);
  Wire.endTransmission();
}
// for debug ---------- end
