import processing.serial.*;
Serial myPort;

PrintWriter output;
int counter = 0;

void setup() {
  // Create a new file in the sketch directory
  output = createWriter("accelerometerData.txt"); 
  output.println("bugID, runningTime, thisAddress, accelX, accelY, accelZ, accelStatus, examine;");

  println(Serial.list());
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
    if (counter < 45) {
      if (myString != null) {
        output.println(myString);
      }
    } else {
      output.flush(); // Writes the remaining data to the file
      output.close(); // Finishes the file
      exit(); // Stops the program
      println("Saved to txt!");
    }
    counter ++;
  }
  catch (Exception e) {
    println("Serial communication exception.");
  }
}

