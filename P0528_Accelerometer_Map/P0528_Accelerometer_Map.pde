/*
by Peiqi @ UCB
 For Accelerometer X Y Z graph
 - can save the graph after one screen
 - todo: find max & min
 */
import processing.serial.*;
Serial myPort;

int paddingLeft = 20;
int x1Pos = 0, preX1Pos = 0;
int x2Pos = 0, preX2Pos = 0;
int x3Pos = 0, preX3Pos = 0;

int y1Pos = 0, preY1Pos = 0;
int y2Pos = 0, preY2Pos = 0;
int y3Pos = 0, preY3Pos = 0;

void setup() {
  size(800, 400);
  frameRate(30);
  println(Serial.list());
  refreshTheGraph();

  String portName = Serial.list()[6];
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');
}

void draw() {
}

void serialEvent(Serial myPort) { 
  try {
    // read the serial buffer
    String myString = myPort.readStringUntil('\n');
    if (myString != null) {
      myString = trim(myString);
      int[] sensors = int(split(myString, ','));
      for (int sensorNum = 0; sensorNum < sensors.length; sensorNum++) {
        print("Sensor " + sensorNum + ": " + sensors[sensorNum] + "\t");
      }
      println();

      preY1Pos = y1Pos;
      y1Pos = (int)map(sensors[0], 0, 1023, 20, 120);

      preY2Pos = y2Pos;
      y2Pos =(int) map(sensors[1], 0, 1023, 140, 240);

      preY3Pos = y3Pos;
      y3Pos =(int) map(sensors[2], 0, 1023, 260, 360);

      drawGraph();
    }
  }
  catch (Exception e) {
    println("Serial communication exception.");
  }
}

void drawGraph () {
  strokeWeight(1);
  stroke(255, 159, 3, 255);
  line(preX1Pos, preY1Pos, x1Pos, y1Pos);

  stroke(159, 255, 3, 255);
  line(preX2Pos, preY2Pos, x2Pos, y2Pos);

  stroke(3, 159, 255, 255);
  line(preX3Pos, preY3Pos, x3Pos, y3Pos);

  if (x1Pos >= width) {
    refreshTheGraph();
  } else {
    preX1Pos = x1Pos;
    x1Pos++;

    preX2Pos = x2Pos;
    x2Pos++;

    preX3Pos = x3Pos;
    x3Pos++;
  }
}

void refreshTheGraph() {
  saveFrame("Graph-######.png");
  background(0);
  preX1Pos= x1Pos= preX2Pos= x2Pos= preX3Pos= x3Pos= paddingLeft;
  textSize(20);
  text("X", 5, 30);
  text("Y", 5, 170);
  text("Z", 5, 310);
  fill(255);
}

