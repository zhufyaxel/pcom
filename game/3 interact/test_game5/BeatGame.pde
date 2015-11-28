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
  int beatNum;  // doom = 0; cha = 1; cha = 2;
  boolean beatIn;  // doom {beatIn (2/3), beatOff (1/3)}, cha {beatIn, beatOff}, cha {beatIn, beatOff}

  // input controls and vals
  boolean[] keys;
  boolean[] vals;

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
    keys = new boolean[3];
    vals = new boolean[3];
    for (int i = 0; i < 3; i++) {
      keys[i] = false;
      vals[i] = false;
    }
    
    // visual and music
    visual = new Visual();
    music = new SoundFile(test_game5.this, "music/funny_slow_mono.mp3");

    // characters and monsters
    yue = new Defender(469, 564, 165, 244, 3);
    zhu = new Warrior(301, 564, 171, 244, 3);
    wangshu = new Mage(137, 564, 198, 244, 3);
    mon = new Monster(765, 490, 425, 394, 10);

    // put music here to get accuracy
    music.loop();
    videoLatency = 300;
    userLatency = 128;
    latency = millis();
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
        //showResult();
      }
    }
  }

  // showResult
  void showResult() {
    if (vals[0]) {  
      print("1");
    } else {
      print("0");
    }

    if (vals[1]) {  
      print("1");
    } else {
      print("0");
    }

    if (vals[2]) {  
      print("1");
    } else {
      print("0");
    }

    vals[0] = false;
    vals[1] = false;
    vals[2] = false;

    println(";");
  }

  // custom keyPressed event
  // a - mage, s - warrior, d - defendor
  // Up - increase latency; Down - decrease latency
  void myKeyPressed() {
    int currentPhase = (millis() - latency - videoLatency - userLatency) % interval;
    if (key != CODED) {  // ASD controls characters
      if (currentPhase <= one_third || currentPhase >= two_third) {  //currentPhase is more instinct than phase
        if (key=='a' || key == 'A') {
          keys[0] = true;
          wangshu.jump();
          if (!vals[0]) {
            vals[0] = true;
          }
        }
        if (key == 's' || key == 'S') {
          keys[1] = true;
          zhu.jump();
          if (!vals[1]) {
            vals[1] = true;
          }
        }
        if (key == 'd' || key == 'D') {
          keys[2] = true;
          yue.jump();
          if (!vals[2]) {
            vals[2] = true;
          }
        }
      }
      
    } 
    // if key == coded, UP and DOWN adjust additional latency
    else {
      if (keyCode == UP) {
        game.adjustLatency(10);
      } else if (keyCode == DOWN) {
        game.adjustLatency(-10);
      }
    }
  }

  void myKeyReleased() {
    if (key=='a') {
      keys[0] = false;
    }
    if (key=='s') {
      keys[1] = false;
    }
    if (key=='d') {
      keys[2] = false;
    }
  }

  // append latency when needed with arrows Up & Down
  void adjustLatency (int e) {
    videoLatency += e;
    latency += e;
    println("Additional Latency: ", videoLatency);
  }
}