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
  int beatNum;  // boom = 0; cha = 1; cha = 2;
  boolean beatIn;  // boom {beatIn (2/3), beatOff (1/3)}, cha {beatIn, beatOff}, cha {beatIn, beatOff}

  // input controls and vals (v2, multiple_key3)
  String[] orders;
  int[] beatJudges;

  // visual and sound
  Visual visual;
  SoundFile music;

  // Characters and monsters
  Defender yue;
  Warrior zhu;
  Mage wangshu;
  Monster mon;

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
      //keys[i] = false;
      orders[i] = "Null";
      beatJudges[i] = 0;
    }
    
    // visual and music
    visual = new Visual();
    music = new SoundFile(test_game5_1.this, "music/funny_slow_mono.mp3");

    // characters and monsters
    yue = new Defender(469, 564, 165, 244, 3);
    zhu = new Warrior(301, 564, 171, 244, 3);
    wangshu = new Mage(137, 564, 198, 244, 3);
    mon = new Monster(765, 490, 425, 394, 10);

    // put music here to get accuracy
    music.loop();
    latency = millis();
    videoLatency = 300;
    userLatency = 128;
  }

  // main steps in draw()
  void execute() {
    background(0);
    beatCycle();
    
    visual.show(beatNum, beatIn);
    
    yue.display(beatNum);
    yue.move();
    zhu.display(beatNum);
    zhu.move();
    wangshu.display(beatNum);
    wangshu.move();
    
    mon.display(beatNum);
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
      if (phase < one_third) {
        beatIn = true;
        beatNum += 1;
        
        action();
      }
    }
  }

  void action() {
    int n = beatNum % 6;
    if (n == 3) {
      int sum = beatJudges[0] + beatJudges[1] + beatJudges[2];
      if (orders[0] == "Attack" ) {
        println("Attack", sum);
      }
      if (orders[0] == "Heal" ) {
        println("Heal", sum);
      }
      if (orders[0] == "Defend" ) {
        println("Defend", sum);
      }
    }
    if (n == 4) {
      for (int i = 0; i < 3; i++) {
        orders[i] = "Null";
        beatJudges[i] = 0;
      }
    }
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
        wangshu.jump();
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
        zhu.jump();
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
        yue.jump();
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

  // append latency when needed with arrows Up & Down
  void adjustLatency () {
    if (keyCode == UP) {
      videoLatency += 10;
      latency += 10;
      println("Additional Latency: ", videoLatency);  
    } else if (keyCode == DOWN) {
      videoLatency -= 10;
      latency -= 10;
      println("Additional Latency: ", videoLatency);  
    }
  }
}