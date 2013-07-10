/*
 * to do: convert unsigned long/int to long/int
 */
import processing.serial.*;

final int PAGE_SIZE = 10;
final int NUM_PAGE = 10;

Serial myPort;
long serialCount = 0;
Table table;
boolean firstContact = false;

void setup() {  
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[6], 9600);

  table = new Table();
  table.addColumn("Time");
  table.addColumn("Value");
}


void draw() {
}

void serialEvent(Serial myPort) {
  int inByte = myPort.read();
  println("inByte: "+inByte);
  if (firstContact == false) {
    if (inByte == 'A') { 
      myPort.clear();          
      firstContact = true;     
      myPort.write('A');
      println("first connect");
    }
  } else {
    for (int i = 0; i < NUM_PAGE; i++) {
      String inByteData = myPort.readString();
      println("inByteData: "+inByteData);
      long timestamp_temp = int(inByteData.substring(i*6, i*6+4));
      long timestamp = getUnsignedLong(timestamp_temp);
      int voltage_temp = int(inByteData.substring(i*6+4, (i+1)*6));
      int voltage = getUnsignedInt(voltage_temp);
      //      println("time: " + timestamp + "-- voltage: "+voltage);
      TableRow newRow = table.addRow();
      newRow.setInt("Time", int(timestamp)); // this should be the type of long
      newRow.setInt("Value", voltage);
      saveTable(table, "data/Activity.csv");
    }
    myPort.write('A');
  }
}

int getUnsignedInt (int data) {
  return data&0x0FFFF;
}

long getUnsignedLong (long data) {
  return data&0x0FFFFFFFF;
}

