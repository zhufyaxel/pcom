////BoomChaCha!

import processing.serial.*;
import ddf.minim.*;

String stage;  // "main" -> "tutorial" -> "main"
// "main" -> "fight" -> "main"
// String nextStage;  // could be change by input
ArrayList<Tutorials> tutorials;
ArrayList<BeatGame> game;

void setup() {
  size(1024, 768, P2D);
  imageMode(CENTER);
  rectMode(CENTER);
  stage = "main";
  tutorials = new ArrayList<Tutorials>();
  game = new ArrayList<BeatGame>();
}

void draw() {
  switch(stage) {
  case "main":
    if (tutorials.size() > 0) {
      tutorials.clear();
    }
    if (game.size() > 0) {
      game.clear();
    }
    //main.execute();    
    break;
  case "tutorial":
    if (tutorials.get(0).pass) {
      tutorials.clear();
      stage = "main";
      break;
    } else {
      tutorials.get(0).execute();
      break;
    }
  case "fight":
    if (game.get(0).end) {
      stage = "main";
      break;
    } else {
      game.get(0).execute();
      break;
    }
  }
}

void keyPressed() {
  switch(stage) {
  case "main":
    if (key == 'a' || key == 'A') {
      tutorials.add(new Tutorials());
      stage = "tutorial";
      break;
    }
    if (key == 's'|| key == 'S') {
      game.add(new BeatGame());
      stage = "fight";
      break;
    }
    // main.myKeyInput();
    break;
  case "tutorial":
    tutorials.get(0).myKeyInput();
    break;
  case "fight":
    game.get(0).myKeyInput();
    break;
  }
}


////BoomChaCha!

//import processing.serial.*;
//import ddf.minim.*;

//Serial myPort;  // Create object from Serial class
//String val;      // Data received from the serial port
//String portName = "/dev/cu.usbserial-AH01KCPQ";

//BeatGame game;
////Tutorial_take_weapon tutorial1;

//void setup() {
//  // I need to setup the background
//  size(1024, 768, P2D);
//  // *** serial port available ***
//  //myPort = new Serial(this, portName, 9600);
//  game = new BeatGame();
//  //tutorial1 = new Tutorial_take_weapon();
//}

//void draw() {
//  game.execute();
//  //tutorial1.execute();
//}

//void keyPressed() {
//  game.myKeyPressed();
//}

////void serialEvent(Serial myPort) { 
////  if ( myPort.available() > 0) {  // If data is available,
////    val = myPort.readStringUntil('\n');
////    if (val != null && val.length() > 2){
////      if (val.charAt(0) == 'd'){
////        if (val.charAt(2) == 'f'){
////          //println("defence");
////          game.myPortInput("defend");
////        }
////      }

////      if (val.charAt(0) == 's'){
////        if (val.charAt(2) == 's'){
////          //println("swipe");
////          game.myPortInput("swipe");
////        }
////      }

////      if (val.charAt(0) == 'w'){
////        if (val.charAt(2) == 'w'){
////          //println("wand");
////          game.myPortInput("wand");
////        }
////      }
////    }
////  }
////} 