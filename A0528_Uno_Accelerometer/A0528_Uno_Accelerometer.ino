// define the total number of analog sensors
#define numberOfSensors 3

void setup() {
  Serial.begin(9600);
  Serial.println("begin");
}

void loop() {
  // loop over the sensors:
  for (int thisSensor = 0; thisSensor < numberOfSensors; thisSensor++) {
    int sensorReading = analogRead(thisSensor);
    // print its value out as an ASCII numeric string
    Serial.print(sensorReading, DEC);
    // if this isn't the last sensor to read,
    // then print a comma after it
    if (thisSensor < numberOfSensors -1) {
      Serial.print(",");
    }
  }
  // after all the sensors have been read, 
  // print a newline and carriage return
  Serial.println();
  delay(200);
}
