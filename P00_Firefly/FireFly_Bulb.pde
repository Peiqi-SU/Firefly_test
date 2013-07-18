class Firefly_Bulb{
    int bulb_change_interval = 50; // change the bulb's color every 50ms
    int last_change_time = -bulb_change_interval; 
    
    void light_up_bulb(int value) {
      int current_time = millis();
      if (current_time - last_change_time < bulb_change_interval) {
      } else{
        float coefficient = map(value, 0, 1023, 0, 1); 
        int ri = int(255*coefficient);
        int gi = int(255*coefficient);
        int bi = int(255*coefficient);
        String r = nf(ri,3);
        String g = nf(gi,3);
        String b = nf(bi,3);
    //    println("r: " + r + " --g: "+g+" --b: "+b); // for debugging
        led_arduino_port.write(r);
        led_arduino_port.write(",");
        led_arduino_port.write(g);
        led_arduino_port.write(",");
        led_arduino_port.write(b);
        led_arduino_port.write("\n");
        last_change_time = millis();
      } 
    }
}
