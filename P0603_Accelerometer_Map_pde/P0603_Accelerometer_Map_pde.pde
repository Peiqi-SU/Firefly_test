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

float y1Pos = 0, preY1Pos = 0;
float y2Pos = 0, preY2Pos = 0;
float y3Pos = 0, preY3Pos = 0;

// Same data structure with the data in EEPROM
int bugID;
int runningTime;  // How long since the bug is active, in sec
int thisAddress;
byte accelStatus;
float examine;

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
       println("myString: "+myString);
      float[] sensors = float(split(myString, ','));
      /*
       0 int bugID;
       1 int runningTime;
       2 int thisAddress;
       3 float accelX;
       4 float accelY;
       5 float accelZ;
       6 byte accelStatus;
       7 float examine;
       */
      preY1Pos = y1Pos;
      y1Pos = (float)map(sensors[3], -1.00, 1.00, 20.00, 120.00);
//      print("sensors[3]: "+sensors[3]);
      
      preY2Pos = y2Pos;
      y2Pos =(float) map(sensors[4], -1.00, 1.00, 140.00, 240.00);
//      print(" ------ sensors[4]: "+sensors[4]);

      preY3Pos = y3Pos;
      y3Pos =(float) map(sensors[5], -1.00, 1.00, 260.00, 360.00);
//      println(" ------ sensors[5]: "+sensors[5]);

      printStatus((int)sensors[6]);

      drawGraph();
    }
  }
  catch (Exception e) {
    println("Serial communication exception.");
  }
}

void printStatus(int thisStatus) {
  /*
         byte accelStatus:
   0     Portrait up, Back, Z-tilt
   1     Portrait up, Front, Z-tilt
   2     Portrait up, Back, !Z-tilt
   3     Portrait up, Front, !Z-tilt
   4-7   Portrait Down
   8-11  Landscape Right
   12-15 Landscape Left
   */
  switch (thisStatus) {
  case 0: 
  case 1: 
  case 2: 
  case 3:
    println("The bug is portrait up!");
    break;
  case 4: 
  case 5: 
  case 6: 
  case 7:
    println("The bug is portrait down!");
    break;
  case 8: 
  case 9: 
  case 10: 
  case 11:
    println("The bug is landscape right!");
    break;
  case 12: 
  case 13: 
  case 14: 
  case 15:
    println("The bug is landscape left!");
    break;
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

  //at the edge of the screen, go back to the beginning
  if (x1Pos >= width) {
    refreshTheGraph();
  } else {
    preX1Pos = x1Pos;
    x1Pos+=5;

    preX2Pos = x2Pos;
    x2Pos+=5;

    preX3Pos = x3Pos;
    x3Pos+=5;
  }
}

void refreshTheGraph() {
  int y = year();
  int mo = month();
  int d = day();
  int h = hour();  
  int mi = minute();
  saveFrame("XYZGraph"+y+"-"+mo+"-"+d+"-"+h+"-"+mi+".png");
  background(0);
  preX1Pos= x1Pos= preX2Pos= x2Pos= preX3Pos= x3Pos= paddingLeft;
  textSize(20);
  text("X", 5, 30);
  text("Y", 5, 170);
  text("Z", 5, 310);
  stroke(100);
  line(0, 70, width, 70);
  line(0, 190, width, 190);
  line(0, 310, width, 310);
}

