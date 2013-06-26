/*
 * Press any key to save a .csv table with 2 column "Time | Value"
 * Automatically save a .csv table each 30sec
 */
import processing.serial.*;

Serial myPort;
long serialCount = 0;
Table table;


void setup() {  
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[6], 9600);
  myPort.bufferUntil('\n');

  table = new Table();
  table.addColumn("Time");
  table.addColumn("Value");
}


void draw() {
}


void serialEvent(Serial myPort) {
  Float inByte = float(myPort.readString());
  if (inByte != null) {
    TableRow newRow = table.addRow();
    newRow.setFloat("Value", inByte);
    serialCount++;
    // Mark every one second.
    if (serialCount % 100 == 0) {
      newRow.setInt("Time", (int)serialCount / 100);
    }
  }
  // Save the table each 30 sec
  if (serialCount % 3000 == 0) {
    saveTable(table, "data/Capacitor.csv");
  }
}


void keyPressed() {
  saveTable(table, "data/Capacitor.csv");
}

