final int SMALL = 18; //small size of font
final int BIG = 30; //BIG size of font
final int HUGE = 80; //huge size of font
float [ ] dashes_bug = {5, 15};
float [ ] dashes_battery = {10, 30};

class Interface {
  int battery_life = 0;
  float battery_cx = 0; // x-cordinate center of battery
  float battery_cy = 0; // y-cordinate center of battery
  float battery_w = 0;
  float battery_h = 0;

  float bug_cx = 0;
  float bug_cy = 0;
  float bug_w = 0;
  float bug_h = 0;

  Interface() {
    battery_cy = height/2.3;
    battery_w = width/3.7;
    battery_h = height/2;
    bug_cy = height-height/14;
    bug_w = width/10;
    bug_h = height/7;
  }
  public float get_battery_h() {
    return battery_h;
  }
  public void set_battery_life(int life) {
    battery_life = life;
  }
  public void set_battery_cx(float x) {
    battery_cx = x;
    set_bug_cx(battery_cx);
  }
  public void set_bug_cx(float x) {
    bug_cx = x;
  }
  public void draw_powerline(int knobvalue, float total) {
    //println("total time : "+  total_time +", knob value : " +knob_value);
    if (knobvalue < 1023 && total >0 )update_line_from_battery(true); 
    else update_line_from_battery(false);
  }
  public void update_bugs(int i, float value, int id, String name) {
    noStroke();
    if (id == 3 || id == 6) fill(10, 10, 255);
    else if (id == 1 || id == 4) fill(255, 10, 10);
    else if (id == 2 || id == 5) fill(10, 255, 10);
    else if (id == -1) fill(100, 100, 100);
    else println("wrong bug ID in - [update_bugs]:"+id);

    rectMode(CENTER); 
    rect(bug_cx, bug_cy, bug_w, bug_h, width/100);
    fill(255);
    // Name
    textSize(SMALL);
    if (id>-1) text(name, bug_cx-width/30, bug_cy-height/25);
    // Time
    textSize(BIG);
    // prevent Minus value
    if (value>0) text(nfc(value*speed_rate,3)+" s", bug_cx-width/25, bug_cy+height/100);
    else if (value <=0) text(nfc(0.000,3)+" s", bug_cx-width/25, bug_cy+height/100);
  }

  public void update_battery(int i, float energy_height, float energy_height_y, int id, String name) {
    if (id>-1) {
      energy_height = energy_height*speed_rate; 
      float strokeoffset = 4;

      if (id == 3 || id == 6) fill(10, 10, 255);
      else if (id == 1 || id == 4) fill(255, 10, 10);
      else if (id == 2 || id == 5) fill(10, 255, 10);
      else if (id == -1) noFill();
      else println("wrong bug ID in - [update_bugs]:"+id);
      stroke(187);
      strokeWeight(0);
      rectMode(CORNER);

      float x = battery_cx - battery_w/2 +strokeoffset;
      float y = battery_cy + battery_h/2 -energy_height;
      rect(x, y, battery_w -2*strokeoffset, energy_height-strokeoffset);
      fill(255);
      textSize(SMALL);
      text(name, x, y-strokeoffset+SMALL);
    }
  }
    
  public void update_grid_battery(int i, float energy_height, float energy_height_y, int id, String name) {
    if (id>-1) {
      // determin unit size
      int unit_block_num = 20; // per line
      float unit_h = 20;       

      energy_height = energy_height*speed_rate; 
      float strokeoffset = 4;
      float unit_w = (battery_w-strokeoffset*2)/unit_block_num;
      int line_num = 1;
      int remained_block = 0;
      int max_line = int(battery_h/unit_h);
      
      if (id == 3 || id == 6) fill(10, 10, 255);
      else if (id == 1 || id == 4) fill(255, 10, 10);
      else if (id == 2 || id == 5) fill(10, 255, 10);
      else if (id == -1) noFill();
      else println("wrong bug ID in - [update_bugs]:"+id);
      stroke(187);
      strokeWeight(0);
      rectMode(CORNER);
             
      float x = battery_cx - battery_w/2 +strokeoffset;
      float y = battery_cy + battery_h/2 - line_num*unit_h -strokeoffset;  
      line_num = int(energy_height / unit_block_num);
      remained_block = int(energy_height % unit_block_num);
      
      //prevent max-out
      if (line_num >= max_line){ 
        println("max out : "+line_num+","+max_line);
        line_num = max_line;
        remained_block = 0;
      }
      
      for(int l=0;l<line_num;l++){
        for(int k=0;k<unit_block_num;k++){
          rect(x+unit_w*k,y-l*unit_h,unit_w,unit_h);
        }
      }
      for(int j=0;j<remained_block;j++){
        rect(x+unit_w*j, y-line_num*unit_h, unit_w, unit_h);
      }
       
      fill(255);
      textSize(SMALL);
      text(name, x, y-strokeoffset+SMALL);
    }
  }

  public void update_line_from_bug(int i, int id, int bug_value) {
    int x = int(battery_cx);
    int y = height-height/7;
    int line_color = 0;
    boolean animate = false;
    if (bug_value >3) { // bug_balue could be 0,1,2 when bug is not shaked
      if (id == 3 || id == 6) line_color = #0A0AFF;//stroke(10, 10, 255); 
      else if (id == 1 || id == 4) line_color = #FF0A0A;//stroke(255, 10, 10);
      else if (id == 2 || id == 5) line_color= #0AFF0A;//stroke(10, 255, 10);
      animate = true;
    }
    else {
      line_color = #CCCCCC;
      animate = false;
    }
    stroke(line_color);
    strokeWeight(10);
    draw_dashline(x, y, x, battery_cy+battery_h/2, dashes_bug, line_color, animate);
  }

  public void update_line_from_battery(boolean animate) {
    int line_color = 0;
    strokeWeight(18);
    if (animate)line_color = #FFFF0D;
    else line_color = #CCCCCC; 
    stroke(line_color);
    draw_dashline(battery_cx, 0, battery_cx, battery_cy-battery_h/2, dashes_battery, line_color, animate);
  }

  public void draw_battery_border() {
    stroke(187);
    strokeWeight(10);
    fill(10);
    rectMode(CENTER);
    //cap
    rect(battery_cx, battery_cy-height/10, width/18, height/2.5, width/100);
    //body
    rect(battery_cx, battery_cy, battery_w, battery_h, width/100);
  }

  public void update_timer(float value) {
    noStroke();
    fill(255, 205, 0);
    textSize(HUGE);
    String time = nfc(value, 5);
    text(time+"s", width/2+width/8, height/2);
  }

  /*
   * Draw a dashed line with given set of dashes and gap lengths.
   * x0 starting x-coordinate of line.
   * y0 starting y-coordinate of line.
   * x1 ending x-coordinate of line.
   * y1 ending y-coordinate of line.
   * spacing array giving lengths of dashes and gaps in pixels;
   *  an array with values {5, 3, 9, 4} will draw a line with a
   *  5-pixel dash, 3-pixel gap, 9-pixel dash, and 4-pixel gap.
   *  if the array has an odd number of entries, the values are
   *  recycled, so an array of {5, 3, 2} will draw a line with a
   *  5-pixel dash, 3-pixel gap, 2-pixel dash, 5-pixel gap,
   *  3-pixel dash, and 2-pixel gap, then repeat.
   */
  private void draw_dashline(float x0, float y0, float x1, float y1, float[ ] spacing, int rgb, boolean animate)
  {
    float distance = dist(x0, y0, x1, y1);
    float [ ] xSpacing = new float[spacing.length];
    float [ ] ySpacing = new float[spacing.length];
    float drawn = 0.0;  // amount of distance drawn
    float alp = random(255);

    if (distance > 0)
    {
      int i;
      boolean drawLine = true; // alternate between dashes and gaps
      for (i = 0; i < spacing.length; i++)
      {
        xSpacing[i] = lerp(0, (x1 - x0), spacing[i] / distance);
        ySpacing[i] = lerp(0, (y1 - y0), spacing[i] / distance);
      }

      i = 0;
      while (drawn < distance)
      {
        if (!animate) {
          if (drawLine)
          {
            line(x0, y0, x0 + xSpacing[i], y0 + ySpacing[i]);
          }
          x0 += xSpacing[i];
          y0 += ySpacing[i];
          /* Add distance "drawn" by this line or gap */
          drawn = drawn + mag(xSpacing[i], ySpacing[i]);
          i = (i + 1) % spacing.length;  // cycle through array
          drawLine = !drawLine;  // switch between dash and gap
        }
        else {
          if (drawLine)
          {
            alp-= 80;
            stroke(rgb, alp);
            line(x0, y0, x0 + xSpacing[i], y0 + ySpacing[i]);
          }
          x0 += xSpacing[i];
          y0 += ySpacing[i];
          /* Add distance "drawn" by this line or gap */
          drawn = drawn + mag(xSpacing[i], ySpacing[i]);
          i = (i + 1) % spacing.length;  // cycle through array
          drawLine = !drawLine;  // switch between dash and gap

          if (alp < 0) {
            alp =random(255);
          }
        }
      }
    }
  }
}

