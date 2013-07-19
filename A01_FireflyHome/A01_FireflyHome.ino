unsigned long previousMillis = 0; 
String inputString = "";         // a string to hold incoming data
String dealString = "";         // a string to hold incoming data

boolean stringComplete = false;  // whether the string is complete


void setup() {
  // initialize serial communications at 9600 bps:
  Serial.begin(9600); 
  inputString.reserve(64);
  dealString.reserve(64);
  pinMode(9,OUTPUT);
  pinMode(10,OUTPUT);
  pinMode(11,OUTPUT);
}

void loop() {
  // read the analog in value:

  unsigned long currentMillis = millis();
  if(currentMillis - previousMillis > 50) { // send value to processing every 50ms
    unsigned int sensorValue = analogRead(0);            
    Serial.println(sensorValue);      
    previousMillis=currentMillis;
  }
  if (stringComplete) {
    dealString=inputString;
    inputString = "";
    stringComplete = false;
    dealString.trim();
    unsigned char r,g,b;
    unsigned char comma_index=dealString.indexOf(',');
    if (comma_index>0){
      r=dealString.substring(0,comma_index).toInt();
      unsigned char comma_index2=dealString.indexOf(',',comma_index+1);
      if (comma_index2>0){
        g=dealString.substring(comma_index+1,comma_index2).toInt();
        b=dealString.substring(comma_index2+1,dealString.length()).toInt();
        analogWrite(9,b); //b
        analogWrite(10,r);  //r
        analogWrite(11,g); // g
      }
      /* for debugging
       Serial.println(r);
       Serial.println(g);
       Serial.println(b);*/
    }
  }
}

void serialEvent() {
  while (Serial.available()) {
    // get the new byte:
    char inChar = (char)Serial.read(); 
    // add it to the inputString:
    inputString += inChar;
    // if the incoming character is a newline, set a flag
    // so the main loop can do something about it:
    if (inChar == '\n') {
      stringComplete = true;
    } 
  }
}







