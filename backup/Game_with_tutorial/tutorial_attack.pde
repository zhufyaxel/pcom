public class Tutorial_attack {
  //Visual part
  BkgVisual_2 bk;
  Defender yue;
  Warrior zhu;
  Mage shu;
  Monster mon;
  // Guide_Content
  Sword_2 sword;
  Wand_2 wand;
  Sheild_2 sheild;
  // sound
  Minim minim;
  AudioPlayer magic, swipe, shield;
  Note dol, mi, sol;
  Note dol_low, mi_low, sol_low;
  //something for judgement
  int startBeat;
  int beats;// for counting the stage beats;
  String input;

  String feedback;
  ///player's order
  String[] orders;
  int[] beatJudges;
  int power;
  boolean warriorCalled = false;
  boolean mageCalled = false;
  boolean defenderCalled = false;
  ///Monster's order
  String monsOrder;
  int beatClear;    // time when clear up the monster
  int monsInterval1, monsInterval2;  // gap between a new monster respawn

  boolean after_initial = false;
  boolean pass = false;
  int cons_beat;// for change the construction if it is too long;

  Tutorial_attack() {
    // input
    orders = new String[3];
    beatJudges = new int[3];
    for (int i = 0; i < 3; i++) {
      orders[i] = "Null";
      beatJudges[i] = 0;
    }
    //Characters, x,y,w,h,blood
    // creatures' parameters

    imageMode(CENTER);
    yue = new Defender(bgm.interval(), 466, 489, 241*0.95, 388*0.95, 4);
    zhu = new Warrior(bgm.interval(), 285, 489, 226*0.95, 388*0.95, 4);
    shu = new Mage(bgm.interval(), 139, 489, 225*0.95, 388*0.95, 4);
    mon = new Monster(bgm.interval(), 760, 450, 438*0.95, 465*0.95, 12);
    monsOrder = "stay";    // stay, attack
    monsInterval1 = 8;     // practice mode
    monsInterval2 = 14;    // fight mode

    sword = new Sword_2();
    wand = new Wand_2();
    sheild = new Sheild_2();
    bk = new BkgVisual_2();
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
    bgm.step();
    shu.lifeCycle(bgm.beatsPlayed(), bgm.phase());
    zhu.lifeCycle(bgm.beatsPlayed(), bgm.phase());
    yue.lifeCycle(bgm.beatsPlayed(), bgm.phase());
    mon.lifeCycle(bgm.beatsPlayed(), bgm.phase());
    beats = bgm.beatsPlayed() - startBeat;
    if (beats < 6) {
      bk.text = "Enemy comes, let's learn attack";
    }
    if (beats >6 && beats < 18) {
      bk.text = "If Worrier sway sword on 'Boom', the team will attack";
    }
    if (beats >18 && beats < 30) {
      bk.text = "Other two do 'Cha Cha' will power-up the attack";
    }
    if (beats > 30) {
      after_initial = true;
    }
    //during 
    if (beats > 6 && !pass) {
      if (bgm.newBeatIn()) {
        onBeat();
      }
    }
    //Actually that is the Scene2, for convience I merged these two Scene together
    //if (bgm.beatsPlayed() - startBeat >= 15 && !pass) {
    //  if (bgm.newBeatIn()) {
    //    onBeat();
    //  }

    //  if (bgm.n >= 3 && bgm.n <=4) {
    //    text(feedback, width/2, height/2);
    //  }
    //  if (bgm.n == 5) {
    //    if (bgm.phase() > bgm.interval() * 2 / 3) {
    //      sword.display(0);
    //    }
    //  }
  }

  void onBeat() {
    int n = bgm.n();
    if (n == 1) {
      if (beats%12 == 0) {
        bk.text = "Try to beat your enemy";
      }
    }
    if (n == 3) {
      if (orders[0] == "Attack") {
        power = beatJudges[0] + beatJudges[1] + beatJudges[2];
        //power = 6;
        if (orders[0] == "Attack" ) {
          //zhu.jump(true);
          swipe.rewind();
          swipe.cue(100);
          swipe.play();
          zhu.setState("attack");
          playerAttack(power);
          println("Attack", power);
          if (after_initial) {
            if (beatJudges[0] != 0 && beatJudges[1] != 0 && beatJudges[2] != 0) {
              bk.text = "Excellent Attack!";
              bk.excellent = true;
            } else {
              bk.text = "Good Attack! Trying to make 'Cha Cha' for supportance";
              bk.good = true;
            }
          }
        }
      } else {
        if (after_initial) {
          bk.text = null;
          bk.try_again = true;
        }
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
    if (n == 5) {
      bk.excellent = false;
      bk.good = false;
      bk.try_again = false;
    }
    /// change the words
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
  void playerAttack(int power) {

    mon.blood -= power;
  }
}



public class Sword_2 {
  PImage swords[];
  Sword_2() {
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

public class Wand_2 {
  PImage wands[];
  Wand_2() {
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

public class Sheild_2 {
  PImage pics[];
  Sheild_2() {
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


public class BkgVisual_2 {
  PImage imgBkg;
  PImage imgEyes;
  PImage Construction;
  PImage Excellent;
  PImage Good;
  PImage Try_again;
  // words
  String text;
  PFont aw;
  PImage pots[];
  // booleans for feedback
  boolean excellent = false;
  boolean good = false;
  boolean try_again = false;

  BkgVisual_2() {
    imgBkg = loadImage("images/Tutorial_take_weapon/background.png");
    imgEyes = loadImage("images/Tutorial_take_weapon/blinking eye.png");
    Construction = loadImage("images/Tutorial_attack/t4.png");
    Excellent = loadImage("images/Tutorial_attack/excellent.png");
    Good = loadImage("images/Tutorial_attack/good.png");
    Try_again = loadImage("images/Tutorial_attack/try again.png");
    text = "Welcome to Boom!Cha!Cha!";
    aw = createFont("Comic Sans MS Bold.ttf", 28);
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
    if (text != null) {
      textAlign(CENTER);
      textFont(aw);
      fill(0);
      text(text, width/2, 70);
    } else {
      image(Construction, width/2, height/2);
    }

    if (excellent) {
      image(Excellent, width/2, height/2);
    }
    if (good) {
      image(Good, width/2, height/2);
    }
    if (try_again) {
      image(Try_again, width/2, height/2);
    }


    // shadows
  }
}