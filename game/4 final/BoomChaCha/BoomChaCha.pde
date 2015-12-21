////BoomChaCha!

import processing.serial.*;
import ddf.minim.*;

Serial myPort;  // Create object from Serial class
String val;      // Data received from the serial port
String portName = "/dev/cu.usbserial-AH01KCPQ";

String stage;  // "main" -> "tutorial" -> "main"
// "main" -> "fight" -> "main"
BGM bgm;
ArrayList<Tutorials> tutorials;
ArrayList<BeatGame> game;

PImage main;
PFont aw;

void setup() {
  size(1024, 768, P2D);
  imageMode(CENTER);
  rectMode(CENTER);
  stage = "main";
  tutorials = new ArrayList<Tutorials>();
  game = new ArrayList<BeatGame>();
  bgm = new BGM("music/funny_170.mp3", 170, 120);
  
  main = loadImage("images/main/tutorial_menu.png");
  aw = createFont("fonts/Comic Sans MS Bold.ttf", 32);
  textAlign(CENTER);
  textFont(aw);
  myPort = new Serial(this, portName, 9600);                          
}

void draw() {
  if (bgm.beatsPlayed < 5) {
    myPort.write('d');
    myPort.write('f');
    myPort.write('g');  
  }
  
  bgm.step();  
  
  switch(stage) {
  case "main":
    image(main, width/2, height/2);
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
      game.clear();
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
      tutorials.add(new Tutorials(bgm));
      stage = "tutorial";
      break;
    }
    if (key == 's'|| key == 'S') {
      game.add(new BeatGame(bgm));
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

void serialEvent(Serial myPort) { 

 if ( myPort.available() > 0) {  // If data is available,
   val = myPort.readStringUntil('\n');
   if (val != null && val.length() > 2) {

     String input = "";

     if (val.charAt(0) == 'd') {
       if (val.charAt(2) == 'd') {
         input = "defend";
         println("defend");
       }
     }

     if (val.charAt(0) == 's') {
       if (val.charAt(2) == 's') {
         //println("swipe");
         input = "swipe";
         println("swipe");
       }
     }

     if (val.charAt(0) == 'w') {
       if (val.charAt(2) == 'w') {
         input = "wand";
         println("wand");
       }
     }

     switch(stage) {
     case "main":
       if (input == "wand") {
         tutorials.add(new Tutorials(bgm));
         stage = "tutorial";
         break;
       }
       if (input == "swipe") {
         game.add(new BeatGame(bgm));
         stage = "fight";
         break;
       }
       // main.myKeyInput();
       break;
     case "tutorial":
       tutorials.get(0).myPortInput(input);
       break;
     case "fight":
       game.get(0).myPortInput(input);
       break;
     }
   }
 }
} 