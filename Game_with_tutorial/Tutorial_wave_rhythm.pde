// ask players to wave one by one following the rhythm

class Tutorial_wave_rhythm {
  // BGM copied from tutorial.bgm, refresh every loop
  BGM bgm;
  int startBeat;

  //Visual part
  BkgVisual bk;
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

  int score;  // when they acted right three times then pass
  boolean enablePass;
  boolean pass;

  Tutorial_wave_rhythm(BGM _bgm) {
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
    yue.hideBlood = true;
    zhu.hideBlood = true;
    shu.hideBlood = true;

    sword = new Sword();
    wand = new Wand();
    shield = new Shield();
    bk = new BkgVisual();
    bk.text = "Tutorial 2 of 5: act with rhythm";
    bk.text_mid = "Follow the guides! Remember the rhythm.";

    // sound (Minim!!)
    minim = new Minim(Game_with_tutorial.this);
    magic = minim.loadFile("music/magic.mp3", 512);
    swipe = minim.loadFile("music/swipe.mp3", 512);
    defence = minim.loadFile("music/shield.mp3", 512);

    dol = new Note(minim, "music/dol.mp3");
    mi = new Note(minim, "music/mi.mp3");
    sol = new Note(minim, "music/sol.mp3");
    dol_low = new Note(minim, "music/dol_low.mp3");
    mi_low = new Note(minim, "music/mi_low.mp3");
    sol_low = new Note(minim, "music/sol_low.mp3");

    score = 0;
    enablePass = false;
    pass = false;
    startBeat = bgm.beatsPlayed();
  }

  void execute(BGM _bgm) {
    bgm = _bgm;
    bk.display(bgm.beatsPlayed(), bgm.phase, bgm.interval);

    if (bgm.newBeatIn()) {
      onBeat();
    }

    // where there was no guides...try memory
    if (score <= 3) {
      visual_guides();
    } else if (score <= 6) {
      bk.text_mid = "Nice. Continue acting when the border shines.";
    }

    shu.lifeCycle(bgm.beatsPlayed(), bgm.phase());
    zhu.lifeCycle(bgm.beatsPlayed(), bgm.phase());
    yue.lifeCycle(bgm.beatsPlayed(), bgm.phase());
    
    text("Goal:", 900, 680);
    text(score + "/7", 900, 720);
    if (score >= 7) {
      bk.text_mid = "Good job!";
      if (bgm.n == 2) {
        enablePass = true;
        bk.showGot = true;
      }
    }
  }

  void visual_guides() {
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
        shield.display(0);
      }
    }
    if (bgm.n == 1) {
      if (bgm.phase() < bgm.interval() / 4) {
        shield.display(1);
      }
      if (bgm.phase() < bgm.interval() / 2 && bgm.phase() > bgm.interval() /4) {
        shield.display(2);
      }
      if (bgm.phase() > bgm.interval() *3/4) {
        wand.display(0);
      }
    }
    if (bgm.n == 2) {
      if (bgm.phase() < bgm.interval() / 4) {
        wand.display(1);
      }
      if (bgm.phase() < bgm.interval() / 2 && bgm.phase() > bgm.interval() /4) {
        wand.display(2);
      }
    }

    if (bgm.n >= 3 && bgm.n <=5) {
      text(feedback, width/2, height/2);
    }
  }

  void onBeat() {
    int n = bgm.n();
    int power = beatJudges[0] + beatJudges[1] + beatJudges[2];
    if (n == 3) {
      if (orders[0] == "Null" && orders[1] == "Null" && orders[2] == "Null") {
        feedback = "";
      } else if (orders[0] == "Attack" && orders[1] == "Defend" && orders[2] == "Heal") {
        if (power == 6) {
          feedback = "Perfect!";
          score += 1;
        } else {
          feedback = "Correct!";
          //score += 1;
        }
      } else if (orders[0] == "Null") {
        feedback = "Need the Boom!";
      } else if (orders[1] == "Null" || orders[2] == "Null") {
        feedback = "Need more Cha!";
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
    if (n == 5 ) {
      feedback = "";
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
    if (enablePass) {
      if (input == "swipe") {
        pass = true;
      }
    }
    
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