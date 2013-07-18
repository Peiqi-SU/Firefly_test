final int SMALL = 18; //small size of font
final int BIG = 30; //BIG size of font
final int HUGE = 100; //huge size of font
// battery_height = height/2.5;
// battery_width = width/4;

void basic_interface() {
  draw_battery_border();
}

void update_bugs(int i, float value, int id, String name) {
  noStroke();
  if (id == 1 || id == 2) fill(10, 10, 255);
  else if (id == 3 || id == 4) fill(255, 10, 10);
  else if (id == 5 || id == 6) fill(10, 255, 10);
  else if (id == -1) fill(100, 100, 100);
  else println("wrong bug ID in - [update_bugs]:"+id);

  int x = int((width/8)*(i+1.5));
  int y = height-height/14;
  rectMode(CENTER); 
  rect(x, y, width/10, height/7, width/100);
  fill(255);
  textSize(SMALL);
  if (id>-1) text(name, x-20, y-80);
  textSize(BIG);
  if (value>-1) text("value: "+value, x-20, y-40);
}

void update_battery(int i, float energy_height, float energy_height_y, int id, String name) {
  draw_battery_border();
  if (id>-1) {
    if (id == 1 || id == 2) fill(10, 10, 255);
    else if (id == 3 || id == 4) fill(255, 10, 10);
    else if (id == 5 || id == 6) fill(10, 255, 10);
    else if (id == -1) noFill();
    else println("wrong bug ID in - [update_bugs]:"+id);
    stroke(187);
    strokeWeight(2);
    rectMode(CORNER);
    float x = width/2-width/4/2;
    float y = height/2.3+height/5-energy_height_y-energy_height;
    rect(x, y,width/4, energy_height);
    fill(255);
    textSize(SMALL);
    text(name, x+2, y+2);
  }
//  draw_battery_border();
}

void update_line_from_bug(int i, int id) {
  int x = int((width/8)*(i+1.5));
  if (id == 1 || id == 2) stroke(10, 10, 255);
  else if (id == 3 || id == 4) stroke(255, 10, 10);
  else if (id == 5 || id == 6) stroke(10, 255, 10);
  strokeWeight(10);
  line(x, height-height/7, width/2, height/2);
}

void draw_battery_border() {
  stroke(187);
  strokeWeight(10);
  noFill();
  rectMode(CENTER);
  //cap
  //  rect(500, 300, 70, 307, 7);
  rect(width/2, height/2.3-height/20, width/12, height/2.5, width/100);
  //body
  //  rect(500, 333, 200, 307, 7);
  rect(width/2, height/2.3, width/4, height/2.5, width/100);
}

void update_timer(int value) {
  noStroke();
  fill(255);
  text("Light up the bulb for: "+value+"s", width-300, height/2);
}

