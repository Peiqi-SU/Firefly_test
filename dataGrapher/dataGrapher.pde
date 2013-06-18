import processing.video.*;
//import moviemaker.*;
import processing.serial.*;

MovieMaker mm;

Serial myPort; // The serial port
PrintWriter output; 
PFont font;
int d=51;
// initial variables:

int i = 1; // counter
float volts=0;
float inByte = -1; // data from serial port
int inByteNull=0;

void setup () {

size(800, 360); // window size
mm = new MovieMaker(this, width, height, "piezoGraph1.mov", 30, MovieMaker.JPEG, MovieMaker.HIGH);
frameRate(60);


font = loadFont("HelveticaNeue-24.vlw");

// List all the available serial ports

println(Serial.list());

// I know that the third port in the serial list on my mac // is always my Keyspan adaptor, so I open Serial.list()[2]. // Open whatever port is the one you're using.

myPort = new Serial(this, Serial.list()[2], 9600);

output = createWriter("piezoVals.txt"); // Create a new file in the sketch directory

background(230);

}


void draw () {

if (myPort.available() > 0) {
inByte = myPort.read();
volts=inByte/51;
output.println(volts);
println(volts);
serialEvent();

mm.addFrame();
}

}

void serialEvent () {
stroke(0);
textFont(font, 18);
line(0,height-255,width,height-255);
text("5 volts", 10, height-254);
line(0,height-255+d,width,height-255+d);
text("4 volts", 10, height-254+d);
line(0,height-255+d+d,width,height-255+d+d);
text("3 volts", 10, height-254+d+d);
line(0,height-255+d+d+d,width,height-255+d+d+d);
text("2 volts", 10, height-254+d+d+d);
line(0,height-255+d+d+d+d,width,height-255+d+d+d+d);
text("1 volt", 10, height-254+d+d+d+d);
//if(inByte==10 || inByte==13){
  //inByte=inByteNull;}
stroke(0,0,255);
// draw the line:
line(i, height, i, height - inByte);

textFont(font, 72);

fill(230);

stroke(230);

rect(0, 0, width, 70);

fill(0);

text(volts, width/2, 60);

// at the edge of the screen, go back to the beginning:

if (i >= width) {

i = 0;

background(230);
//mm.addFrame(pixels,width,height);

}

else {

i++;

} 
} 
void keyPressed() {
    if(key == 27) {
  
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
  exit(); // Stops the program
}

if (key == ' ') {
    mm.finish();  // Finish the movie if space bar is pressed!
  }

}


  


