// players on stage, hit boom and recognize each other

class Tutorial_take_weapon {
  // BGM copied from tutorial.bgm, refresh every loop
  BGM bgm;
  int startBeat;
  int beatShow;  // when characters appear

  //Visual part
  BkgVisual_take_weapon bk;
  Defender yue;
  Warrior zhu;
  Mage shu;

  // Guide_Content
  Sword sword;
  Wand wand;
  Shield shield;

  // sound
  Minim minim;
  AudioPlayer magic, swipe, defence;
  Note dol, mi, sol;
  Note dol_low, mi_low, sol_low;

  //something for judgement
  String input;
  String feedback;
  String[] orders;
  int[] beatJudges;
  boolean warriorCalled = false;
  boolean mageCalled = false;
  boolean defenderCalled = false;

  boolean enablePass;
  boolean pass;

  Tutorial_take_weapon(BGM _bgm) {
    // bgm
    bgm = _bgm;

    // input
    orders = new String[3];
    beatJudges = new int[3];
    for (int i = 0; i < 3; i++) {
      orders[i] = "Null";
      beatJudges[i] = 0;
    }
    //Characters, x,y,w,h,blood
    yue = new Defender(bgm.interval(), 812, 450, 241*1.2, 388*1.2, 4);
    zhu = new Warrior(bgm.interval(), 512, 450, 226*1.2, 388*1.2, 4);
    shu = new Mage(bgm.interval(), 240, 450, 225*1.2, 388*1.2, 4);
    yue.alive = false;
    zhu.alive = false;
    shu.alive = false;
    yue.hideBlood = true;
    zhu.hideBlood = true;
    shu.hideBlood = true;

    sword = new Sword();
    wand = new Wand();
    shield = new Shield();
    bk = new BkgVisual_take_weapon();

    // sound (Minim!!)
    minim = new Minim(BoomChaCha.this);
    magic = minim.loadFile("music/magic.mp3", 512);
    swipe = minim.loadFile("music/swipe.mp3", 512);
    defence = minim.loadFile("music/shield.mp3", 512);

    dol = new Note(minim, "music/dol.mp3");
    mi = new Note(minim, "music/mi.mp3");
    sol = new Note(minim, "music/sol.mp3");
    dol_low = new Note(minim, "music/dol_low.mp3");
    mi_low = new Note(minim, "music/mi_low.mp3");
    sol_low = new Note(minim, "music/sol_low.mp3");

    enablePass = false;
    pass = false;
    startBeat = bgm.beatsPlayed();
    beatShow = 0;
  }

  //void setStart(int _startBeat) {
  //  startBeat = _startBeat;
  //  pass = false;
  //}

  void execute() {
    bk.display(bgm.beatsPlayed(), bgm.phase, bgm.interval);

    if (bgm.newBeatIn()) {
      if (bgm.beatsPlayed() >= 5) {
        if (bgm.n == 0 && !zhu.alive) {
          zhu.alive = true;
          zhu.jump(true);
          bk.text_mid = "Sword performs attack!";
          beatShow = bgm.beatsPlayed();
        }
        if (beatShow != 0 && bgm.beatsPlayed - beatShow == 3) {
          myPort.write('d');
          zhu.setState("attack");
          swipe.play();
        }
        if (beatShow != 0 && bgm.beatsPlayed - beatShow == 6) {
          //myPort.write('f');
          yue.alive = true;
          yue.jump(true);
          bk.text_mid = "Shield prevents damage!";
        }
        if (beatShow != 0 && bgm.beatsPlayed - beatShow == 9) {
          //myPort.write('f');
          yue.setState("defend");
          defence.play();
        }
        if (beatShow != 0 && bgm.beatsPlayed - beatShow == 12) {
          //myPort.write('g');
          shu.alive = true;
          shu.jump(true);
          bk.text_mid = "Wand heals all!";
        }
        if (beatShow != 0 && bgm.beatsPlayed - beatShow == 15) {
          //myPort.write('g');
          shu.setState("heal");
          magic.play();
        }
        if (beatShow != 0 && bgm.beatsPlayed - beatShow == 18) {
          bk.text_mid = "Wand heals. Sword attacks. Shield defends.";
        }
        if (beatShow != 0 && bgm.beatsPlayed - beatShow == 24) {
          bk.showGot = true;
          enablePass = true;
        }
      }
    }

    shu.lifeCycle(bgm.beatsPlayed(), bgm.phase());
    zhu.lifeCycle(bgm.beatsPlayed(), bgm.phase());
    yue.lifeCycle(bgm.beatsPlayed(), bgm.phase());
  }
  
  void myKeyInput() {
   if (key=='a' || key == 'A') {
     input = "wand";
   }
   if (key=='s' || key == 'S') {
     input = "swipe";
   }
   if (key=='d' || key == 'd') {
     input = "defend";
   }

   inputValues();
 }

 void myPortInput(String _input) {
   input = _input;
   inputValues();
 }
 
 void inputValues() {
   if (input == "swipe") {
     if (enablePass) {
       sol.play();
       pass = true;
     }
   }
 }
}


public class Sword {
 PImage swords[];
 Sword() {
   swords = new PImage[3];
   for (int i = 0; i < 3; i++) {
     swords[i] = loadImage("images/Tutorial_take_weapon/animation/knife/k"+i+".png");
   }
 }
 void display(int index) {
   imageMode(CENTER);
   image(swords[index], width/2, height/2);
 }
}

public class Wand {
 PImage wands[];
 Wand() {
   wands = new PImage[3];
   for (int i = 0; i < 3; i++) {
     wands[i] = loadImage("images/Tutorial_take_weapon/animation/mozhanh/m"+(i+1)+".png");
   }
 }
 void display(int index) {
   imageMode(CENTER);
   image(wands[index], width/2, height/2);
 }
}

public class Shield {
 PImage shields[];
 Shield() {
   shields = new PImage[3];
   for (int i = 0; i < 3; i++) {
     shields[i] = loadImage("images/Tutorial_take_weapon/animation/dun/d"+(i+1)+".png");
   }
 }
 void display(int index) {
   imageMode(CENTER);
   image(shields[index], width/2, height/2);
 }
}


class BkgVisual {
  PImage imgBkg;
  PImage imgEyes;
  // words
  String text;
  String text_mid;
  int text_mid_y;  // position of text_mid
  PFont aw;
  PImage pots[];
  PImage border;
  
  boolean showGot;
  PImage gotit;
  //  PImage[] shadow;//0 for wand, 1 for sword, 2 for shield
  //  boolean[] shadowExist;
  BkgVisual() {
    imgBkg = loadImage("images/Tutorial_take_weapon/background.png");
    imgEyes = loadImage("images/Tutorial_take_weapon/blinking eye.png");
    aw = createFont("fonts/Comic Sans MS Bold.ttf", 32);
    pots = new PImage[6];
    for (int i = 0; i < 6; i++) {
      pots[i] = loadImage("images/Tutorial_take_weapon/pots"+i+".png");
    }
    border = loadImage("images/Tutorial_bkg/border.png");
    
    showGot = false;
    gotit = loadImage("images/Tutorial_bkg/gotit.png");
    
    text_mid_y = 300;
  }

  void display(int beatNum, int phase, int interval) {     
    // trees
    imageMode(CENTER);
    image(imgBkg, width/2, height/2); 
    // eyes
    if (beatNum % 6 <= 1 ) {
      image(imgEyes, width/2, height/2);
    } else if (beatNum % 6 == 2) {
      tint(255, 170);
      image(imgEyes, width/2, height/2);
      noTint();
    } else if (beatNum % 6 == 5) {
      if (phase > interval * 2/3) {
        tint(255, 127);
        image(imgEyes, width/2, height/2);
        noTint();
      }
    }
    // pots
    image(pots[beatNum % 6], width/2, height/2);
    
    // border
    if (beatNum % 6 < 2 || (beatNum % 6 == 2 && phase <= interval/2)) {
      tint(255,200);
      image(border, width/2, height/2);
      noTint();
    }
    if (beatNum % 6 == 2 && phase > interval / 2) {
      int alpha = round(map(phase, interval/2, interval, 200, 128));
      tint(255,alpha);
      image(border, width/2, height/2);
      noTint();
    }
    
    // text
    textAlign(CENTER);
    textFont(aw);
    if (text != null) {
      fill(0);
      text(text, width/2, 70);
    }
    if (text_mid != null) {
      fill(255);
      text(text_mid, width/2, text_mid_y);
    }
    
    // showGotit, skip
    if (showGot) {
      if (beatNum % 3 < 2) {
        image(gotit, width/2, 720);
      } else {
        int alpha = round(map(phase, 0, interval, 255, 0));
        tint(255, alpha);
        image(gotit, width/2, 720);
        noTint();
      }
    }

    // shadows
  }
}


class BkgVisual_take_weapon extends BkgVisual {
  BkgVisual_take_weapon() {
    super();
    text = "Tutorial 1 of 5: Weapons and abilities";
  }

  void display(int beatNum, int phase, int interval) {     
    super.display(beatNum, phase, interval);
  }
}