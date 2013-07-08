int REDPin = 3;   
int GREENPin = 5;  
int BLUEPin = 6;  
int REDPin2 = 9;   
int GREENPin2 = 10;
int BLUEPin2 = 11;
int brightness = 100;
int brightness2 = 255;
int increment = 2;


void setup(){
  pinMode(REDPin, OUTPUT);
  pinMode(GREENPin, OUTPUT);
  pinMode(BLUEPin, OUTPUT);
  pinMode(REDPin2, OUTPUT);
  pinMode(GREENPin2, OUTPUT);
  pinMode(BLUEPin2, OUTPUT);
  Serial.begin(9600);
}


void loop(){
  brightness = brightness + increment;
  brightness2 = brightness2 - increment;

  if (brightness <= 100 || brightness >= 255){
    increment = -increment;
  }
  brightness = constrain(brightness, 100, 255);
  analogWrite(REDPin, brightness);
  analogWrite(GREENPin, brightness2);
  analogWrite(BLUEPin, brightness-100);

  analogWrite(REDPin2, brightness);
  analogWrite(GREENPin2, brightness);
  analogWrite(BLUEPin2, brightness);

  Serial.print(brightness);
  Serial.print(",");
  Serial.print(brightness2);
  Serial.print(",");
  Serial.print(brightness-100);
  Serial.println();

  delay(20);
}



