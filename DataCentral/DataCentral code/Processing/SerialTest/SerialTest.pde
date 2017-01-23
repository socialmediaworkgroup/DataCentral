import processing.serial.*;
import java.awt.Rectangle;
import java.util.regex.Pattern;
import java.util.ArrayList;
import java.util.Iterator;
//import hypermedia.net.*;

int frame_rate = 100; //FPS

//Teensies, networking
float gamma = 1.7;
int numPorts=0;  // the number of serial ports in use
int maxPorts=1; // maximum number of serial ports
PImage secondCanvas; //Our canvas, to draw to 
Serial[] ledSerial = new Serial[maxPorts];     // each port's actual Serial port
Rectangle[] ledArea = new Rectangle[maxPorts]; // the area of the movie each port gets, in % (0-100)
boolean[] ledLayout = new boolean[maxPorts];   // layout of rows, true = even is left->right
PImage[] ledImage = new PImage[maxPorts];      // image sent to each port
int[] gammatable = new int[256];
int errorCount=0;

//Animation
int STRIPLENGTH = 237;
int STRIPNUM = 16; 

// Constants
int Y_AXIS = 1;
int X_AXIS = 2;
color b1, b2, c1, c2;

int x_rect_pos = 0;

void setup() {
  //size(STRIPLENGTH, STRIPNUM); so dumb varables cant be passed in here. 
  size(237,16);
  frameRate(frame_rate);

  // teensy housekeeping
  t_setup();

  // Define colors
  //c1 = color(255, 12, 100);
  //c2 = color(0, 102, 153);
  
  c1 = color(0, 0, 0);
  c2 = color(0, 0, 0);
  
  //All white for testing
  //c1 = color(255, 255, 255);
  //c2 = color(255, 255, 255);
  

}

void draw() {
  // Background
  setGradient(0, 0, width, height, c1, c2, X_AXIS);


  //draw rect
  fill(color(255, 225, 0));
  noStroke();
  rect(x_rect_pos, 0, 4, STRIPNUM);
  x_rect_pos++;
  if(x_rect_pos >= STRIPLENGTH)
  {
      x_rect_pos = 0;
  }

  //push to teensies
  t_draw();
}

void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {

  noFill();

  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  }  
  else if (axis == X_AXIS) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
  }
}