// I need an array of time of notes
// and an array to store those living notes
// and maybe a pointer that point to the current note, so I can match this to the key event.

import processing.sound.*;

ManiaGame mygame;

void setup() {
  // setup
  size(600,600);
  mygame = new ManiaGame();
}

void draw() {
  background(0);
  mygame.step();
}

void keyPressed() {
  background(255,255,0);
  int currentTime = millis();
  mygame.keyevent(currentTime);
}