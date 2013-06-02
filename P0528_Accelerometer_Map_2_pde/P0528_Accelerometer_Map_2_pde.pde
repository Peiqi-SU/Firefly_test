import processing.serial.*;

Serial myPort;
int[] serialInArray = new int[3];    
int serialCount = 0;                 
int i = 1;  // counter
int inByte = -1;
int xpos, ypos, zpos = 0;
boolean firstContact = false;

void setup () {
  size(400, 300); 
  background(0);
  frameRate(30);
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[6], 9600);

  // Send "A" to start the microcontroller sending
  myPort.write(65);
}

void draw () {
  while (myPort.available () > 0) {
    processByte(myPort.read());
    firstContact = true;
  }
  if (firstContact == false) {
    delay(300);
    myPort.write(65);
  }
}

void processByte( int inByte) {
  serialInArray[serialCount] = inByte;
  serialCount++;
  if (serialCount > 2 ) {
    xpos = serialInArray[0];
    ypos = serialInArray[1];
    zpos = serialInArray[2];
    //   println(xpos + "\t" + ypos + "\t" + zpos);
    drawGraph();
    myPort.write(65);
    serialCount = 0;
  }
}

void drawGraph () {
  int valueToGraph = 0;
  if (keyCode == 88) {    //x
    valueToGraph = xpos;
    stroke(255, 0, 0);
  }
  if (keyCode == 89) {    //y
    valueToGraph = ypos;
    stroke(0, 255, 0);
  }
  if (keyCode == 90) {    //z
    valueToGraph = zpos;
    stroke(0, 0, 255);
  }

  line(i, height, i, height - valueToGraph);

  // at the edge of the screen, go back to the beginning
  if (i >= width-2) {
    i = 0;
    background(0);
  } else {
    i++;
  }
}

