public class BeatGame {
  // controls
  int bpm;
  int latency;
  int plusLatency = 0;  // use mouse wheel to adjust latency

  int interval;
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
    two_third = interval *2/3;
    phase = 0;
    beatNum = 0;
    beatIn = true;

    visual = new Visual();
    music = new SoundFile(test_game5.this, "music/funny_slow_mono.mp3");

    yue = new Defender(469-100, 564, 165*0.7, 244*0.7, 3);
    zhu = new Warrior(301-50, 564, 171*0.7, 244*0.7, 3);
    wangshu = new Mage(137, 564, 198*0.7, 244*0.7, 3);

    mon = new Monster(765, 490, 425*0.7, 394*0.7, 10);

    music.loop();

    latency = millis() + 300;
  }

  // append latency when needed
  void adjustLatency (int e) {
    plusLatency += e;
    latency += e;
    println(plusLatency);
  }

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
      if (phase < two_third) {
        beatIn = true;
        beatNum += 1;
      }
    }
  }
}