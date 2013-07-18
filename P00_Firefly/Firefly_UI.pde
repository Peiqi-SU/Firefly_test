class Firefly_UI{
  
  static final String BATTERY_FILE="battery.svg";
//  static final String BUG_FILE="bug.svg";
  
  int BATTERY_WIDTH = 210;
  int BATTERY_HEIGHT = 380;
  int BUG_WIDTH = 80;
  int BUG_HEIGHT = 80;
  PShape battery;
  PFont font;
//  PShape bug;
  int value_in_battery = 0;

  Firefly_Bug bug;    
  Firefly_UI(){
    battery = loadShape(BATTERY_FILE);
    font = loadFont("Geneva-18.vlw"); //Geneva-18.vlw or HelveticaCY-Bold-32.vlw
    
//    bug = loadShape(BUG_FILE);
  }

  public void basic_interface() {
    draw_battery(BATTERY_WIDTH,BATTERY_HEIGHT);  
  }
  
  public void update_bugs(int r, int g, int b, int i, int value, int id) {
    noStroke();
    fill(r, g, b);
    int x = (width/7)*(i+1);
    rect(x, height-BUG_HEIGHT, BUG_WIDTH, BUG_HEIGHT);
    fill(255,255,255);
    textFont(font,18);
    if (value>-1) text("value: "+value, x, height-30);
    if (id>-1) text("ID: "+id, x, height-50);
  }
  
  public void update_battery(int r, int g, int b, int i, int value, int id) {
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
  
  public void update_timer(int value) {
    noStroke();
    fill(255);
    text("Light up the bulb for: "+value+"s", width-300, height/2);
  }
  public void draw_bug(){
    for (int i=0;i<bugs.length;i++)
    if (bugs[i]!=null) bugs[i].update();
  }
  private void draw_battery(int w, int h){
    shape(battery,width/2-w/2,height/2-3*h/4,w,h);  
  }
}
