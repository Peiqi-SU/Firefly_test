unsigned long previousMillis = 0; 
String inputString = "";         
String dealString = "";        

boolean stringComplete = false;  // whether the string is complete


void setup() {
  Serial.begin(115200); 
  inputString.reserve(64);
  dealString.reserve(64);
  pinMode(9,OUTPUT);
  pinMode(10,OUTPUT);
  pinMode(11,OUTPUT);
}

void loop() {
  unsigned long currentMillis = millis();
  if(currentMillis - previousMillis > 50) { // send value to processing every 50ms
    unsigned int sensorValueR = analogRead(0);  
    unsigned int sensorValueG= analogRead(1);
    unsigned int sensorValueB = analogRead(2);
    Serial.print(sensorValueR);    
    Serial.print(",");    
    Serial.print(sensorValueG);  
    Serial.print(",");      
    Serial.println(sensorValueB);      
    previousMillis=currentMillis;
  }
  if (stringComplete) {
    dealString=inputString;
    inputString = "";
    stringComplete = false;
    dealString.trim();
    unsigned char r,g,b;
    unsigned char comma_index=dealString.indexOf(',');
    r=dealString.substring(0,3).toInt();
    g=dealString.substring(4,7).toInt();
    b=dealString.substring(8,11).toInt();
    analogWrite(9,r); //b
        analogWrite(10,g);  //r
        analogWrite(11,b); // g
//    if (comma_index>0){
//      r=dealString.substring(0,comma_index).toInt();
//      unsigned char comma_index2=dealString.indexOf(',',comma_index+1);
//      if (comma_index2>0){
//        g=dealString.substring(comma_index+1,comma_index2).toInt();
//        b=dealString.substring(comma_index2+1,dealString.length()).toInt();
//        analogWrite(9,r); //b
//        analogWrite(10,g);  //r
//        analogWrite(11,b); // g
//      }
//      /* for debugging
//       Serial.println(r);
//       Serial.println(g);
//       Serial.println(b);*/
//    }
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









