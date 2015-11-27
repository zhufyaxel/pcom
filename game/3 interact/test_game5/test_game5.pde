// I need this sound library

import processing.sound.*;

BeatGame game;

void setup(){
// I need to setup the background
  size(1024, 768,P2D);
  game = new BeatGame();
}

void draw() {
  game.execute();
  println(frameRate);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      game.adjustLatency(10);
    } else if (keyCode == DOWN) {
      game.adjustLatency(-10);
    }
  }
}