import processing.serial.*;
Serial led_arduino_port;

Firefly_Bug bugs[];
Firefly_UI ui;
Firefly_Bulb bulb;

int knob_value = 0;
int BUG_NUMBERS = 6;  // init num of bugs

void setup() {
  size(1024, 768);  //I can't test on FULL HD
  //size(1920, 1080);
  background(0);
  bugs =new Firefly_Bug[BUG_NUMBERS];
  ui = new Firefly_UI();
  bulb = new Firefly_Bulb();
  
  
  //mac--------------------------------------
//  String portlist[]=Serial.list();
//  int index=0;
//  for (int i=0;i<portlist.length;i++) {
//    if (portlist[i].indexOf("tty.usbserial")>=0) {
//      println("Assign "+portlist[i]+" to bug "+index);
//      bugs[index] = new Firefly_Bug(portlist[i], index);
//      index++;
//      if (index>=bugs.length) break;
//    } else if (portlist[i].indexOf("tty.usbmodem")>=0) {
//      led_arduino_port = new Serial(this, portlist[i], 9600);
//      led_arduino_port.bufferUntil('\n');
//    }
//  }
  //--------------------------------------
  /*  //windows--------------------------------------
   bugs[0] = new Arduino_bug("COM44");
   bugs[1] = new Arduino_bug("COM31");
   //--------------------------------------*/

  for (int i=0;i<bugs.length;i++)
    if (bugs[i]!=null) bugs[i].init(this);

  //fake a bug on windows
  //  bugs[0] = new Arduino_bug("COM44", 0);
  
  //fake 6 bugs on mac
  for (int i = 0;i < 6; i++){
   bugs[i] = new Firefly_Bug("/dev/tty.usbserial"+i, i);
  }
}

void draw() {
  background(0);
  ui.basic_interface();
  
  for (int i=0;i<bugs.length;i++)
    if (bugs[i]!=null) bugs[i].update();
    
  for (int i=0;i<bugs.length;i++) {
    if (bugs[i]!=null) {
      // if bug is online, draw the name of bug, value 
//      if (bugs[i].present) {
//        println(bugs.length);

        ui.update_bugs(0, 255, 0, i, bugs[i].bug_value,bugs[i].bug_id);
//        ui.update_battery(0, 255, 0, i, bugs[i].bug_value, bugs[i].bug_id);
//      } else {
//        // if bug is offline, draw a gray spot
//        ui.update_bugs(100, 100, 100, i, -1, -1);
//        ui.update_battery(100, 100, 100, i, -1, -1);
//      }
    }
  }
// draw the line graph
  for (int i=0;i<bugs.length;i++) {
    if (bugs[i]!=null &&  bugs[i].has_valid_data) { //you can also add present condition
      bugs[i].draw_graph((width/8)*(i+1), height-100, 100, 100);
    }
  }
  
  ui.update_timer(knob_value);
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
    bulb.light_up_bulb(knob_value);
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

