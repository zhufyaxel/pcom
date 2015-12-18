public class Tutorial_take_weapon {
  BGM bgm;
  BkgVisual bk;
  Defender yue;
  Warrior zhu;
  Mage shu;
  
  int startBeat;
  
  Tutorial_take_weapon() {
    // bgm
    String path = "music/funny_170.mp3";
    int bpm = 170;    // 180 with funny
    int musicBeats = 120;
    bgm = new BGM(path, bpm, musicBeats);
    //Characters, x,y,w,h,blood
    imageMode(CENTER);
    yue = new Defender(bgm.interval(), 812, 450, 241*1.2, 388*1.2, 4);
    zhu = new Warrior(bgm.interval(), 512, 450, 226*1.2, 388*1.2, 4);
    shu = new Mage(bgm.interval(), 240, 450, 225*1.2, 388*1.2, 4);
    yue.alive = false;
    zhu.alive = false;
    shu.alive = false;
    bk = new BkgVisual();
    startBeat = 5;
  }
  
  void execute() {
    bgm.step();
    bk.display(bgm.beatsPlayed(), bgm.phase(), bgm.interval());
    if (bgm.beatsPlayed() - startBeat == 1 && bgm.newBeatIn()){
      shu.alive = true;
      shu.jump(true);
      //myport.write()
    }
    if (bgm.beatsPlayed() - startBeat == 4 && bgm.newBeatIn()){
      zhu.alive = true;
      zhu.jump(true);
    }
    if (bgm.beatsPlayed() - startBeat == 7 && bgm.newBeatIn()){
      yue.alive = true;
      yue.jump(true);
    }
    shu.lifeCycle(bgm.beatsPlayed(), bgm.phase());
    zhu.lifeCycle(bgm.beatsPlayed(), bgm.phase());
    yue.lifeCycle(bgm.beatsPlayed(), bgm.phase());
  }
}

public class BkgVisual {
  PImage imgBkg;
  PImage imgEyes;

  BkgVisual() {
    imgBkg = loadImage("images/Tutorial_take_weapon/background.png");
    imgEyes = loadImage("images/Tutorial_take_weapon/blinking eye.png");
  }

  void display(int beatsPlayed, int phase, int interval) {     
    // trees
    imageMode(CENTER);
    image(imgBkg, width/2, height/2); 

    // eyes
    if (beatsPlayed % 6 <= 1 ) {
      image(imgEyes, width/2, height/2);
    } else if (beatsPlayed % 6 == 2) {
      //tint(255, 170);
      image(imgEyes, width/2, height/2);
      //noTint();
    } else if (beatsPlayed % 6 == 5) {
      if (phase > interval * 2/3) {
        //tint(255, 127);
        image(imgEyes, width/2, height/2);
        //noTint();
      }
    }
  }
}