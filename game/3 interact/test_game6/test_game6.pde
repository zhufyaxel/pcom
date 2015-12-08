// 6, sequence input: a->s->d with game pad
// serial finished, added attack effect
// either keyboard asd or physical input
// use Up and Down arrows to adjust user latency
// use Right and Left arrows to adjust system latency

import processing.sound.*;
import processing.serial.*;

Serial myPort;  // Create object from Serial class
String val;      // Data received from the serial port
String portName = "/dev/cu.usbserial-AH01KCPQ";

BeatGame game;

void setup() {
  // I need to setup the background
  size(1024, 768, P2D);
  // *** serial port available ***
  myPort = new Serial(this, portName, 9600);
  game = new BeatGame();
}

void draw() {
  game.execute();
}

void keyPressed() {
  game.myKeyPressed();
}

void serialEvent(Serial myPort) { 
  if ( myPort.available() > 0) {  // If data is available,
    val = myPort.readStringUntil('\n');
    if (val != null && val.length() > 2){
      if (val.charAt(0) == 'd'){
        if (val.charAt(2) == 'f'){
          //println("defence");
          game.myPortInput("defend");
        }
      }
      
      if (val.charAt(0) == 's'){
        if (val.charAt(2) == 's'){
          //println("swipe");
          game.myPortInput("swipe");
        }
      }
      
      if (val.charAt(0) == 'w'){
        if (val.charAt(2) == 'w'){
          //println("wand");
          game.myPortInput("wand");
        }
      }
    }
  }
} 