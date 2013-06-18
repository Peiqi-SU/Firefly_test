long interval = 10;
long previousMillis = 0;


void setup() {
  Serial.begin(115200);
}


void loop() {
  unsigned long currentMillis = millis();
  if(currentMillis - previousMillis > interval) {
    previousMillis = currentMillis;
    Serial.println(analogRead(A0) * (5.0 / 1023.0));
  }
}
