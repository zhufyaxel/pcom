import processing.serial.*;
import ddf.minim.*;

BGM bgm;
Tutorial_take_weapon scene1;
void setup() {
  size(1024, 768, P2D);
  // bgm here
  String path = "music/funny_170.mp3";
  bgm = new BGM(path, 170, 120);
  scene1 = new Tutorial_take_weapon();
  // Scene here
  scene1.setStart(bgm.beatsPlayed() + 3);
}

void draw() {
  scene1.execute();
  
}

void keyPressed(){
  scene1.myKeyInput();
}