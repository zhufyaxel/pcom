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

  // monster's orders
  String monsOrder;

  // visual and sound
  Visual visual;
  SoundFile music;
  SoundFile sword;
  
  SoundFile dol;
  SoundFile me;
  SoundFile sol;
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

    // visual and music
    visual = new Visual();
    music = new SoundFile(test_game5_4.this, "music/funny_slow_drum_mono.mp3");
    sword = new SoundFile(test_game5_4.this, "music/sword_strike.mp3");
    dol = new SoundFile(test_game5_4.this, "music/dol.mp3");
    me = new SoundFile(test_game5_4.this, "music/me.mp3");
    sol = new SoundFile(test_game5_4.this, "music/sol.mp3");
    dol.amp(0.5);
    me.amp(0.5);
    sol.amp(0.5);
    
    // characters and monsters
    yue = new Defender(466, 489, 241, 388, 3);
    zhu = new Warrior(285, 489, 226, 388, 3);
    wangshu = new Mage(139, 489, 225, 388, 3);
    mon = new ArrayList<Monster>();
    mon.add(new Monster(760, 450, 436, 465, 12));

    // put music here to get accuracy
    music.loop();
    latency = millis();
    videoLatency = 390;  //300 with original
    //userLatency = 128;  //keyboard
    userLatency = 90;  // serial, special thanks for Zhi Gao
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
        
        wangshu.lifeCycle(beatNum);
        zhu.lifeCycle(beatNum);
        yue.lifeCycle(beatNum);
    
        mon.get(0).lifeCycle(beatNum);
    
        if (!mon.get(0).alive) {
          // ********** score here somehow ************//
          mon.clear();
          mon.add(new Monster(760, 450, 436, 465, 12));
        }
        
        break;
      
      case "fight":
        if (!zhu.alive) {
          stage = "defeated";
          break;
        }
        
        wangshu.lifeCycle(beatNum);
        zhu.lifeCycle(beatNum);
        yue.lifeCycle(beatNum);
    
        mon.get(0).lifeCycle(beatNum);
        
        if (mon.get(0).dying && !mon.get(0).scored) {
          score ++;
          mon.get(0).scored = true;
        }
        
        if (!mon.get(0).alive) {
          // ********** score here somehow ************//
          mon.clear();
          mon.add(new Monster(760, 450, 436, 465, 12));
        }
        
        break;
        
      case "defeated":
        mon.get(0).lifeCycle(beatNum);
        
        showOptions();
        
        if (orders[0] == "Heal") {
          yue = new Defender(466, 489, 241, 388, 3);
          zhu = new Warrior(285, 489, 226, 388, 3);
          wangshu = new Mage(139, 489, 225, 388, 3);
          
          stage = "practice";
          break;
        }
        if (orders[0] == "Attack") {
          yue = new Defender(466, 489, 241, 388, 3);
          zhu = new Warrior(285, 489, 226, 388, 3);
          wangshu = new Mage(139, 489, 225, 388, 3);
          
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
    if (n == 3) {
      //sum = beatJudges[0] + beatJudges[1] + beatJudges[2];
      sum = 6;
      if (orders[0] == "Attack" ) {
        println("Attack", sum);
        playerAttack(sum);
      }
      if (orders[0] == "Heal" ) {
        println("Heal", sum);
        playerHeal(sum);
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
    if (stage == "fight" && mon.get(0).alive) {    //beatNum > 24 && mon.get(0).alive
      if (n == 2) {
        if (monsOrder == "stay" && mon.get(0).state == "stay") {
          int mood = int(random(0, 2));
          if (mood == 1) {
            monsOrder = "attack";
          } else {
            monsOrder = "stay";
          }
        }
      }
      if (n == 3) {
        if (monsOrder == "attack" && mon.get(0).state == "stay") {
          mon.get(0).state = "prepare";
          //sword.play();
        } 
        if (mon.get(0).state == "attack" || mon.get(0).state == "charge") {
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
    mon.get(0).blood -= sum;
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
        dol.play();
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
        sol.play();
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
        me.play();
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
    if (input == "wand") {
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
    if (input == "swipe") {
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
    if (input == "defend") {
      me.play();
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