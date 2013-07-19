final int SMALL = 18; //small size of font
final int BIG = 30; //BIG size of font
final int HUGE = 80; //huge size of font

float [ ] dashes_bug = { 
  10, 20
};
float [ ] dashes_battery = { 
  10, 30
};

void basic_interface() {
  draw_battery_border();
  //println("total time : "+  total_time +", knob value : " +knob_value);
  if (knob_value < 1023 && total_time >0 )update_line_from_battery(true); // bugs[4].sum_value should be replaced by total_time
  else update_line_from_battery(false);
}

void update_bugs(int i, float value, int id, String name) {
  noStroke();
  if (id == 1 || id == 2) fill(10, 10, 255);
  else if (id == 3 || id == 4) fill(255, 10, 10);
  else if (id == 5 || id == 6) fill(10, 255, 10);
  else if (id == -1) fill(100, 100, 100);
  else println("wrong bug ID in - [update_bugs]:"+id);

  int x = int((width/(total_bugs+2))*(i+1.5));
  int y = height-height/14;
  rectMode(CENTER); 
  rect(x, y, width/10, height/7, width/100);
  fill(255);
  // Name
  textSize(SMALL);
  if (id>-1) text(name, x-width/30, y-height/25);
  // Time
  textSize(BIG);
  if (value>-1) text(value*100, x-width/25, y+height/100); //for testing --chan (value '*100')
}

void update_battery(int i, float energy_height, float energy_height_y, int id, String name) {
  if (id>-1) {
    energy_height = energy_height*100;// for testing --chan (energy_height '*100')
    float strokeoffset = 4;

    if (id == 1 || id == 2) fill(10, 10, 255);
    else if (id == 3 || id == 4) fill(255, 10, 10);
    else if (id == 5 || id == 6) fill(10, 255, 10);
    else if (id == -1) noFill();
    else println("wrong bug ID in - [update_bugs]:"+id);
    stroke(187);
    strokeWeight(0);
    rectMode(CORNER);

    float x = width/2-width/6/2 +strokeoffset;
    float y = height/2.3+height/5-energy_height_y;
    rect(x, y-strokeoffset, width/6-strokeoffset*2, energy_height);
    fill(255);
    textSize(SMALL);
    text(name, x, y-strokeoffset+SMALL);
  }
}

void update_line_from_bug(int i, int id, int bug_value) {
  int x = int((width/(total_bugs+2))*(i+1.5));
  int y = height-height/7;
  int line_color = 0;
  if (bug_value >0) {
    if (id == 1 || id == 2) line_color = #0A0AFF;//stroke(10, 10, 255); 
    else if (id == 3 || id == 4) line_color = #FF0A0A;//stroke(255, 10, 10);
    else if (id == 5 || id == 6) line_color= #0AFF0A;//stroke(10, 255, 10);
    stroke(line_color);
    strokeWeight(10);
    //  rect(width/2, height/2.3, width/6, height/2.5, width/100);
    // (x-start,y-start,x-end,y-end,dash-style,color,animate?)
    draw_dashline(x, y, width/2, height/2.3+height/5, dashes_bug, line_color, true);
  }
  else {
   stroke(#CCCCCC);
    strokeWeight(10);
    draw_dashline(x, y, width/2, height/2.3+height/5, dashes_bug, #CCCCCC, false);
  }
}

void update_line_from_battery(boolean animate) {
  int line_color = 0;
  strokeWeight(18);
  if (animate)line_color = #FFFF0D;
  else line_color = #CCCCCC; 
  draw_dashline(width/2, 0, width/2, height/2.3-height/4, dashes_battery, line_color, animate);
}

void draw_battery_border() {
  stroke(187);
  strokeWeight(10);
  fill(10);
  rectMode(CENTER);
  //cap
  //  rect(500, 300, 70, 307, 7);
  //  rect(width/2, height/2.3-height/20, width/12, height/2.5, width/100);
  rect(width/2, height/2.3-height/20, width/18, height/2.5, width/100);
  //body
  //  rect(500, 333, 200, 307, 7);
  //  rect(width/2, height/2.3, width/4, height/2.5, width/100);
  rect(width/2, height/2.3, width/6, height/2.5, width/100);
}

void update_timer(float value) {
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
void draw_dashline(float x0, float y0, float x1, float y1, float[ ] spacing, int rgb, boolean animate)
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

