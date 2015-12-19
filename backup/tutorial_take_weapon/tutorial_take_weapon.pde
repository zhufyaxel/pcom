import processing.serial.*;
import ddf.minim.*;

BeatMachine bm;
BkgVisual bk;
Defender yue;
Warrior zhu;
Mage shu;

int startBeat;

void setup() {
  size(1024, 768, P2D);
  // bm here
  bm = new BeatMachine(170);
  //Characters, x,y,w,h,blood
  imageMode(CENTER);
  yue = new Defender(bm.interval(), 812, 450, 241*1.2, 388*1.2, 4);
  zhu = new Warrior(bm.interval(), 512, 450, 226*1.2, 388*1.2, 4);
  shu = new Mage(bm.interval(), 240, 450, 225*1.2, 388*1.2, 4);
  yue.alive = false;
  zhu.alive = false;
  shu.alive = false;
  bm.setStartTime(millis());
  bk = new BkgVisual();
  startBeat = bm.beatNum();
}

void draw() {
  bm.step();
  bk.display(bm.beatNum, bm.phase, bm.interval);
  if (bm.beatNum() - startBeat == 1 && bm.flipping()){
    shu.alive = true;
    shu.jump(true);
    //myport.write()
  }
  if (bm.beatNum() - startBeat == 4 && bm.flipping()){
    zhu.alive = true;
    zhu.jump(true);
  }
  if (bm.beatNum() - startBeat == 7 && bm.flipping()){
    yue.alive = true;
    yue.jump(true);
  }
  shu.lifeCycle(bm.beatNum(), bm.phase());
  zhu.lifeCycle(bm.beatNum(), bm.phase());
  yue.lifeCycle(bm.beatNum(), bm.phase());
}


public class Tutorial_take_weapon {
}

public class BkgVisual {
  PImage imgBkg;
  PImage imgEyes;

  BkgVisual() {
    imgBkg = loadImage("images/Tutorial_take_weapon/background.png");
    imgEyes = loadImage("images/background/blinking eye.png");
  }

  void display(int beatNum, int phase, int interval) {     
    // trees
    imageMode(CENTER);
    image(imgBkg, width/2, height/2); 

    // eyes
    if (beatNum % 6 <= 1 ) {
      image(imgEyes, width/2, height/2 + 100);
    } else if (beatNum % 6 == 2) {
      tint(255, 170);
      image(imgEyes, width/2, height/2 + 100);
      noTint();
    } else if (beatNum % 6 == 5) {
      if (phase > interval * 2/3) {
        tint(255, 127);
        image(imgEyes, width/2, height/2 + 100);
        noTint();
      }
    }
  }
}