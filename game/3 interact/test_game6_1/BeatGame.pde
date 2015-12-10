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
  int beatFight;
  int beatsSurvive;

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
  String input;  //serial input or key input

  // monster's orders
  String monsOrder;
  int beatClear;    // time when clear up the monster
  int monsInterval1, monsInterval2;  // gap between a new monster respawn

  // visual and sound
  Visual visual;
  SoundFile music;

  String dol, mi, sol;
  ArrayList<Note> notes;

  // Characters and monsters
  Defender yue;
  Warrior zhu;
  Mage shu;
  ArrayList<Monster> mon;

  // positions and parameters
  float xYue, yYue, wYue, hYue;
  float xZhu, yZhu, wZhu, hZhu;
  float xShu, yShu, wShu, hShu;
  int bPlayer;

  float xMon, yMon, wMon, hMon;
  int bMon;


  BeatGame () {
    // global settings
    imageMode(CENTER);

    // creatures' parameters
    xYue = 466; 
    yYue = 489; 
    wYue = 241*0.95; 
    hYue = 388*0.95;
    xZhu = 285; 
    yZhu = 489; 
    wZhu = 226*0.95; 
    hZhu = 388*0.95;
    xShu = 139; 
    yShu = 489; 
    wShu = 225*0.95; 
    hShu = 388*0.95;
    bPlayer = 4;

    xMon = 760; 
    yMon = 450; 
    wMon = 438*0.95; 
    hMon = 465*0.95;
    bMon = 12;

    // global vals
    bpm = 150;    // 180 with funny
    interval = round(60000.0/bpm); // milliseconds, 60 * 1000 / bpm 
    one_third = interval *1/3;
    two_third = interval *2/3;
    phase = 0;
    beatNum = 0;
    beatIn = true;

    stage = "practice";
    score = 0;
    beatFight = 0;
    beatsSurvive = 0;

    // input
    orders = new String[3];
    beatJudges = new int[3];
    for (int i = 0; i < 3; i++) {
      orders[i] = "Null";
      beatJudges[i] = 0;
    }

    // monster's order
    monsOrder = "stay";    // stay, attack
    monsInterval1 = 8;     // practice mode
    monsInterval2 = 20;    // fight mode

    // visual and music
    visual = new Visual();
    music = new SoundFile(test_game6_1.this, "music/funny_slow_drum2 2_min.mp3");

    dol = "music/dol_min.mp3";
    mi = "music/mi_min.mp3";
    sol = "music/sol_min.mp3";
    notes = new ArrayList<Note>();

    // characters and monsters
    yue = new Defender(interval, xYue, yYue, wYue, hYue, bPlayer);
    zhu = new Warrior(interval, xZhu, yZhu, wZhu, hZhu, bPlayer);
    shu = new Mage(interval, xShu, yShu, wShu, hShu, bPlayer);
    mon = new ArrayList<Monster>();
    mon.add(new Monster(interval, xMon, yMon, wMon, hMon, bMon));

    // put music here to get accuracy    
    music.amp(0.6);      
    music.loop();

    latency = millis();
    videoLatency = 740;  //300 with original
    //userLatency = 128;  //keyboard
    userLatency = 90;  // serial, special thanks for Zhi Gao
  }

  // main steps in draw()
  void execute() {
    background(0);
    beatCycle();

    noteCycle();

    visual.show(beatNum, beatIn, phase, interval);

    switch(stage) {
    case "practice":
      if (key == '2') {
        stage = "fight";
        score = 0;
        beatFight = beatNum;
        break;
      }

      if (!zhu.isAlive()) {
        stage = "defeated";
        break;
      }

      if (mon.size() > 0) {
        mon.get(0).lifeCycle(beatNum, phase);

        if (!mon.get(0).isAlive()) {
          // ********** score here somehow ************//
          score ++;
          mon.remove(0);
          beatClear = beatNum;
        }
      }
      // respawn the monster
      // try to avoid respawn on beat
      if (mon.size() == 0) {
        if ((beatNum - beatClear) == monsInterval1) {
          mon.add(new Monster(interval, xMon, yMon, wMon, hMon, bMon));
        }
      }

      shu.lifeCycle(beatNum, phase);
      zhu.lifeCycle(beatNum, phase);
      yue.lifeCycle(beatNum, phase);

      textSize(28);
      fill(0);
      text("Killed: " + score, 680, 720);

      break;

    case "fight":
      if (key == '1') {
        stage = "practice";
        break;
      }

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
          score ++;
        }
      }
      // respawn the monster
      // try to avoid respawn on beat
      if (mon.size() == 0) {
        if ((beatNum - beatClear) == monsInterval2) {
          mon.add(new Monster(interval, xMon, yMon, wMon, hMon, bMon));
        }
      }

      shu.lifeCycle(beatNum, phase);
      zhu.lifeCycle(beatNum, phase);
      yue.lifeCycle(beatNum, phase);

      textSize(28);
      fill(0);

      beatsSurvive = beatNum - beatFight;
      text("Beats survived: "+ beatsSurvive, 180, 720);

      text("Killed: " + score, 680, 720);

      break;

    case "defeated":
      if (mon.size() > 0) {
        mon.get(0).lifeCycle(beatNum, phase);
      }

      showOptions();    // heal = practice mode, attack = fight mode

      text("Beats survived: "+ beatsSurvive, 180, 720);
      text("Killed: " + score, 680, 720);

      if (orders[0] == "Heal") {
        yue = new Defender(interval, xYue, yYue, wYue, hYue, bPlayer);
        zhu = new Warrior(interval, xZhu, yZhu, wZhu, hZhu, bPlayer);
        shu = new Mage(interval, xShu, yShu, wShu, hShu, bPlayer);

        stage = "practice";
        break;
      }
      if (orders[0] == "Attack") {
        yue = new Defender(interval, xYue, yYue, wYue, hYue, bPlayer);
        zhu = new Warrior(interval, xZhu, yZhu, wZhu, hZhu, bPlayer);
        shu = new Mage(interval, xShu, yShu, wShu, hShu, bPlayer);

        score = 0;
        beatFight = beatNum;

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
          zhu.removeArrow();
          playerAttack(sum);
          println("Attack", sum);
        }
        if (orders[0] == "Heal" ) {
          shu.setState("heal");
          shu.removeArrow();
          println("Heal", sum);
        }
        if (orders[0] == "Defend" ) {
          yue.setState("defend");
          yue.removeArrow();
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

      if (n == 5 && shu.currentState() == "heal") {
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

  void noteCycle() {
    if (notes.size() > 0) {
      for (int i = 0; i < notes.size(); i++) {
        notes.get(i).life();
        if (!notes.get(i).isPlaying) {
          println(i);
          println(notes.get(i).sound.returnId());
          notes.remove(i);
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
      if (sum >= 4) {
        zhu.blood -= 0;
        yue.blood -= 0;
        shu.blood -= 0;
      } else {
        zhu.blood -= 1;
        yue.blood -= 1;
        shu.blood -= 1;
      }
    } else {
      zhu.blood -= 2;
      yue.blood -= 2;
      shu.blood -= 2;
    }
  }

  void playerHeal(int sum) {
    if (sum >=4) {
      if (zhu.blood < 2 * zhu.maxBlood) {
        zhu.blood += 2;
        yue.blood += 2;
        shu.blood += 2;
      }
    } else {
      if (zhu.blood < 2* zhu.maxBlood) {
        zhu.blood += 1;
        yue.blood += 1;
        shu.blood += 1;
      }
    }
  }

  void showOptions() {
    image(tryagain, width/2, height/2);
  }


  void myKeyPressed() {
    if (key != CODED) {  // ASD controls keys, alphabetical etc
      myKeyInput();
      inputValues();
      takeDamage();
    } 
    // if key == coded, UP and DOWN adjust additional latency
    else {
      adjustLatency();
    }
  }

  // physical input, same as keyboard
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
  }

  void myPortInput(String _input) {
    input = _input;
    inputValues();
  }

  void inputValues() {
    int currentPhase = (millis() - latency - videoLatency - userLatency) % interval;
    int n = beatNum % 6;
    int index = n;
    if (n == 5) index = 0;

    boolean onCycle = (n < 3 || (n == 5 && currentPhase > two_third));
    boolean onBeat = (currentPhase <= one_third || currentPhase >= two_third);  // true if on beat
    //boolean onBeat = true;
    // beatNum 0, 1, 2, (3, 4, 5)
    // when there is key there will be jump
    // when there is a hit there will be effect, and register the first key

    if (input == "wand") {
      input = "";
      shu.jump(onCycle && onBeat);
      if (onCycle) {    // beatNum % 6 < 3 || beatNum == 5, because some may hit before the first beat
        notes.add(new Note(dol));
        if (orders[index] == "Null") {
          if (index == 0) {
            shu.addArrow();
          }          
          orders[index] = "Heal";
          if (onBeat) {
            beatJudges[index] = 2;
          } else {
            beatJudges[index] = 1;
          }
        }
      }
    }
    if (input == "swipe") {
      input = "";
      zhu.jump(onCycle && onBeat);
      if (onCycle) {    // beatNum % 6 < 3 || beatNum == 5, because some may hit before the first beat
        notes.add(new Note(sol));      
        if (orders[index] == "Null") {
          if (index == 0) {
            zhu.addArrow();
          }
          orders[index] = "Attack";
          if (onBeat) {
            beatJudges[index] = 2;
          } else {
            beatJudges[index] = 1;
          }
        }
      }
    }
    if (input == "defend") {
      input = "";
      yue.jump(onCycle && onBeat);
      if (onCycle) {    // beatNum % 6 < 3 || beatNum == 5, because some may hit before the first beat
        notes.add(new Note(mi));
        if (orders[index] == "Null") {
          if (index == 0) {
            yue.addArrow();
          }
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

  // for practice purpose, slowly kill yourself
  void takeDamage() {
    println("Hey!!");
    if (key == '-') {
      zhu.changeBlood(-2);
      shu.changeBlood(-2);
      yue.changeBlood(-2);
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