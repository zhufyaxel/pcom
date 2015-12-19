public class Tutorial_take_weapon {
  //Visual part
  BkgVisual bk;
  Defender yue;
  Warrior zhu;
  Mage shu;
  // Guide_Content
  Sword sword;
  Wand wand;
  Sheild sheild;
  // sound
  Minim minim;
  AudioPlayer magic, swipe, shield;
  Note dol, mi, sol;
  Note dol_low, mi_low, sol_low;
  //something for judgement
  int startBeat;
  String input;

  String feedback;

  String[] orders;
  int[] beatJudges;
  boolean warriorCalled = false;
  boolean mageCalled = false;
  boolean defenderCalled = false;

  boolean pass;

  Tutorial_take_weapon() {
    // input
    orders = new String[3];
    beatJudges = new int[3];
    for (int i = 0; i < 3; i++) {
      orders[i] = "Null";
      beatJudges[i] = 0;
    }
    //Characters, x,y,w,h,blood
    imageMode(CENTER);
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
    sheild = new Sheild();
    bk = new BkgVisual();
    startBeat = bgm.beatsPlayed();
    // sound (Minim!!)
    minim = new Minim(Game_with_tutorial.this);
    magic = minim.loadFile("music/magic.mp3", 512);
    swipe = minim.loadFile("music/swipe.mp3", 512);
    shield = minim.loadFile("music/shield.mp3", 512);

    dol = new Note(minim, "music/dol.mp3");
    mi = new Note(minim, "music/mi.mp3");
    sol = new Note(minim, "music/sol.mp3");
    dol_low = new Note(minim, "music/dol_low.mp3");
    mi_low = new Note(minim, "music/mi_low.mp3");
    sol_low = new Note(minim, "music/sol_low.mp3");


    pass = false;
    startBeat = 0;
  }

  void setStart(int _startBeat) {
    startBeat = _startBeat;
    pass = false;
  }

  void execute() {
    bk.display(bgm.beatsPlayed(), bgm.phase, bgm.interval);
    if (bgm.beatsPlayed() - startBeat >= 3 && bgm.newBeatIn() && !shu.alive) {
      shu.alive = true;
      shu.jump(true);
      //myport.write()
    }
    if (bgm.beatsPlayed() - startBeat == 6 && bgm.newBeatIn()) {
      zhu.alive = true;
      zhu.jump(true);
      bk.text = "Characters are Coresponding to Weapons";
    }
    if (bgm.beatsPlayed() - startBeat == 9 && bgm.newBeatIn()) {
      yue.alive = true;
      yue.jump(true);
    }
    bgm.step();
    shu.lifeCycle(bgm.beatsPlayed(), bgm.phase());
    zhu.lifeCycle(bgm.beatsPlayed(), bgm.phase());
    yue.lifeCycle(bgm.beatsPlayed(), bgm.phase());
    if (bgm.beatsPlayed() - startBeat == 15) {
      bk.text = "Move with ICONS on rythm";
    }
    //Actually that is the Scene2, for convience I merged these two Scene together
    if (bgm.beatsPlayed() - startBeat >= 15 && !pass) {
      if (bgm.newBeatIn()) {
        onBeat();
      }
      if (bgm.n >= 3 && bgm.n <=4) {
        text(feedback, width/2, height/2);
      }
      if (bgm.n == 5) {
        if (bgm.phase() > bgm.interval() * 2 / 3) {
          sword.display(0);
        }
      }
      if (bgm.n == 0) {
        if (bgm.phase() < bgm.interval() / 4) {
          sword.display(1);
        }
        if (bgm.phase() < bgm.interval() / 2 && bgm.phase() > bgm.interval() /4) {
          sword.display(2);
        }
        if (bgm.phase() > bgm.interval() *3/4) {
          wand.display(0);
        }
      }
      if (bgm.n == 1) {
        if (bgm.phase() < bgm.interval() / 4) {
          wand.display(1);
        }
        if (bgm.phase() < bgm.interval() / 2 && bgm.phase() > bgm.interval() /4) {
          wand.display(2);
        }
        if (bgm.phase() > bgm.interval() *3/4) {
          sheild.display(0);
        }
      }
      if (bgm.n == 2) {
        if (bgm.phase() < bgm.interval() / 4) {
          sheild.display(1);
        }
        if (bgm.phase() < bgm.interval() / 2 && bgm.phase() > bgm.interval() /4) {
          sheild.display(2);
        }
      }
      ///Change the words whith certain time
      if ((bgm.beatsPlayed() - startBeat) % 18 == 0) {
        bk.text = "Move with ICONS on rythm";
      }
      if ((bgm.beatsPlayed() - startBeat) % 18 == 6) {
        bk.text = "Notice the rythm and shining of the monster";
      }
      if ((bgm.beatsPlayed() - startBeat) % 18 == 12) {
        bk.text = "That's the sigh for Excute Boom!Cha!Cha!";
      }
    }
  }

  void onBeat() {

    int n = bgm.n();
    if (n == 3) {
      if (orders[0] == "Attack" && orders[1] == "Heal" && orders[2] == "Defend") {
        feedback = "Correct";
      } else {
        feedback = "Try Again";
      }
    }
    // players' cycle
    if (n == 4) {
      for (int i = 0; i < 3; i++) {
        orders[i] = "Null";
        beatJudges[i] = 0;
      }
      mageCalled = false;
      warriorCalled = false;
      defenderCalled = false;
      zhu.removeBoom();
      shu.removeBoom();
      yue.removeBoom();
      zhu.removeCha();
      shu.removeCha();
      yue.removeCha();
    }
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
    int index = ((bgm.timePlayed() + bgm.interval()/2) / bgm.interval()) % 6;  //align to center

    boolean onCycle = (index < 3);
    boolean onBeat = (bgm.phase() <= bgm.interval() *1/3 || bgm.phase() >= bgm.interval() *2/3);  // true if on beat
    //boolean onBeat = true;
    // beatNum 0, 1, 2, (3, 4, 5)
    // when there is key there will be jump
    // when there is a hit there will be effect, and register the first key

    if (input == "wand") {
      input = "";
      shu.jump(onCycle && onBeat && !mageCalled);  // only when the three are true, then can the character jump high

      if (onCycle) {    // beatNum % 6 < 3 || beatNum == 5, because some may hit before the first beat
        if (onBeat) {
          dol.play();
        } else {
          dol_low.play();
        }

        if (orders[index] == "Null" && !mageCalled) {        
          orders[index] = "Heal";
          mageCalled = true;

          switch(index) {
          case 0:
            shu.addBoom();
            break;
          case 1: 
          case 2:
            shu.addCha();
            break;
          }

          if (onBeat) {
            beatJudges[index] = 2;
          } else {
            beatJudges[index] = 1;
          }
          println(index, orders[index], onBeat);
        }
      }
    }

    if (input == "swipe") {
      input = "";
      zhu.jump(onCycle && onBeat && !warriorCalled);  // only when the three are true, then can the character jump high

      if (onCycle) {    // beatNum % 6 < 3 || beatNum == 5, because some may hit before the first beat
        if (onBeat) {
          sol.play();
        } else {
          sol_low.play();
        } 

        if (orders[index] == "Null" && !warriorCalled) {
          orders[index] = "Attack";
          warriorCalled = true;

          switch(index) {
          case 0:
            zhu.addBoom();
            break;
          case 1: 
          case 2:
            zhu.addCha();
            break;
          }

          if (onBeat) {
            beatJudges[index] = 2;
          } else {
            beatJudges[index] = 1;
          }
          println(index, orders[index], onBeat);
        }
      }
    }

    if (input == "defend") {
      input = "";
      yue.jump(onCycle && onBeat && !defenderCalled);  // only when the three are true, then can the character jump high
      if (onCycle) {    // beatNum % 6 < 3 || beatNum == 5, because some may hit before the first beat
        if (onBeat) {
          mi.play();
        } else {
          mi_low.play();
        } 
        if (orders[index] == "Null" && !defenderCalled) {
          orders[index] = "Defend";
          defenderCalled = true;

          switch(index) {
          case 0:
            yue.addBoom();
            break;
          case 1: 
          case 2:
            yue.addCha();
            break;
          }

          if (onBeat) {
            beatJudges[index] = 2;
          } else {
            beatJudges[index] = 1;
          }
          println(index, orders[index], onBeat);
        }
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

public class Sheild {
  PImage pics[];
  Sheild() {
    pics = new PImage[3];
    for (int i = 0; i < 3; i++) {
      pics[i] = loadImage("images/Tutorial_take_weapon/animation/dun/d"+(i+1)+".png");
    }
  }
  void display(int index) {
    imageMode(CENTER);
    image(pics[index], width/2, height/2);
  }
}


public class BkgVisual {
  PImage imgBkg;
  PImage imgEyes;
  // words
  String text;
  PFont aw;
  PImage pots[];
  //  PImage[] shadow;//0 for wand, 1 for sword, 2 for sheild
  //  boolean[] shadowExist;
  BkgVisual() {
    imgBkg = loadImage("images/Tutorial_take_weapon/background.png");
    imgEyes = loadImage("images/Tutorial_take_weapon/blinking eye.png");
    text = "Welcome to Boom!Cha!Cha!";
    aw = createFont("Comic Sans MS Bold.ttf", 32);
    pots = new PImage[6];
    for (int i = 0; i < 6; i++) {
      pots[i] = loadImage("images/Tutorial_take_weapon/pots"+i+".png");
    }
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
    image(pots[beatNum % 6], width/2, height/2);

    textAlign(CENTER);
    textFont(aw);
    fill(0);
    text(text, width/2, 70);


    // shadows
  }
}