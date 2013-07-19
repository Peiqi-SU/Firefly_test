class Arduino_bug 
{
  String portname="";
  Serial port;
  int valid_heartbeat_interval=400;
  int last_hearbeat_time = -valid_heartbeat_interval;
  int baudrate=115200;
  boolean present=false;
  int raw_data[]=new int[32*2];
  int pages_limit=2;
  int receive_counter=pages_limit;
  int bug_id=-1;
  String bug_name;
  int bug_value;
  int serial_cable_position=-1;

  boolean has_valid_data=false;
  float valid_data_total;// sum energy, not voltage
  float valid_data[];
  int valid_bug_id;
  int valid_serial_cable_position;

  float sum_value = 0; // sum energy, not voltage
  float energy_height = 0; // the height of the energy
   float energy_height_y = 0; // the Y-position of the height of the energy

  Arduino_bug(String _portname, int pos) {
    serial_cable_position=pos;
    portname=_portname;
  }

  void init(PApplet main_applet) {
    port = new Serial(main_applet, portname, baudrate);
    port.bufferUntil('\n');
  }

  void update() {
    boolean present_last = present;
    int time_now = millis();
    if (time_now - last_hearbeat_time < valid_heartbeat_interval) {
      present=true;
    } 
    else {
      present=false;
    }
    if (present && !present_last) {  //automatic inquire
      init_transfer();
      receive_counter=0;
    }
  }

  void uart_receive(String input) {
    String trimmed=input.trim();
    if (trimmed.length()>0) {
      if (trimmed.length()==16*4) {  //it's a page data
        if (receive_counter<pages_limit) {
          //          println(trimmed); // for debuging
          for (int i=0;i<16;i++) {
            if ((16*receive_counter+i)<raw_data.length) raw_data[16*receive_counter+i]=unhex(trimmed.substring(i*4, i*4+4));
          }
          receive_counter++;
          if (receive_counter==pages_limit) {
            port.write(0x18); //erase; 0x18 means cancel signal
            handle_valid_data();
          }
        }
      } 
      else if (trimmed.length()==4) { //it's a single value
        bug_value=unhex(trimmed);
        handle_single_data(bug_value);
        //        println("Got value: " + bug_value); // TODO: deal with input value
      } 
      else if (trimmed.length()==8) {  //it's data length
        //        println(trimmed);
        int len=unhex(trimmed.substring(0, 4));
        int len_inv=unhex(trimmed.substring(4, 8));
        if (len+len_inv==0xFFFF) {  // parity
          pages_limit=(len)/16;
          raw_data=new int[pages_limit*16];
        } 
        else {
          init_transfer();
          receive_counter=0;
          println("Length error");
        }
      }
      else if (trimmed.length()==5 && trimmed.charAt(0)=='~') {
        int id=unhex(trimmed.substring(1, 5));
        bug_id=id;
        // assign kid's name to each bug
        if (bug_id == 1) bug_name = blue_1;
        if (bug_id == 2) bug_name = blue_2;
        if (bug_id == 3) bug_name = red_1;
        if (bug_id == 4) bug_name = red_2;
        if (bug_id == 5) bug_name = green_1;
        if (bug_id == 6) bug_name = green_2;
        //        println("FROM"+id);
      }
      else {
        println("! unexpected:"+trimmed);
      }
    }
    last_hearbeat_time=millis();
  }

  void init_transfer() {
    port.write(0x07);//bell signal, means '/a'
  }

  void handle_valid_data() {
    valid_data=new float[raw_data.length];
    arrayCopy(raw_data, valid_data);
    int accumulator = 0;
    for (int i = 0; i < valid_data.length; i++) {
      if (valid_data[i]!=0) accumulator += bug_energy(valid_data[i]);
    }
    valid_data_total=accumulator;
    valid_bug_id=bug_id;

    valid_serial_cable_position=serial_cable_position;

    has_valid_data=true;

    // add the data to sum value
    sum_value += valid_data_total*1000000;

    println("Bug "+ valid_bug_id +" on port "+valid_serial_cable_position+" has "+valid_data.length+" values with a sum of "+valid_data_total);
    //TODO: call visualization with  valid_bug_id, valid_serial_cable_position, valid_data.length, valid_data_total
  }

  void handle_single_data(int value) {
    // add the data to sum value
    if (value != 0) sum_value += bug_energy(value);
    //println("sumvalue: "+sum_value); //for debug
    if (sum_value > 0.00000000001) sum_value = blub_consumption(sum_value); // sum_value threshold
  }

  void draw_graph(float pos_x, float pos_y, float graph_width, float graph_height) {
    int max_pos=10;  //change this according your value
    stroke(255);
    strokeWeight(1);
    //line(pos_x, pos_y, pos_x+graph_width, pos_y+graph_height);
    float y0=map(valid_data[0], -0, max_pos, pos_y+graph_height, pos_y);
    float x0=0;
    for (int i=0;i<valid_data.length-1;i++) {
      float y1=map(valid_data[i+1], -0, max_pos, pos_y+graph_height, pos_y);
      float x1=pos_x+(i+1)*graph_width/(valid_data.length-1);
      line (x0, y0, x1, y1);
      //println(x0+" "+y0+" "+x1+ " "+y1);
      y0=y1;
      x0=x1;
    }
    //println("~~~~");
  }
  public float get_sumvalue(){
    return sum_value;
  }
}

