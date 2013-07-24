// MAX SECOND = 187s
/* TODO:
 * Clean draw();
 * Update the border-color of each battery to R/G/B
 * save data to a file 
 *
 * BUG:
 * FIXED - Sketch crashs caused by "error, disabling serialEvent() for //./COM?
 >>exception: serialEvent exception: java.lang.ArrayStoreException
 >>situation: replug a bug after a long time 
 so the super capacitor will drain too much power from serial port.
 * FIXED - Line auto blinking. 
 >>situation: When bug keeps connecting for a while, 
 sometimes the line from bug to battery will auto blink each 2s. 
 * FIXED - Switch bug error.
 >>situation: Once the bug is reconnected to a different port, system will crush.
 * Data length error.
 >> situation: unknown. rarely happened. 
 1 time on #5 with usb hub and long cable
 */
import processing.serial.*;

boolean DEBUG=true;
boolean DISABLE_LED=true;
String fake_shake_data[]= {
  "0000\n", "0000\n", "0000\n"
};

Arduino_bug bugs[]; // init num of bugs
Interface rui, gui, bui;
Serial led_arduino_port;

//OFFSET
float speed_rate = 10; // gain energy bar speed rate
int r_offset = 1;     // red bug rate control, compared to others
int g_offset = 1;     // green bug rate control, compared to others
int b_offset = 1;     // blue bug rate control, compared to others


int[] knob_value = new int[3]; // 0=max light; 1023=turn off the light
int[] knob_value_out = new int[3];
int r_knob = 1023;
int g_knob = 1023;
int b_knob = 1023;

float total_time = 0;
float r_total_time = 0;
float g_total_time = 0;
float b_total_time = 0;
float max_second = 187;
float max_sum_value = (187*0.004)/(speed_rate*1000);
int total_bugs = 3;
int x_offset = 110;

void setup() {
  // for debugging
//  size(1920, 1080);
//  frame.setLocation(1920, 0);
  // set fullscreen mode
//  size(displayWidth, displayHeight);
  size(1000,800);
  frame.setLocation(0,0);
  background(0);
  frameRate(30);
  bugs = new Arduino_bug[total_bugs];
  rui = new Interface();
  gui = new Interface();
  bui = new Interface();
  /*/mac | uncomment th
   is if run on Mac`---------
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
  if (DEBUG) {
    bugs[0] = new Arduino_bug("COM9", 0);
    bugs[1] = new Arduino_bug("COM13", 1);
    bugs[2] = new Arduino_bug("COM4", 2);
  }
  else {
    bugs[0] = new Arduino_bug("COM10", 0);//r
    bugs[0].port = new Serial(this, "COM10", 9600);
    bugs[0].port.bufferUntil('\n');
    bugs[1] = new Arduino_bug("COM8", 0);//g
    bugs[1].port = new Serial(this, "COM8", 9600);
    bugs[1].port.bufferUntil('\n');
    bugs[2] = new Arduino_bug("COM4", 0);//b
    bugs[2].port = new Serial(this, "COM4", 9600);
    bugs[2].port.bufferUntil('\n');
  }


  if (!DISABLE_LED) {
    led_arduino_port = new Serial(this, "COM7", 9600);
    led_arduino_port.bufferUntil('\n');
  }

  // -- end of windows ---------------------------------

  //  for (int i=0;i<bugs.length;i++)
  //    if (bugs[i]!=null && DEBUG==false) bugs[i].init(this);


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
  rui.draw_powerline(r_knob, r_total_time);
  gui.draw_powerline(g_knob, g_total_time);
  bui.draw_powerline(b_knob, b_total_time);
  // battery ui 
  rui.draw_battery_border();
  gui.draw_battery_border();
  bui.draw_battery_border();

  total_time = 0;
  r_total_time = 0;
  g_total_time = 0;
  b_total_time = 0;

  for (int i=0;i<bugs.length;i++)
    if (bugs[i]!=null) bugs[i].update();

  for (int i=0;i<bugs.length;i++) {
    if (bugs[i]!=null) {
      if (bugs[i].bug_id == 3 || bugs[i].bug_id == 6) {        // blue bug
        if (bugs[i].present) {
          bugs[i].plugged =true;
          float total = 0;
          float previous_height = bugs[i].energy_height;
          float energy_height_y = 0;
          total += speed_rate*energy_height_display(bugs[i].sum_value); 
          bugs[i].energy_height = energy_height_display(bugs[i].sum_value);

          float this_bug_time = light_up_time_text(bugs[i].sum_value);
          
          bui.update_line_from_bug(i, bugs[i].bug_id, bugs[i].bug_value);
          bui.update_bugs(bugs[i].serial_cable_position, this_bug_time, bugs[i].bug_id, bugs[i].bug_name);
          if (bugs[i].sum_value > 0) bui.update_grid_battery(bugs[i].serial_cable_position, bugs[i].energy_height, energy_height_y, bugs[i].bug_id, bugs[i].bug_name);
          total_time += bugs[i].sum_value;
          b_total_time += bugs[i].sum_value;
        } 
        // if bug is offline
        else {
          bugs[i].plugged =false;
          bui.update_bugs( i, -1, -1, "");
          bui.update_grid_battery(i, -1, -1, -1, "");
        }
        bugs[i].set_knob_value(b_knob);
        //        if (bugs[i].sum_value > 0.0000001 && b_knob <1023 && b_knob >=0) light_up_bulb(r_knob, g_knob, b_knob);
        //        else light_up_bulb(r_knob, g_knob, 1023);//turn the light off
        if (bugs[i].sum_value > 0.0000001) knob_value_out[2] = b_knob;
        else knob_value_out[2] = 1023;
      }
      else if (bugs[i].bug_id == 1 || bugs[i].bug_id == 4) {        // red bug
        if (bugs[i].present) {
          bugs[i].plugged =true;
          float total = 0;
          float previous_height = bugs[i].energy_height;
          float energy_height_y = 0;
          total += speed_rate*energy_height_display(bugs[i].sum_value); 
          bugs[i].energy_height = energy_height_display(bugs[i].sum_value);
          float this_bug_time = light_up_time_text(bugs[i].sum_value);
          rui.update_line_from_bug(i, bugs[i].bug_id, bugs[i].bug_value);
          rui.update_bugs(bugs[i].serial_cable_position, this_bug_time, bugs[i].bug_id, bugs[i].bug_name);
          if (bugs[i].sum_value > 0) rui.update_grid_battery(bugs[i].serial_cable_position, bugs[i].energy_height, energy_height_y, bugs[i].bug_id, bugs[i].bug_name);
          total_time += bugs[i].sum_value;
          r_total_time += bugs[i].sum_value;
        } 
        // if bug is offline
        else {
          bugs[i].plugged =false;
          rui.update_bugs( i, -1, -1, "");
          rui.update_grid_battery(i, -1, -1, -1, "");
        }
        bugs[i].set_knob_value(r_knob);
        //        if (bugs[i].sum_value > 0.0000001 && r_knob <1023 && r_knob >=0) light_up_bulb(r_knob, g_knob, b_knob);
        //        else light_up_bulb(1023, g_knob, b_knob );//turn the light off
        if (bugs[i].sum_value > 0.0000001) knob_value_out[0] = r_knob;
        else knob_value_out[0] = 1023;
      } 
      else if (bugs[i].bug_id == 2 || bugs[i].bug_id == 5) {        // green bug
        if (bugs[i].present) {
          bugs[i].plugged =true;
          float total = 0;
          float previous_height = bugs[i].energy_height;
          float energy_height_y = 0;
          total += speed_rate*energy_height_display(bugs[i].sum_value); 
          bugs[i].energy_height = energy_height_display(bugs[i].sum_value);
          float this_bug_time = light_up_time_text(bugs[i].sum_value);
          gui.update_line_from_bug(i, bugs[i].bug_id, bugs[i].bug_value);
          gui.update_bugs(bugs[i].serial_cable_position, this_bug_time, bugs[i].bug_id, bugs[i].bug_name);
          if (bugs[i].sum_value > 0) gui.update_grid_battery(bugs[i].serial_cable_position, bugs[i].energy_height, energy_height_y, bugs[i].bug_id, bugs[i].bug_name);
          total_time += bugs[i].sum_value;
          g_total_time += bugs[i].sum_value;
        } 
        // if bug is offline
        else {
          bugs[i].plugged =false;
          gui.update_bugs( i, -1, -1, "");
          gui.update_grid_battery(i, -1, -1, -1, "");
        }
        bugs[i].set_knob_value(g_knob);
        //        if (bugs[i].sum_value > 0.0000001 && g_knob <1023 && g_knob >=0) light_up_bulb(r_knob, g_knob, b_knob);
        //        else light_up_bulb(r_knob, 1023, b_knob);//turn the light off
        if (bugs[i].sum_value > 0.0000001) knob_value_out[1] = g_knob;
        else knob_value_out[1] = 1023;
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
  // draw graph
//  for (int i=0;i<bugs.length;i++) {
//    if (bugs[i]!=null &&  bugs[i].has_valid_data) { //you can also add present condition
//      bugs[i].draw_graph(0, 0, 100, 100);
//    }
//  }
  // sent data to light up bulb
  send_light_up_bulb();

  //total_time = speed_rate*light_up_time_text(total_time); // for debugging '*100'
  //rui.update_timer(total_time);
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
  try {
    String inString = sourcePort.readString();
    int i; 
    for (i=0;i<bugs.length;i++)
      if (bugs[i]!=null && bugs[i].port==sourcePort) break;
    if (i<bugs.length) {
      bugs[i].uart_receive(inString);
    }
    if (sourcePort==led_arduino_port) { 
      //   println("FROM led ARDUINO: " + inString.trim()); 
      // TODO: deal with "inString", data from potencialometer
      String temp = inString.trim();
      int knob_value_array[] = int(split(temp, ','));
      r_knob = int(map(knob_value_array[0], 50, 1000, 0, 1023));
      g_knob = int(map(knob_value_array[1], 50, 1000, 0, 1023));
      b_knob = int(map(knob_value_array[2], 50, 1000, 0, 1023));
      r_knob = constrain(r_knob, 0, 1023);
      g_knob = constrain(g_knob, 0, 1023);
      b_knob = constrain(b_knob, 0, 1023);
      //      println("r_knob: "+r_knob+" --- g_knob: "+g_knob+" --- b_knob: "+b_knob);
    }
  }
  catch(Exception e) {
    println("serialEvent exception: " + e);
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
  case 's':
    for (int i=0;i<bugs.length;i++) {
      if (bugs[i].table != null && bugs[i].bug_id != -1) {
        //      TODO: save .csv name with yyyy-mm-dd-hh-mm-ss--bug_id_bug_name
        println(get_current_time());
        saveTable(bugs[i].table, "data/bug"+bugs[i].bug_id + bugs[i].bug_name +".csv");
      }
    }
    break;
  case 'r':
    if (DEBUG) fake_shake_data[0]="0128\n";
    break;
  case 'g':
    if (DEBUG) fake_shake_data[2]="0158\n";
    break;
  case 'b':
    if (DEBUG) fake_shake_data[1]="0114\n";
    break;
  case 'e' :
    if (DISABLE_LED) r_knob += 50;
    break;
  case 't' : 
    if (DISABLE_LED) r_knob -= 50;
    break;
  case 'f' :
    if (DISABLE_LED) g_knob += 50;
    break;
  case 'h' : 
    if (DISABLE_LED) g_knob -= 50;
    break;
  case 'v' :
    if (DISABLE_LED) b_knob += 50;
    break;
  case 'n' : 
    if (DISABLE_LED) b_knob -= 50;
    break;
  }
}

