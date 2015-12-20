////BoomChaCha!

import processing.serial.*;
import ddf.minim.*;


Tutorials tutorials;
BGM bgm;

void setup() {
  size(1024, 768, P2D);
  imageMode(CENTER);
  tutorials = new Tutorials();
}

void draw() {
  tutorials.execute();
}

void keyPressed() {
  tutorials.myKeyInput();
}
//String stage;  // "main" -> ("tutorial1" -> tutorial2" ->... -> "tutorial5") -> "fight" -> "end" -> "tutorial" / "fight" / "main"


//void setup() {
//  size(1024, 768, P2D);
//  // bgm here
//  String path = "music/funny_170.mp3";
//  bgm = new BGM(path, 170, 120);
//  // Scene here
//  stage = "main";
//}

//void draw() {
//  switch(stage) {
//    case "main":
//      scene1 = new Tutorial_take_weapon(bgm);
//      scene1.setStart(bgm.beatsPlayed());
//      stage = "tutorial1";
//      break;
//    case "tutorial1":
//      scene1.execute();
//      if (scene1.end()) {
//        scene2 = new Tutorial_attack();
//        scene2.setStart(bgm.beatsPlayed() + 3);
//        stage = "tutorial2";
//        break;
//      }
//      break;
//    case "tutorial2":
//      scene2.execute();
//      if (scene2.end()) {
//        scene3 = new Tutorial_attack();
//        scene3.setStart(bgm.beatsPlayed() + 3);
//        stage = "tutorial3";
//        break;
//      }
//      break;
//    case "tutorial3":
//      scene3.execute();
//      if (scene3.end()) {
//        scene4 = new Tutorial_attack();
//        scene4.setStart(bgm.beatsPlayed() + 3);
//        stage = "tutorial4";
//        break;
//      }
//      break;
//    case "tutorial4":
//      scene4.execute();
//      if (scene4.end()) {
//        scene5 = new Tutorial_attack();
//        scene5.setStart(bgm.beatsPlayed() + 3);
//        stage = "tutorial5";
//        break;
//      }
//      break;
//    case "tutorial5":
//      scene5.execute();
//      if (scene5.end()) {
//        game = new BeatGame();
//        game.setStart(bgm.beatsPlayed() + 3);
//        stage = "fight";
//        break;
//      }
//      break;
      
//  }
  
    
    
  
//  scene2.execute();
  
//}

//void keyPressed(){
//  scene2.myKeyInput();
//}









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