import processing.serial.*;

Serial myPort;    


void setup () {
  size(400, 400);        
  //  println(Serial.list());
  myPort = new Serial(this, Serial.list()[6], 9600);
  myPort.bufferUntil('\n');
  background(0);
  ellipseMode(CENTER);
}


void draw () {
}


void serialEvent (Serial myPort) {
  try {
    String inString = myPort.readStringUntil('\n');

    if (inString != null) {
      inString = trim(inString);
      String[] data = split(inString, ',');
      float valueR = float(data[0]); 
      float valueG = float(data[1]); 
      float valueB = float(data[2]); 
      visualization(valueR, valueG, valueB);
    }
  } 
  catch (Exception e) {
    println("exception: "+e);
  }
}


void visualization(float valueR, float valueG, float valueB) {
  background(0);
  noStroke();
  fill(valueR, valueG, valueB);
  ellipse(width/2, 70, 100, 100);

  fill(valueR, 0, 0);
  rect(width/3-50, height-10-valueR, 50, height-10);
  fill(0, valueG, 0);
  rect(width/2-25, height-10-valueG, 50, height-10);
  fill(0, 0, valueB);
  rect(width/3*2+50, height-10-valueB, 50, height-10);
}

