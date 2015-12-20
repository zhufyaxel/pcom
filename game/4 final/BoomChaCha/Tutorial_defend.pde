public class Tutorial_defend {
  // BGM
  BGM bgm;

  //Visual part
  BkgVisual_defend bk;
  Defender yue;
  Warrior zhu;
  Mage shu;
  Monster mon;
  // Guide_Content
  Sword sword;
  Wand wand;
  Shield shield;
  // sound
  Minim minim;
  AudioPlayer magic, swipe, defence;
  AudioPlayer bad;  // added for monster
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
  boolean enablePass = false;
  boolean pass = false;
  int beatPass = 0;
  int cons_beat;// for change the instruction if it is too long;
  
  int score;

  Tutorial_defend(BGM _bgm) {
    bgm = _bgm;
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
    mon = new Monster(bgm.interval(), 760, 450, 438*0.95, 465*0.95, 15);
    monsOrder = "stay";    // stay, attack
    monsInterval1 = 8;     // practice mode
    monsInterval2 = 14;    // fight mode

    sword = new Sword();
    wand = new Wand();
    shield = new Shield();
    bk = new BkgVisual_defend();
    startBeat = bgm.beatsPlayed();
    // sound (Minim!!)
    minim = new Minim(BoomChaCha.this);
    magic = minim.loadFile("music/magic.mp3", 512);
    swipe = minim.loadFile("music/swipe.mp3", 512);
    defence = minim.loadFile("music/shield.mp3", 512);
    bad = minim.loadFile("music/bad_30.mp3", 512);

    dol = new Note(minim, "music/dol.mp3");
    mi = new Note(minim, "music/mi.mp3");
    sol = new Note(minim, "music/sol.mp3");
    dol_low = new Note(minim, "music/dol_low.mp3");
    mi_low = new Note(minim, "music/mi_low.mp3");
    sol_low = new Note(minim, "music/sol_low.mp3");

    pass = false;
    startBeat = 0;
    
    score = 0;
  }

  void setStart(int _startBeat) {
    startBeat = _startBeat;
    pass = false;
  }

  void execute() {
    bk.display(bgm.beatsPlayed(), bgm.phase, bgm.interval);
    beats = bgm.beatsPlayed() - startBeat;

    shu.lifeCycle(bgm.beatsPlayed(), bgm.phase());
    zhu.lifeCycle(bgm.beatsPlayed(), bgm.phase());
    yue.lifeCycle(bgm.beatsPlayed(), bgm.phase());
    mon.lifeCycle(bgm.beatsPlayed(), bgm.phase());

    // initial stage
    if (beats <= 48) {
      bk.text = "Tutorial 5 of 5: Powerful Defence";
      fill(0, 0, 0, 200);
      noStroke();
      rectMode(CENTER);
      rect(width/2, height/2 + 48, width, height - 96);
      if (beats < 12) {
        fill(255);
        text("A good defence saves your life.", width/2, height/2 - 40) ;
        text("A powerful one makes you immortal.", width/2, height/2);
      } else if (beats < 24) {
        fill(255);
        text("Push the shield on 'Boom' to defend yourselves.", width/2, height/2);
      } else if (beats < 36) {
        fill(255);
        text("Likewise, ", width/2, height/2 - 40);
        text("if shield is followed by 'Cha Cha', ", width/2, height/2);
        text("the defence will become more powerful.", width/2, height/2 + 40);
      } else if (beats < 48) {
        fill(255);
        text("Timing is the last thing you need to learn.", width/2, height/2);
      } 
    } 
    // after initialized, players' turn
    else if (beatPass == 0) {  // when not pass
      // time to begin practice
      if (!after_initial) {
        bk.text = null;
        after_initial = true;
      }
      // occur once when new beat comes 
      if (bgm.newBeatIn()) {
        onBeat();
      }
      // end
      if (score >= 5) {
        bk.text_mid = "Well done! You're well prepared!";
        beatPass = bgm.beatsPlayed();
      }
    } else {  // if beatPass != 0, 
      if (bgm.beatsPlayed() - beatPass >= 6) {
        bk.showGot = true;
        enablePass = true;
      }
    }
  }

  void onBeat() {
    int n = bgm.n();
    
    // players' cycle
    if (n == 2) {
      // clear text
      bk.text_mid = null;
    }
    
    if (n == 3) {
      // get feedback
      if (orders[0] == "Defend") {
        power = beatJudges[0] + beatJudges[1] + beatJudges[2];
        yue.setState("defend");
        println("Defend", power);
        if (beatJudges[0] != 0 && beatJudges[1] != 0 && beatJudges[2] != 0) {
          if (mon.currentState() == "attack") {
            score += 1;
            bk.text_mid = "Powerful defence! Counted " + score + "/5";
          } else {
            bk.text_mid = "Powerful defence.";
          }
          //bk.excellent = true;
        } else {
          if (mon.currentState() == "attack") {
            bk.text_mid = "Counted! Assist with more 'Cha'.";
          } else {
            bk.text_mid = "Good. Assist with more 'Cha'.";
          }
          //bk.good = true;
        }
      } else if (orders[0] != "Null") {
        bk.text_mid = "Try to start 'Boom' with shield to defend yourself.";
        //bk.try_again = true;
      } else {
        if (beatJudges[1] != 0 || beatJudges[2] != 0) {
          bk.text_mid = "Try to make a 'Boom' with shield.";
          //bk.try_again = true;
        } else {
          // no input, do nothing
        }
      }
    }

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
      
      // replenish health or they will die fast
      zhu.blood = zhu.maxBlood * 2;
      yue.blood = yue.maxBlood * 2;
      shu.blood = shu.maxBlood * 2;
    }
    /// change the words
    
    //monster's cycle
    // when alive, do as many attack as it can
    if (mon.alive) {
      if (n == 2) {
        if (monsOrder == "stay" && mon.currentState() == "stay") {
          int mood = 1;
          if (mood == 1) {
            monsOrder = "attack";
          } else {
            monsOrder = "stay";
          }
        }
      }
      if (n == 3) {
        if (monsOrder == "attack" && mon.currentState() == "stay") {
          mon.setState("prepare");
          bad.rewind();
          bad.play();
        } 
        if (!mon.dying && (mon.currentState() == "attack" || mon.currentState() == "charge")) {
          monsterAttack();
          monsOrder = "stay";
        }
      }
    }
  }

  void monsterAttack() {
      if (orders[0] == "Defend") {
        defence.rewind();
        defence.cue(50);
        defence.play();
        if (power == 6) {
          zhu.blood -= 0;
          yue.blood -= 0;
          shu.blood -= 0;
        } else if (power > 2) {
          zhu.blood -= 1;
          yue.blood -= 1;
          shu.blood -= 1;
        } else {
          zhu.blood -= 2;
          yue.blood -= 2;
          shu.blood -= 2;
        }
      } else {
        zhu.blood -= 3;
        yue.blood -= 3;
        shu.blood -= 3;
      }
    }

  void myKeyInput() {
    if (after_initial) {
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
  }

  void myPortInput(String _input) {
    if (after_initial) {
      input = _input;
      inputValues();
    }
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
  void playerAttack(int power) {
    mon.blood -= power;
  }
}


public class BkgVisual_defend extends BkgVisual {
  PImage Instruction;
  PImage Excellent;
  PImage Good;
  PImage Try_again;
  PImage boom, cha;

  // booleans for feedback
  boolean excellent = false;
  boolean good = false;
  boolean try_again = false;

  BkgVisual_defend() {
    super();
    Instruction = loadImage("images/Tutorial_defend/t4.png");
    Excellent = loadImage("images/Tutorial_defend/perfect.png");
    Good = loadImage("images/Tutorial_defend/good.png");
    Try_again = loadImage("images/Tutorial_defend/try again.png");
    boom = loadImage("images/status/Boom.png");
    cha = loadImage("images/status/Cha.png");
    text_mid_y = 240;
  }

  void display(int beatNum, int phase, int interval) {
    super.display(beatNum, phase, interval);

    if (text == null) {
      // Instructions
      fill(255);
      noStroke();
      rectMode(CENTER);
      rect(width/2, 50, width, 100);
      image(Instruction, width/2, height/2);
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

    //// Boom Cha Cha
    //if (phase < interval * 2/3) {
    //  switch(beatNum % 6) {
    //  case 0:
    //    image(boom, 100, 300);
    //    break;
    //  case 1:
    //    image(cha, 100, 300);
    //    break;
    //  case 2:
    //    image(cha, 100, 300);
    //    break;
    //  }
    //}
  }
}