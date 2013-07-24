// Energy in Capacitor: E = 1/2*C*V^2 = 1/2*100uF*3.3^2 = 0.54*10^-3J
// power of LED: P = 2V * 2mA = 4*10^-3W
// Time = E/P
float bug_energy(float v) {
  v = map(v, 0, 1023, 0, 3.3);
  return 11*sq(v)*pow(10, -6);
}


float blub_consumption(float value, int id) {
  //  println(id);
  float this_knob_value = 0;
  // dimming timing 
  float minus = 0.00000135;
  float gap = 0.00000002;

  if (id==3 || id==6) {
    this_knob_value = b_knob;
  }
  if (id==1 || id==4) {
    this_knob_value = r_knob;
  }
  if (id==2 || id==5) {
    this_knob_value = g_knob;
  }
  
  minus = minus/speed_rate;
  if(speed_rate >5){ gap = gap /10;}

  // no light
  if (value <= 0) {
    value = 0; 
    return value;
  }
  // strong light
//    else if(this_knob_value <1023) return value -= minus; //for debug (speed_rate 1)
  else if (this_knob_value < 100) return value -= minus; 
  else if (this_knob_value >=100 && this_knob_value < 200) return value -= minus-gap*1; 
  else if (this_knob_value >=200 && this_knob_value < 300) return value -= minus-gap*2; 
  else if (this_knob_value >=300 && this_knob_value < 400) return value -= minus-gap*3;
  else if (this_knob_value >=400 && this_knob_value < 500) return value -= minus-gap*4; 
  else if (this_knob_value >=500 && this_knob_value < 600) return value -= minus-gap*5; 
  else if (this_knob_value >=600 && this_knob_value < 700) return value -= minus-gap*6; 
  else if (this_knob_value >=700 && this_knob_value < 800) return value -= minus-gap*7;
  else if (this_knob_value >=800 && this_knob_value < 900) return value -= minus-gap*8; 
  else if (this_knob_value >=900 && this_knob_value < 1023) return value -= minus-gap*9; 
  else return value;
}
//  // no light
//  if (value <= 0) {
//    value = 0; 
//    return value;
//  }
//  // strong light
//  //  else if(this_knob_value <1023) return value -= 0.00000135; //for debug (speed_rate 1)
//  else if (this_knob_value < 100) return value -= 0.00000135; 
//  else if (this_knob_value >=100 && this_knob_value < 200) return value -= 0.00000133; 
//  else if (this_knob_value >=200 && this_knob_value < 300) return value -= 0.00000131; 
//  else if (this_knob_value >=300 && this_knob_value < 400) return value -= 0.00000129; 
//  else if (this_knob_value >=400 && this_knob_value < 500) return value -= 0.00000127; 
//  else if (this_knob_value >=500 && this_knob_value < 600) return value -= 0.00000125; 
//  else if (this_knob_value >=600 && this_knob_value < 700) return value -= 0.00000123; 
//  else if (this_knob_value >=700 && this_knob_value < 800) return value -= 0.00000121; 
//  else if (this_knob_value >=800 && this_knob_value < 900) return value -= 0.00000119; 
//  else if (this_knob_value >=900 && this_knob_value < 1023) return value -= 0.00000117; 
//  else return value;
//}

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

