import processing.serial.*;
import ddf.minim.*;

BGM bgm;
Tutorial_take_weapon scene1;
Tutorial_attack scene2;
void setup() {
  size(1024, 768, P2D);
  // bgm here
  String path = "music/funny_170.mp3";
  bgm = new BGM(path, 170, 120);
  scene1 = new Tutorial_take_weapon();
  // Scene here
  scene1.setStart(bgm.beatsPlayed() + 3);
  scene2 = new Tutorial_attack();
  scene2.setStart(bgm.beatsPlayed() + 3);
}

void draw() {
  scene2.execute();
  
}

void keyPressed(){
  scene2.myKeyInput();
}