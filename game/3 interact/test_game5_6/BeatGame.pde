public class BeatGame {
  // global variables
  int latency;        // loading resources need time
  int videoLatency;  // video is faster than sound, need time to align
  int userLatency;  // when you hear and follow the music you need time to react

  String stage;   // stage 1: "practice" free trial
  // stage 2: "fight" play and monster fight, and score at the same time
  // stage 3: "defeated" player dead -> fight again: back to stage 2
  //                             -> practice again: back to stage 1

  int score;
  PImage tryagain = loadImage("images/background/try_again.png");

  // music characteristics
  int bpm;
  int interval;
  int one_third;
  int two_third;
  int phase;
  int beatNum;  // boom = 0; cha = 1; cha = 2; act 3; act 4; act 5;
  boolean beatIn;  // boom {beatIn (2/3), beatOff (1/3)}, cha {beatIn, beatOff}, cha {beatIn, beatOff}

  // input controls and vals (v2, multiple_key3)
  String[] orders;
  int[] beatJudges;
  int sum;
  String serialInput;  //serial input

  // monster's orders
  String monsOrder;
  int beatClear;    // time when clear up the monster
  int monsInterval;  // gap between a new monster respawn

  // visual and sound
  Visual visual;
  SoundFile music;

  SoundFile dol;
  SoundFile mi;
  SoundFile sol;

  // Characters and monsters
  Defender yue;
  Warrior zhu;
  Mage wangshu;
  ArrayList<Monster> mon;

  BeatGame () {
    // global settings
    imageMode(CENTER);

    // global vals
    bpm = 150;    // 180 with funny_mono
    interval = round(60000.0/bpm); // milliseconds, 60 * 1000 / bpm 
    one_third = interval *1/3;
    two_third = interval *2/3;
    phase = 0;
    beatNum = 0;
    beatIn = true;

    stage = "practice";
    score = 0;

    // input
    orders = new String[3];
    beatJudges = new int[3];
    for (int i = 0; i < 3; i++) {
      orders[i] = "Null";
      beatJudges[i] = 0;
    }

    // monster's order
    monsOrder = "stay";    // stay, attack
    monsInterval = 14;

    // visual and music
    visual = new Visual();
    music = new SoundFile(test_game5_6.this, "music/funny_slow_drum2 2_mono.mp3");

    dol = new SoundFile(test_game5_6.this, "music/dol.mp3");
    mi = new SoundFile(test_game5_6.this, "music/mi.mp3");
    sol = new SoundFile(test_game5_6.this, "music/sol.mp3");
    dol.amp(0.2);
    mi.amp(0.2);
    sol.amp(0.2);

    // characters and monsters
    yue = new Defender(interval, 466, 489, 241, 388, 4);
    zhu = new Warrior(interval, 285, 489, 226, 388, 4);
    wangshu = new Mage(interval, 139, 489, 225, 388, 4);
    mon = new ArrayList<Monster>();
    mon.add(new Monster(interval, 760, 450, 436, 465, 12));

    // put music here to get accuracy
    music.loop();
    latency = millis();
    videoLatency = 450;  //300 with original
    userLatency = 128;  //keyboard
    //userLatency = 90;  // serial, special thanks for Zhi Gao
  }

  // main steps in draw()
  void execute() {
    background(0);
    beatCycle();

    visual.show(beatNum, beatIn, phase, interval);

    switch(stage) {
    case "practice":
      if (key == 'f' || key == 'F' ) {
        stage = "fight";
        break;
      }

      if (mon.size() > 0) {
        mon.get(0).lifeCycle(beatNum, phase);

        if (!mon.get(0).isAlive()) {
          // ********** score here somehow ************//
          mon.remove(0);
          beatClear = beatNum;
        }
      }
      // respawn the monster
      // try to avoid respawn on beat
      if (mon.size() == 0) {
        if ((beatNum - beatClear) == monsInterval) {
          mon.add(new Monster(interval, 760, 450, 436, 465, 12));
        }
      }

      wangshu.lifeCycle(beatNum, phase);
      zhu.lifeCycle(beatNum, phase);
      yue.lifeCycle(beatNum, phase);

      break;

    case "fight":
      if (!zhu.isAlive()) {
        stage = "defeated";
        break;
      }

      if (mon.size() > 0) {
        mon.get(0).lifeCycle(beatNum, phase);

        if (!mon.get(0).isAlive()) {
          // ********** score here somehow ************//
          mon.clear();
          beatClear = beatNum;
        }
      }
      // respawn the monster
      // try to avoid respawn on beat
      if (mon.size() == 0) {
        if ((beatNum - beatClear) == monsInterval) {
          mon.add(new Monster(interval, 760, 450, 436, 465, 12));
        }
      }

      wangshu.lifeCycle(beatNum, phase);
      zhu.lifeCycle(beatNum, phase);
      yue.lifeCycle(beatNum, phase);

      break;

    case "defeated":
      if (mon.size() > 0) {
        mon.get(0).lifeCycle(beatNum, phase);
      }

      showOptions();    // heal = practice mode, attack = fight mode

      if (orders[0] == "Heal") {
        yue = new Defender(interval, 466, 489, 241, 388, 4);
        zhu = new Warrior(interval, 285, 489, 226, 388, 4);
        wangshu = new Mage(interval, 139, 489, 225, 388, 4);

        stage = "practice";
        break;
      }
      if (orders[0] == "Attack") {
        yue = new Defender(interval, 466, 489, 241, 388, 4);
        zhu = new Warrior(interval, 285, 489, 226, 388, 4);
        wangshu = new Mage(interval, 139, 489, 225, 388, 4);

        stage = "fight";
        break;
      }

      break;
    }
  }

  //compute some music characteristics that control all visuals and characters
  void beatCycle() {
    int currentTime = millis() - latency - videoLatency;  //correction
    phase = currentTime % interval;

    if (beatIn) {
      if (phase >= two_third) {
        beatIn = false;
      }
    } else {
      if (phase < one_third) {  // on new beat 
        beatIn = true;
        beatNum += 1;

        onBeat();
      }
    }
  }

  // call only once when status flipping
  void onBeat() {
    int n = beatNum % 6;

    // players' cycle
    if (stage != "defeated") {
      if (n == 3) {
        sum = beatJudges[0] + beatJudges[1] + beatJudges[2];
        //sum = 6;
        if (orders[0] == "Attack" ) {
          //zhu.jump(true);
          zhu.setState("attack");
          playerAttack(sum);
          println("Attack", sum);
        }
        if (orders[0] == "Heal" ) {
          wangshu.setState("heal");
          println("Heal", sum);
        }
        if (orders[0] == "Defend" ) {
          yue.setState("defend");
          println("Defend", sum);
          //playerDefend(sum);  // see monsterattack
        }
      }
      if (n == 4) {
        for (int i = 0; i < 3; i++) {
          orders[i] = "Null";
          beatJudges[i] = 0;
        }
      }

      if (n == 5 && wangshu.currentState() == "heal") {
        playerHeal(sum);
      }
    }

    // monsters' cycle: random decision to attack, charge up and execute the same time as players
    // make decision at beatNum 2, show intension at beat 345, charging at next beat 012, attack at next beat 345.
    if (stage == "fight" && mon.size() > 0 && mon.get(0).isAlive()) {    //beatNum > 24 && mon.get(0).alive
      if (n == 2) {
        if (monsOrder == "stay" && mon.get(0).currentState() == "stay") {
          int mood = int(random(0, 3));
          if (mood == 1) {
            monsOrder = "attack";
          } else {
            monsOrder = "stay";
          }
        }
      }
      if (n == 3) {
        if (monsOrder == "attack" && mon.get(0).currentState() == "stay") {
          mon.get(0).setState("prepare");
          //sword.play();
        } 
        if (!mon.get(0).dying && (mon.get(0).currentState() == "attack" || mon.get(0).currentState() == "charge")) {
          monsterAttack();
          monsOrder = "stay";
        }
      }
    }
  }

  void playerAttack(int sum) {
    //zhu.attack(int phase, int interval);
    // ******** when player is alive then do attack ********
    // so they really need to share life, or just pretent to do so
    if (mon.size() > 0) {
      mon.get(0).blood -= sum;
    }
  }

  void monsterAttack() {
    if (orders[0] == "Defend") {
      if (sum == 6) {
        zhu.blood -= 0;
        yue.blood -= 0;
        wangshu.blood -= 0;
      } else {
        zhu.blood -= 1;
        yue.blood -= 1;
        wangshu.blood -= 1;
      }
    } else {
      zhu.blood -= 2;
      yue.blood -= 2;
      wangshu.blood -= 2;
    }
  }

  void playerHeal(int sum) {
    if (sum == 6) {
      if (zhu.blood < 2 * zhu.maxBlood) {
        zhu.blood += 2;
        yue.blood += 2;
        wangshu.blood += 2;
      }
    } else {
      if (zhu.blood < 2* zhu.maxBlood) {
        zhu.blood += 1;
        yue.blood += 1;
        wangshu.blood += 1;
      }
    }
  }

  void showOptions() {
    image(tryagain, width/2, height/2);
  }

  // custom keyPressed event
  // a - mage, s - warrior, d - defendor
  // Up - increase latency; Down - decrease latency
  void myKeyPressed() {
    if (key != CODED) {  // ASD controls characters
      inputValues();
    } 
    // if key == coded, UP and DOWN adjust additional latency
    else {
      adjustLatency();
    }
  }

  // physical input, same as keyboard
  void myPort(String _input) {
    serialInput = _input;
  }

  void inputValues() {
    int currentPhase = (millis() - latency - videoLatency - userLatency) % interval;
    boolean onBeat = (currentPhase <= one_third || currentPhase >= two_third);  // true if on beat
    //boolean onBeat = true;
    // beatNum 0, 1, 2, (3, 4, 5)
    // when there is key there will be jump
    // when there is a hit there will be effect, and register the first key
    int n = beatNum % 6;
    int index = n;
    if (n == 5) index = 0;
    if (serialInput == "wand" || key=='a' || key == 'A') {
      dol.play();
      wangshu.jump(onBeat);
      if (n < 3 || n == 5) {    // beatNum % 6 < 3 || beatNum == 5, because some may hit before the first beat
        if (orders[index] == "Null") {
          orders[index] = "Heal";
          if (onBeat) {
            beatJudges[index] = 2;
          } else {
            beatJudges[index] = 1;
          }
        }
      }
    }
    if (serialInput == "swipe" || key=='s' || key == 'S') {
      sol.play();
      zhu.jump(onBeat);
      if (n < 3 || n == 5) {    // beatNum % 6 < 3 || beatNum == 5, because some may hit before the first beat
        if (orders[index] == "Null") {
          orders[index] = "Attack";
          if (onBeat) {
            beatJudges[index] = 2;
          } else {
            beatJudges[index] = 1;
          }
        }
      }
    }
    if (serialInput == "defend" || key=='d' || key == 'D') {
      mi.play();
      yue.jump(onBeat);
      if (n < 3 || n == 5) {    // beatNum % 6 < 3 || beatNum == 5, because some may hit before the first beat
        if (orders[index] == "Null") {
          orders[index] = "Defend";
          if (onBeat) {
            beatJudges[index] = 2;
          } else {
            beatJudges[index] = 1;
          }
        }
      }
    }
  }

  void adjustLatency () {
    if (keyCode == UP) {
      userLatency += 5;
      println("User Latency: ", userLatency);
    } else if (keyCode == DOWN) {
      userLatency -= 5;
      println("User Latency: ", userLatency);
    } else if (keyCode == RIGHT) {
      videoLatency += 10;
      println("Video Latency: ", videoLatency);
    } else if (keyCode == LEFT) {
      videoLatency -= 10;
      println("Video Latency: ", videoLatency);
    }
  }
}