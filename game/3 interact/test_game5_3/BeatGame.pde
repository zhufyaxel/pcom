public class BeatGame {
  // global vals
  int latency;        // loading resources need time
  int videoLatency;  // video is faster than sound, need time to align
  int userLatency;  // when you hear and follow the music you need time to react

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

  // monster's orders
  String monsOrder;

  // visual and sound
  Visual visual;
  SoundFile music;
  //SoundFile sword;
  //SoundFile shield;
  //SoundFile wand;

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

    // input
    orders = new String[3];
    beatJudges = new int[3];
    for (int i = 0; i < 3; i++) {
      orders[i] = "Null";
      beatJudges[i] = 0;
    }

    // monster's order
    monsOrder = "null";    // null, stay, attack

    // visual and music
    visual = new Visual();
    music = new SoundFile(test_game5_3.this, "music/funny_slow_mono.mp3");
    //sword = new SoundFile(test_game5_3.this, "music/swords_x_2_hit_002.mp3");
    //shield = new SoundFile(test_game5_3.this, "music/shield_impact_with_sword.mp3");
    //wand = new SoundFile(test_game5_3.this, "music/triangle_hit_medium.mp3");
    
    // characters and monsters
    yue = new Defender(469, 564, 165, 244, 3);
    zhu = new Warrior(301, 564, 171, 244, 3);
    wangshu = new Mage(137, 564, 198, 244, 3);
    mon = new ArrayList<Monster>();
    mon.add(new Monster(765, 490, 425, 394, 10));

    // put music here to get accuracy
    music.loop();
    latency = millis();
    videoLatency = 300;
    //userLatency = 128;
    //userLatency = 120;
    userLatency = 70;  // special thaks for Zhi Gao
  }

  // main steps in draw()
  void execute() {
    background(0);
    beatCycle();

    visual.show(beatNum, beatIn, phase, interval);

    wangshu.lifeCycle(beatNum);
    zhu.lifeCycle(beatNum);
    yue.lifeCycle(beatNum);

    mon.get(0).lifeCycle(beatNum);

    if (!mon.get(0).alive) {
      // ********** score here somehow ************//
      mon.clear();
      mon.add(new Monster(765, 490, 425, 394, 10));
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
        onBeat();  

        beatIn = true;
        beatNum += 1;
      }
    }
  }

  // call only once when status flipping
  void onBeat() {
    int n = beatNum % 6;

    // players' cycle
    if (n == 3) {
      int sum = beatJudges[0] + beatJudges[1] + beatJudges[2];
      if (orders[0] == "Attack" ) {
        println("Attack", sum);
        playerAttack(sum);
      }
      if (orders[0] == "Heal" ) {
        println("Heal", sum);
        //playerHeal(sum);
      }
      if (orders[0] == "Defend" ) {
        println("Defend", sum);
        //playerDefend(sum);
      }
    }
    if (n == 4) {
      for (int i = 0; i < 3; i++) {
        orders[i] = "Null";
        beatJudges[i] = 0;
      }
    }

    // monsters' cycle: random decision to attack, charge up and execute the same time as players
    // 24 beats after start, begin to hit players
    // make decision at beatNum 2, show intension at beat 345, charging at next beat 012, attack at next beat 345.
    // attack and anything 
    if (beatNum > 24) {
      if (n == 2) {
        if (mon.get(0).alive && monsOrder == "null") {
          int mood = int(random(0, 2));
          if (mood == 1) {
            monsOrder = "attack";
          } else {
            monsOrder = "stay";
          }
        }
      }
    }
  }

  void playerAttack(int sum) {
    //zhu.attack(int phase, int interval);
    // ******** when player is alive then do attack ********
    // so they really need to share life, or just pretent to do so
    mon.get(0).blood -= sum;
  }

  // custom keyPressed event
  // a - mage, s - warrior, d - defendor
  // Up - increase latency; Down - decrease latency
  void myKeyPressed() {
    if (key != CODED) {  // ASD controls characters
      pushValues();
    } 
    // if key == coded, UP and DOWN adjust additional latency
    else {
      adjustLatency();
    }
  }

  void pushValues() {
    int currentPhase = (millis() - latency - videoLatency - userLatency) % interval;
    boolean onBeat = (currentPhase <= one_third || currentPhase >= two_third);  // true if on beat
    // beatNum 0, 1, 2, (3, 4, 5)
    // when there is key there will be jump
    // when there is a hit there will be effect, and register the first key
    int n = beatNum % 6;
    if (n < 3) {    // beatNum % 6 < 3 || beatNum == 5, because some may hit before the first beat
      if (key=='a' || key == 'A') {
        //wand.play();
        wangshu.jump(onBeat);
        if (orders[n] == "Null") {
          orders[n] = "Heal";
          if (onBeat) {
            beatJudges[n] = 2;
          } else {
            beatJudges[n] = 1;
          }
        }
      }
      if (key=='s' || key == 'S') {
        //sword.play();
        zhu.jump(onBeat);
        if (orders[n] == "Null") {
          orders[n] = "Attack";
          if (onBeat) {
            beatJudges[n] = 2;
          } else {
            beatJudges[n] = 1;
          }
        }
      }
      if (key=='d' || key == 'D') {
        //shield.play();
        yue.jump(onBeat);
        if (orders[n] == "Null") {
          orders[n] = "Defend";
          if (onBeat) {
            beatJudges[n] = 2;
          } else {
            beatJudges[n] = 1;
          }
        }
      }
    }
  }

  // physical input, same as keyboard
  void myPort(String input) {
    int currentPhase = (millis() - latency - videoLatency - userLatency) % interval;
    boolean onBeat = (currentPhase <= one_third || currentPhase >= two_third);  // true if on beat
    // beatNum 0, 1, 2, (3, 4, 5)
    // when there is key there will be jump
    // when there is a hit there will be effect, and register the first key
    int n = beatNum % 6;
    int index = n;
    if (n == 5) index = 0;
    if (input == "staff") {
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
    if (input == "swipe") {
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
    if (input == "defend") {
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
      println("Additional Latency: ", videoLatency);
    } else if (keyCode == LEFT) {
      videoLatency -= 10;
      println("Additional Latency: ", videoLatency);
    }
  }
}