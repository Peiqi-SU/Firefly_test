import processing.serial.*;

Arduino_bug bugs[]=new Arduino_bug[6]; // init num of bugs

Serial led_arduino_port;

int knob_value = 0;

void setup() {
  size(1024, 768);  //I can't test on FULL HD
  //size(1920, 1080);
  background(0);
  basic_interface();
  //mac
  String portlist[]=Serial.list();
  int index=0;
  for (int i=0;i<portlist.length;i++) {
    if (portlist[i].indexOf("tty.usbserial")>=0) {
      println("Assign "+portlist[i]+" to bug "+index);
      bugs[index] = new Arduino_bug(portlist[i], index);
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

  //fake a bug
//  bugs[0] = new Arduino_bug("COM44", 0);
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

  for (int i=0;i<bugs.length;i++) {
    if (bugs[i]!=null &&  bugs[i].has_valid_data) { //you can also add present condition
      bugs[i].draw_graph((width/8)*(i+1), height-100, 100, 100);
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
  //if (bugs[0]!=null) println(bugs[0].raw_data); // for debugging
  //fake some data;
  bugs[0].valid_data=new int[120];
  int accumulator = 0;
  for (int i = 0; i < bugs[0].valid_data.length; i++) {
    bugs[0].valid_data[i]=int(2.5+2.5*sin(i*TWO_PI/20));
    accumulator += bugs[0].valid_data[i];
  }
  bugs[0].valid_data_total=accumulator;
  bugs[0].valid_bug_id=3;
  bugs[0].valid_serial_cable_position=bugs[0].serial_cable_position;
  bugs[0].has_valid_data=true;
}
