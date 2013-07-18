void basic_interface(){
  stroke(150);
  strokeWeight(2);
  fill(100);
  rectMode(CENTER);
  rect(width/2, height/2, 200, 320);
}

void update_bugs(int r, int g, int b, int i, int value, int id) {
  noStroke();
  fill(r, g, b);
  int x = (width/8)*(i+1);
  ellipse(x, height-50, 40, 40);
  if (value>-1) text("value: "+value, x-20, height-80);
  if (id>-1) text("ID: "+id, x-20, height-90);
}

int value_in_battery = 0;
void update_battery(int r, int g, int b, int i, int value, int id) {
  stroke(255);
  strokeWeight(2);
  rectMode(CENTER);
  if(value>0){
  value += value_in_battery;
  value_in_battery = value;}
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

