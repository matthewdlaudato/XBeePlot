// XBee Plot

// This program takes ASCII-encoded strings
// from the serial port at 9600 baud and graphs them. 
// Used to capture and plot altitude data coming from
// XBee-PerfectFlite air station

import processing.serial.*;

Serial myPort;                  // The serial port
int xPos = 35;                  // horizontal position of the graph
int lastAltitude = 0;           // the last reported altitude
int altitudeScaleHeight = 2000; // the expected maximum altitude

int rColor = 127;
int gColor = 34;
int bColor = 255;

PrintWriter output;   // output file to store the altitude data

void setup () {

  // set the window size:
  size(1200, 600);        
  
  // List all the available serial ports
  println(Serial.list());
  
  // Open the serial port.
  myPort = new Serial(this, Serial.list()[0], 9600);
  
  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');
  
  // set inital background:
  background(52);
  
  // draw the y axis scale
  int alt = 0;
  for (int i=0; i<=altitudeScaleHeight; i+=100) {
    alt = (int) map(i, 0, altitudeScaleHeight, 0, height);
    text(i, 0, height - alt);
  }
  stroke(0,255,0);
  line(xPos - 5, 0, xPos - 5, height);
  
  // Create the output file sketch directory
  output = createWriter("flightlog.txt"); 
  
}

void draw () {
  // everything happens in the serialEvent()
}

void serialEvent (Serial myPort) {
  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');
  
  if (inString != null) {
    // trim off any whitespace:
    inString = trim(inString);
    lastAltitude = Integer.parseInt(inString);
    
    // convert to a float and map to the screen height:
    float inByte = float(inString); 
    inByte = map(inByte, 0, altitudeScaleHeight, 0, height);
    int timestamp = millis();
    println(timestamp + "," + xPos + "," + inString);
    output.println(timestamp + "," + xPos + "," + inString);
    
    if (lastAltitude > 10) {
    
      // draw the line:
      stroke(rColor,gColor,bColor);
      line(xPos, height, xPos, height - inByte);
      
      // at the edge of the screen, go back to the beginning:
      if (xPos >= width) {
        xPos = 0;
        rColor = 255;
        gColor = 237;
        bColor = 36;
      }
      else {
        // increment the horizontal position:
        xPos++;
      }
    } // non-zero value
  }
}

void mousePressed() {
  output.flush();
  output.close();
  exit();
}


