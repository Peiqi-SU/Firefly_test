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
  int bug_value;
  Arduino_bug(String _portname) {
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
    } else {
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
          println(trimmed); // for debuging
          for (int i=0;i<16;i++) {
            if ((16*receive_counter+i)<raw_data.length) raw_data[16*receive_counter+i]=unhex(trimmed.substring(i*4, i*4+4));
          }
          receive_counter++;
          if (receive_counter==pages_limit) port.write(0x18); //erase; 0x18 means cancel signal
        }
      } else if (trimmed.length()==4) { //it's a single value
        bug_value=unhex(trimmed);
        println("Got value: " + bug_value); // TODO: deal with input value
      } else if (trimmed.length()==8) {  //it's data length
        println(trimmed);
        int len=unhex(trimmed.substring(0, 4));
        int len_inv=unhex(trimmed.substring(4, 8));
        if (len+len_inv==0xFFFF) {  // parity
          pages_limit=(len)/16;
          raw_data=new int[pages_limit*16];
        } else {
          init_transfer();
          receive_counter=0;
          println("Length error");
        }
      }else if(trimmed.length()==5 && trimmed.charAt(0)=='~'){
        int id=unhex(trimmed.substring(1,5));
        bug_id=id;
        println("FROM"+id);
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
}

