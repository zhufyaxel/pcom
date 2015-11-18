import processing.sound.*;

import fisica.*;
FWorld world;
Characters c;
SoundFile soundfile;

void setup() {
  Fisica.init(this);
  world = new FWorld();
  world.setEdges();
  world.setEdgesFriction(0);
  world.setEdgesRestitution(1);
  world.setGravity(0, 1000);
  size(1024, 768, P2D);
  
  c = new Characters();
  soundfile = new SoundFile(this, "music.mp3");
  soundfile.loop();
  
}

void draw() {
  background(0);
  world.step();
  if (frameCount%24 == 0) {  
    c.step();
  }
  c.display();
  colorMode(RGB,255,255,255);
  fill(255,0,0);
  noStroke();
  rect(50,0,10,100);
  int D = (width-50)/10;
  int d = int(map(frameCount%24, 0, 29, D, 0));
  for (int i = 0; i < 10; i ++){
    fill(255);
    rect(d + D*i + 50, 0 , 10 ,100);
  }
}

void keyPressed() {
  if (key == 'd' || key == 'D')
    c.Zhu.forward();
  if (key == 'a' || key == 'A')
    c.Zhu.backward();
  if (key == 'z')
    c.Zhu.state = "attack";
}