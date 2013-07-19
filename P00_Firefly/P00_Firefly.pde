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

  /*
  //windows
   bugs[0] = new Arduino_bug("COM4",0);
   bugs[1] = new Arduino_bug("COM5",1);
   bugs[2] = new Arduino_bug("COM6",2);
   bugs[3] = new Arduino_bug("COM8",3);
   bugs[4] = new Arduino_bug("COM9",4);
   bugs[5] = new Arduino_bug("COM10",5);
   
   led_arduino_port = new Serial(this, "COM7", 9600);
   led_arduino_port.bufferUntil('\n');
   */
  for (int i=0;i<bugs.length;i++)
    if (bugs[i]!=null) bugs[i].init(this);

  //fake a bug
  //bugs[0] = new Arduino_bug("COM44", 0);
}

void draw() {
  //  println("sum_value: "+bugs[2].sum_value); // for dubugging
  background(0);
  basic_interface();
  for (int i=0;i<bugs.length;i++)
    if (bugs[i]!=null) bugs[i].update();

  for (int i=0;i<bugs.length;i++) {
    if (bugs[i]!=null) {
      // if bug is online
      if (bugs[i].present) {
        // total height
        float total = 0;
        float previous_height = bugs[i].energy_height;
        float energy_height_y = 0;
        for (int j=0;j<bugs.length;j++) {
          if (bugs[j]!=null) total += energy_height_display(bugs[j].sum_value);
        }
        // don't exceed the battery height
        if (total<height/2.5) bugs[i].energy_height = energy_height_display(bugs[i].sum_value);
        else bugs[i].energy_height = previous_height;
        // energy_height_y
        for (int j = 0; j<=i; j++) {
          if (bugs[j]!=null) energy_height_y += energy_height_display(bugs[j].sum_value);
        }
        update_line_from_bug(i, bugs[i].bug_id);
        update_bugs(i, bugs[i].sum_value, bugs[i].bug_id, bugs[i].bug_name);
        update_battery(i, bugs[i].energy_height, energy_height_y, bugs[i].bug_id, bugs[i].bug_name);
      } 
      // if bug is offline
      else {
        update_bugs( i, -1, -1, "");
        update_battery(i, -1, -1, -1, "");
      }
    }
  }

  for (int i=0;i<bugs.length;i++) {
    if (bugs[i]!=null &&  bugs[i].has_valid_data) { //you can also add present condition
      bugs[i].draw_graph(0, 0, 100, 100);
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
  /*bugs[0].valid_data=new int[120];
   int accumulator = 0;
   for (int i = 0; i < bugs[0].valid_data.length; i++) {
   bugs[0].valid_data[i]=int(2.5+2.5*sin(i*TWO_PI/20));
   accumulator += bugs[0].valid_data[i];
   }
   bugs[0].valid_data_total=accumulator;
   bugs[0].valid_bug_id=3;
   bugs[0].valid_serial_cable_position=bugs[0].serial_cable_position;
   bugs[0].has_valid_data=true;*/
}

