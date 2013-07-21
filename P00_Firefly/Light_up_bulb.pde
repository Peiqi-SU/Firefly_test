//int bulb_change_interval = 0; // change the bulb's color every 50ms
//int last_change_time = -bulb_change_interval; 

/* for single battery
 void light_up_bulb(int ri, int gi, int bi) {
 // println("ri: " + ri + " --gi: "+gi+" --bi: "+bi); // for debugging
 int rii = int(255-ri/4);
 int gii = int(255-gi/4);
 int bii = int(255-bi/4);
 // println("rii: " + rii + " --gii: "+gii+" --bii: "+bii); // for debugging
 String r = nf(rii, 3);
 String g = nf(gii, 3);
 String b = nf(bii, 3);
 println("r: " + r + " --g: "+g+" --b: "+b); // for debugging
 //  int current_time = millis();
 //  if (current_time - last_change_time < bulb_change_interval) {
 //  } 
 //  else {
 if (!DISABLE_LED) {
 //println("r: " + r + " --g: "+g+" --b: "+b); // for debugging
 led_arduino_port.write(r);
 led_arduino_port.write(",");
 led_arduino_port.write(g);
 led_arduino_port.write(",");
 led_arduino_port.write(b);
 led_arduino_port.write('\n');
 }
 //    last_change_time = millis();
 //  }
 }
 */

void send_light_up_bulb() {
  int rii = int(knob_value_out[0]/4);
  int gii = int(knob_value_out[1]/4);
  int bii = int(knob_value_out[2]/4);
  // println("rii: " + rii + " --gii: "+gii+" --bii: "+bii); // for debugging
  String r = nf(rii, 3);
  String g = nf(gii, 3);
  String b = nf(bii, 3);
  //println("r: " + r + " --g: "+g+" --b: "+b); // for debugging
  if (!DISABLE_LED) {
    //println("r: " + r + " --g: "+g+" --b: "+b); // for debugging
    led_arduino_port.write(r);
    led_arduino_port.write(",");
    led_arduino_port.write(g);
    led_arduino_port.write(",");
    led_arduino_port.write(b);
    led_arduino_port.write('\n');
  }
}

