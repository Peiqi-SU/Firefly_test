import processing.serial.*;

Arduino_bug bugs[]=new Arduino_bug[2]; // init num of bugs

Serial led_arduino_port;

int knob_value = 0;

void setup() {
  size(1920, 1080);
  background(0);
  basic_interface();
  //mac
  String portlist[]=Serial.list();
  int index=0;
  for (int i=0;i<portlist.length;i++) {
    if (portlist[i].indexOf("tty.usbserial")>=0) {
      println("Assign "+portlist[i]+" to bug "+index);
      bugs[index] = new Arduino_bug(portlist[i],index);
      index++;
      if (index>=bugs.length) break;
    } 
    else if (portlist[i].indexOf("tty.usbmodem")>=0) {
      led_arduino_port = new Serial(this, portlist[i], 9600);
      led_arduino_port.bufferUntil('\n');
    }
  }

  /*  //windows
   bugs[0] = new Arduino_bug("COM44");
   bugs[1] = new Arduino_bug("COM31");*/

  for (int i=0;i<bugs.length;i++)
    if (bugs[i]!=null) bugs[i].init(this);
}

void draw() {
  background(0);
  basic_interface();
  for (int i=0;i<bugs.length;i++)
    if (bugs[i]!=null) bugs[i].update();

  for (int i=0;i<bugs.length;i++) {
    if (bugs[i]!=null) {
      if (bugs[i].present) {
        update_bugs(0, 255, 0, i, bugs[i].bug_value, bugs[i].bug_id);
        update_battery(0, 255, 0, i, bugs[i].bug_value, bugs[i].bug_id);
      } 
      else {
        update_bugs(100, 100, 100, i, -1, -1);
        update_battery(100, 100, 100, i, -1, -1);
      }
    }
  }
  update_timer(knob_value);
}

void serialEvent(Serial sourcePort) {
  String inString = (sourcePort.readString());
  int i; 
  for (i=0;i<bugs.length;i++)
    if (bugs[i]!=null && bugs[i].port==sourcePort) break;
  if (i<bugs.length) {
    bugs[i].uart_receive(inString);
  }
  if (sourcePort==led_arduino_port) { 
    //   println("FROM led ARDUINO: " + inString.trim()); 
    // TODO: deal with "inString", data from potencialometer
    knob_value = int(inString.trim());
    light_up_bulb(knob_value);
  }
}

void mouseClicked() {
  if (bugs[0]!=null) println(bugs[0].raw_data); // for debugging
}

