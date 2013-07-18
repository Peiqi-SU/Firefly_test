final int SMALL = 18; //small size of font
final int BIG = 30; //BIG size of font
final int HUGE = 100; //huge size of font

void basic_interface() {
  stroke(150);
  strokeWeight(2);
  fill(100);
  rectMode(CENTER);
  rect(width/2, height/2, 200, 320);
}

void update_bugs(int i, int value, int id) {
  noStroke();
  if (id == 1 || id == 2) fill(10, 10, 255);
  else if (id == 3 || id == 4) fill(255, 10,10);
  else if (id == 5 || id == 6) fill(10, 255, 10);
  else if (id == -1) fill(100, 100, 100);
  else println("wrong bug ID in - [update_bugs]:"+id);

  int x = (width/8)*(i+1);
//  rectMode(CENTER);
  rect(x, height-50, width/10, height/7, width/100);
  fill(255);
  textSize(SMALL);
  if (value>-1) text("value: "+value, x-20, height-80);
  textSize(BIG);
  if (id>-1) text("ID: "+id, x-20, height-90);
}

int value_in_battery = 0;
void update_battery(int r, int g, int b, int i, int value, int id) {
  stroke(255);
  strokeWeight(2);
  rectMode(CENTER);
  if (value>0) {
    value += value_in_battery;
    value_in_battery = value;
  }
  int value_map = int(map(value, 0, 1023, 0, 320));
  fill(100);
  rect(width/2, height/2, 200, 320);
  fill(r, g, b);
  rect(width/2, height/2+320/2-value/2, 200, value);
  fill(255);
  if (value>-1) text("value: "+value, width/2, height/2+320/2-value_map/2);
  if (id>-1) text("ID: "+id, width/2-50, height/2+320/2-value_map/2);
}

void update_timer(int value) {
  noStroke();
  fill(255);
  text("Light up the bulb for: "+value+"s", width-300, height/2);
}

