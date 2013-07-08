void i2c_eeprom_write_page( int deviceaddress, unsigned int eeaddresspage, byte *data, byte length ) {
  Wire.beginTransmission(deviceaddress);
  Wire.write((unsigned char)(eeaddresspage >> 8)); // MSB
  Wire.write((unsigned char)(eeaddresspage & 0xFF)); // LSB
  byte c;
  for ( c = 0; c < length; c++)
    Wire.write(data[c]);
  Wire.endTransmission();
}

