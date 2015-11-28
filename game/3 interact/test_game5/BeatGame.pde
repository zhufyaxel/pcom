public class BeatGame {
  // controls
  int bpm;
  int latency;
  int plusLatency = 0;  // use mouse wheel to adjust latency

  int interval;
  int one_third;
  int two_third;
  int phase;
  int beatNum;  // doom = 0; cha = 1; cha = 2;
  boolean beatIn;  // doom {beatIn (2/3), beatOff (1/3)}, cha {beatIn, beatOff}, cha {beatIn, beatOff}

  // visual part
  Visual visual;

  // Characters
  Defender yue;
  Warrior zhu;
  Mage wangshu;

  // Monsters
  Monster mon;

  // music part
  SoundFile music;


  BeatGame () {
    // global settings
    imageMode(CENTER);

    bpm = 150;    // 180 with funny_mono
    interval = round(60000.0/bpm); // milliseconds, 60 * 1000 / bpm 
    one_third = interval *1/3;
    two_third = interval *2/3;
    phase = 0;
    beatNum = 0;
    beatIn = true;

    visual = new Visual();
    music = new SoundFile(test_game5.this, "music/funny_slow_mono.mp3");

    yue = new Defender(469, 564, 165, 244, 3);
    zhu = new Warrior(301, 564, 171, 244, 3);
    wangshu = new Mage(137, 564, 198, 244, 3);

    mon = new Monster(765, 490, 425, 394, 10);

    music.loop();

    latency = millis() + 300;
  }

  // main steps in draw()
  void execute() {
    background(0);
    beatCycle();
    visual.show(beatNum, beatIn);
    yue.display(beatNum);
    zhu.display(beatNum);
    wangshu.display(beatNum);
    mon.display(beatNum);
  }

  //synchronized with music, control all visuals and characters
  void beatCycle() {
    int currentTime = millis() - latency;  //correction
    phase = currentTime % interval;

    if (beatIn) {
      if (phase >= two_third) {
        beatIn = false;
      }
    } else {
      if (phase < one_third) {
        beatIn = true;
        beatNum += 1;
        println(";");
      }
    }
  }

  // keyEvent, a - attack, s = staff, d - shield
  // Up - increase latency; Down - decrease latency
  void keyEvent() {
    if (key != CODED) {
      if (phase <= one_third || phase >= two_third) {
        if (key == 'a' || key == 'A') {
          background(255, 0, 0);
          print("A");
        }
        if (key == 's' || key == 'S') {
          background(0, 255, 0);
          print("S");
        }
        if (key == 'd' || key == 'D') {
          background(0, 0, 255);
          print("D");
        }
      }
    }
    else {  // if key == coded
      if (keyCode == UP) {
        game.adjustLatency(10);
      } else if (keyCode == DOWN) {
        game.adjustLatency(-10);
      }
    }
  }
  
  // append latency when needed with arrows Up & Down
  void adjustLatency (int e) {
    plusLatency += e;
    latency += e;
    println("Additional Latency: ", plusLatency);
  }
}