import processing.sound.*;

import fisica.*;
  
FWorld world;
  
BeatGame mygame;

SoundFile soundfile;

void setup() {
  size(1024, 768, P2D);
  
  //phys
  Fisica.init(this);
  world = new FWorld();
  world.setEdges();
  world.setEdgesFriction(10);
  world.setEdgesRestitution(1);
  world.setGravity(0, 2000);

  //merge here
  int bpm = 170;
  mygame = new BeatGame(bpm);
  soundfile = new SoundFile(this, "battle.mp3");
  soundfile.loop();
}

void draw() {
  background(16,10,10);
  noStroke();
  fill(255,255,255);
  ellipse(width/2, height/2, 300, 300);
  fill(138,90,76);
  rect(width/2,height - 100, width, 200);
  world.step();
  mygame.step();
  if (frameCount%21 == 0) { //3600 / bpm 
    mygame.c.step();
  }
  mygame.c.display();
  colorMode(RGB,255,255,255);
}

void keyPressed() {
  int currentTime = millis();
  mygame.keyevent(currentTime);
}