long interval = 1000;
long previousMillis = 0;


void setup() {
  Serial.begin(115200);
}


void loop() {
  unsigned long currentMillis = millis();
  if(currentMillis - previousMillis > interval) {
    previousMillis = currentMillis;
    Serial.println(analogRead(A0) * (3.3 / 1024.0));
  }
}˜
