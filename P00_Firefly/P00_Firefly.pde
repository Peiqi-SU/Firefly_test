import processing.serial.*;

boolean DEBUG=true;
String fake_shake_data[]= {
  "0000\n", "0000\n", "0000\n"
};

Arduino_bug bugs[]; // init num of bugs
Interface rui,gui,bui;
Serial led_arduino_port;

int speed_rate = 100; // gain energy bar speed rate
int knob_value = 0;
float total_time = 0;
int total_bugs = 3;
int x_offset = 110;

void setup() {
  // set fullscreen mode
  size(displayWidth, displayHeight);
  frame.setLocation(0, 0);

  background(0);
  frameRate(30);
  bugs = new Arduino_bug[total_bugs];
  rui = new Interface();
  gui = new Interface();
  bui = new Interface();
  /*/mac | uncomment this if run on Mac`---------
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
   // -- end of mac ---------------------------------
  /*/

  //windows | uncomment this if run on Windows`---------
  bugs[0] = new Arduino_bug("COM5", 0);
  bugs[1] = new Arduino_bug("COM10", 1);
  bugs[2] = new Arduino_bug("COM13", 2);
  //  bugs[3] = new Arduino_bug("COM8", 3);
  //  bugs[4] = new Arduino_bug("COM9", 4);
  //  bugs[5] = new Arduino_bug("COM10", 5);

if(!DEBUG){
  led_arduino_port = new Serial(this, "COM7", 9600);
  led_arduino_port.bufferUntil('\n');
}
  // -- end of windows ---------------------------------
  
  for (int i=0;i<bugs.length;i++)
    if (bugs[i]!=null && DEBUG==false) bugs[i].init(this);


  if (DEBUG) {
    for (int i=0;i<bugs.length;i++) {
      if (bugs[i]!=null) {
        bugs[i].uart_receive("~000"+(i*2+1)+"\n");
      }
    }
  }    
}

void draw() {
  //  println("sum_value: "+bugs[2].sum_value); // for dubugging
  
  background(0);
  rui.set_battery_cx(width/4 - x_offset);
  gui.set_battery_cx(2*width/4);
  bui.set_battery_cx(3*width/4 + x_offset);

  // line from battery to bulb
  rui.draw_powerline(knob_value,total_time);
  gui.draw_powerline(knob_value,total_time);
  bui.draw_powerline(knob_value,total_time);
  
  // battery ui 
  rui.draw_battery_border();
  gui.draw_battery_border();
  bui.draw_battery_border();
  
  total_time = 0;
  for (int i=0;i<bugs.length;i++)
    if (bugs[i]!=null) bugs[i].update();

  for (int i=0;i<bugs.length;i++) {
    if (bugs[i]!=null) {
        if(bugs[i].bug_id == 1 || bugs[i].bug_id == 2){        // blue bug
          if (bugs[i].present) {
            float total = 0;
            float previous_height = bugs[i].energy_height;
            float energy_height_y = 0;
            total += speed_rate*energy_height_display(bugs[i].sum_value); 
            // don't exceed the battery height
            
            if (total< bui.get_battery_h()) {
              bugs[i].energy_height = energy_height_display(bugs[i].sum_value);
            }
            else bugs[i].energy_height = previous_height;
            
            float this_bug_time = light_up_time_text(bugs[i].sum_value);
            bui.update_line_from_bug(i, bugs[i].bug_id, bugs[i].bug_value);
            bui.update_bugs(bugs[i].serial_cable_position, this_bug_time, bugs[i].bug_id, bugs[i].bug_name);
            if (bugs[i].sum_value > 0) bui.update_battery(bugs[i].serial_cable_position, bugs[i].energy_height, energy_height_y, bugs[i].bug_id, bugs[i].bug_name);
            total_time += bugs[i].sum_value;
          } 
          // if bug is offline
          else {
            bui.update_bugs( i, -1, -1, "");
            bui.update_battery(i, -1, -1, -1, "");
          }
        }
        else if(bugs[i].bug_id == 3 || bugs[i].bug_id == 4){        // red bug
          if (bugs[i].present) {
            float total = 0;
            float previous_height = bugs[i].energy_height;
            float energy_height_y = 0;
            total += speed_rate*energy_height_display(bugs[i].sum_value); 
            // don't exceed the battery height
            
            if (total< rui.get_battery_h()) {
              bugs[i].energy_height = energy_height_display(bugs[i].sum_value);
            }
            else bugs[i].energy_height = previous_height;
            
            float this_bug_time = light_up_time_text(bugs[i].sum_value);
            rui.update_line_from_bug(i, bugs[i].bug_id, bugs[i].bug_value);
            rui.update_bugs(bugs[i].serial_cable_position, this_bug_time, bugs[i].bug_id, bugs[i].bug_name);
            if (bugs[i].sum_value > 0) rui.update_battery(bugs[i].serial_cable_position, bugs[i].energy_height, energy_height_y, bugs[i].bug_id, bugs[i].bug_name);
            total_time += bugs[i].sum_value;
          } 
          // if bug is offline
          else {
            rui.update_bugs( i, -1, -1, "");
            rui.update_battery(i, -1, -1, -1, "");
          }
        } 
        else if(bugs[i].bug_id == 5 || bugs[i].bug_id == 6){        // green bug
          if (bugs[i].present) {
            float total = 0;
            float previous_height = bugs[i].energy_height;
            float energy_height_y = 0;
            total += speed_rate*energy_height_display(bugs[i].sum_value); 
            // don't exceed the battery height
            
            if (total< gui.get_battery_h()) {
              bugs[i].energy_height = energy_height_display(bugs[i].sum_value);
            }
            else bugs[i].energy_height = previous_height;
            
            float this_bug_time = light_up_time_text(bugs[i].sum_value);
            gui.update_line_from_bug(i, bugs[i].bug_id, bugs[i].bug_value);
            gui.update_bugs(bugs[i].serial_cable_position, this_bug_time, bugs[i].bug_id, bugs[i].bug_name);
            if (bugs[i].sum_value > 0) gui.update_battery(bugs[i].serial_cable_position, bugs[i].energy_height, energy_height_y, bugs[i].bug_id, bugs[i].bug_name);
            total_time += bugs[i].sum_value;
          } 
          // if bug is offline
          else {
            gui.update_bugs( i, -1, -1, "");
            gui.update_battery(i, -1, -1, -1, "");
          }
        }
    }
  }
  
      
/* single battery      
  for (int i=0;i<bugs.length;i++) {
    if (bugs[i]!=null) {
      // if bug is online
      if (bugs[i].present) {
        // total height
        float total = 0;
        float previous_height = bugs[i].energy_height;
        float energy_height_y = 0;
        for (int j=0;j<bugs.length;j++) {
          if (bugs[j]!=null && total<height/2.5) total += speed_rate*energy_height_display(bugs[j].sum_value); 
        }
        // don't exceed the battery height
        if (total<height/2.5) {
          //          println("total : "+total);
          bugs[i].energy_height = energy_height_display(bugs[i].sum_value);
        }
        else bugs[i].energy_height = previous_height;
        // energy_height_y (including self height)
        for (int j = 0; j<=i; j++) {
          if (bugs[j]!=null && total < height/2.5) energy_height_y += 10*energy_height_display(bugs[j].sum_value);
        }
        ui.update_line_from_bug(i, bugs[i].bug_id, bugs[i].bug_value);

        float this_bug_time = light_up_time_text(bugs[i].sum_value);
        ui.update_bugs(bugs[i].serial_cable_position, this_bug_time, bugs[i].bug_id, bugs[i].bug_name);
        if (bugs[i].sum_value > 0) ui.update_battery(bugs[i].serial_cable_position, bugs[i].energy_height, energy_height_y, bugs[i].bug_id, bugs[i].bug_name);
        total_time += bugs[i].sum_value;
      } 
      // if bug is offline
      else {
        ui.update_bugs( i, -1, -1, "");
        ui.update_battery(i, -1, -1, -1, "");
      }
    }
  }
*/
  for (int i=0;i<bugs.length;i++) {
    if (bugs[i]!=null &&  bugs[i].has_valid_data) { //you can also add present condition
      bugs[i].draw_graph(0, 0, 100, 100);
    }
  }
  total_time = speed_rate*light_up_time_text(total_time); // for debugging '*100'
  //rui.update_timer(total_time);
  if (total_time > 0.0000001 && knob_value <1023 && knob_value >=0) light_up_bulb(knob_value);
  else light_up_bulb(1023);//turn the light off
  
  //fake present of bugs
  if (DEBUG) {
    if (frameCount%3==0)
      for (int i=0;i<bugs.length;i++)
        if (bugs[i]!=null) bugs[i].uart_receive("\n");
    if (frameCount%10==0)
      for (int i=0;i<bugs.length;i++)
        if (bugs[i]!=null) {
          bugs[i].uart_receive(fake_shake_data[i]);
          if (!fake_shake_data[i].equals("0000\n")) fake_shake_data[i]="0000\n";
        }
  }
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
void keyPressed()
{
  switch(key) {  //change value to be sent in next frame
  case 'r':
    if (DEBUG) fake_shake_data[1]="0014\n";
    break;
  case 'g':
    if (DEBUG) fake_shake_data[2]="0014\n";
    break;
  case 'b':
    if (DEBUG) fake_shake_data[0]="0014\n";
    break;
  }
}

