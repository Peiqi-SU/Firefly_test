// Energy in Capacitor: E = 1/2*C*V^2 = 1/2*100uF*3.3^2 = 0.54*10^-3J
// power of LED: P = 2V * 2mA = 4*10^-3W
// Time = E/P
float bug_energy(float v) {
  v = map(v, 0, 1024, 0, 3.3);
  return 5*sq(v)*pow(10, -5);
}


float blub_consumption(float value, int id) {
//  println(id);
  float this_knob_value = 0;
  if (id==1 || id==2) {
    this_knob_value = b_knob;
  }
  if (id==3 || id==4) {
    this_knob_value = r_knob;
  }
  if (id==5 || id==6) {
    this_knob_value = g_knob;
  }

//  println("this_knob_value: "+this_knob_value);
  // no light
  if (value <= 0) return 0;
  // strong light
  else if (this_knob_value < 50) return value-=  0.0000001;
  else if (this_knob_value >=50 && this_knob_value < 400) return value-= 0.00000005;//0.000001;
  // medium light
  else if (this_knob_value >=400 && this_knob_value < 800) return value-=  0.000000001;//0.000005; 
  // weak light
  else if (this_knob_value >=800 && this_knob_value < 1023) return value-= 0.000000005;//0.00001;
  else return value;
}

// shake for 1min, sum_value = 3.89 *10^-5 J
// shake for 5min, energy max = 0.0001J
float energy_max = 0.0001; //J

float energy_height_display(float sum_value) {
  // height_display / height_max = energy_harvested / energy_max
  float height_value = (sum_value/ energy_max)*height/2.5/6;
  // according to knob value, 0-1023
  return height_value;
}

float light_up_time_text(float bug_energy) {
  return (float)bug_energy/0.004;
}

