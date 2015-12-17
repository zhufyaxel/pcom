public class BeatGame {
  // stage related
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
  BeatMachine bm;

  // input controls and vals (v2, multiple_key3)
  String[] orders;
  int[] beatJudges;
  int power;
  String input;  //serial input or key input

  // monster's orders
  String monsOrder;
  int beatClear;    // time when clear up the monster
  int monsInterval1, monsInterval2;  // gap between a new monster respawn

  // visual
  Visual visual;
  
  // sound
  Minim minim;
  AudioPlayer music;
  AudioPlayer magic, swipe, shield;
  Note dol, mi, sol;
  Note dol_low, mi_low, sol_low;

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

    // visual
    visual = new Visual();
    
    // sound (Minim!!)
    minim = new Minim(BoomChaCha.this);
    music = minim.loadFile("music/funny_170.mp3", 512);
    magic = minim.loadFile("music/magic.mp3", 512);
    swipe = minim.loadFile("music/swipe.mp3", 512);
    shield = minim.loadFile("music/shield.mp3", 512);
    
    dol = new Note(minim, "music/dol.mp3");
    mi = new Note(minim, "music/mi.mp3");
    sol = new Note(minim, "music/sol.mp3");
    dol_low = new Note(minim, "music/dol_low.mp3");
    mi_low = new Note(minim, "music/mi_low.mp3");
    sol_low = new Note(minim, "music/sol_low.mp3");
    
    // global vals
    bpm = 170;    // 180 with funny
    bm = new BeatMachine(bpm);

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
    monsInterval2 = 14;    // fight mode

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
    
    // characters and monsters
    yue = new Defender(bm.interval(), xYue, yYue, wYue, hYue, bPlayer);
    zhu = new Warrior(bm.interval(), xZhu, yZhu, wZhu, hZhu, bPlayer);
    shu = new Mage(bm.interval(), xShu, yShu, wShu, hShu, bPlayer);
    mon = new ArrayList<Monster>();
    mon.add(new Monster(bm.interval(), xMon, yMon, wMon, hMon, bMon));
    
    music.setLoopPoints(0, 120*bm.interval());  //if 120 beats
    music.loop();
    int startTime = millis() - music.position();
    
    bm.setStartTime(startTime);
  }

  // main steps in draw()
  void execute() {
    background(0);
    bm.step();
    if (bm.flipping()) {
      onBeat();
    }

    visual.show(bm.beatNum(), bm.phase(), bm.interval());

    switch(stage) {
    case "practice":
      if (key == '2') {
        stage = "fight";
        score = 0;
        beatFight = bm.beatNum();
        break;
      }

      if (!zhu.isAlive()) {
        stage = "defeated";
        break;
      }

      if (mon.size() > 0) {
        mon.get(0).lifeCycle(bm.beatNum(), bm.phase());

        if (!mon.get(0).isAlive()) {
          // ********** score here somehow ************//
          score ++;
          mon.remove(0);
          beatClear = bm.beatNum();
        }
      }
      // respawn the monster
      // try to avoid respawn on beat
      if (mon.size() == 0) {
        if ((bm.beatNum() - beatClear) == monsInterval1) {
          mon.add(new Monster(bm.interval(), xMon, yMon, wMon, hMon, bMon));
        }
      }

      shu.lifeCycle(bm.beatNum(), bm.phase());
      zhu.lifeCycle(bm.beatNum(), bm.phase());
      yue.lifeCycle(bm.beatNum(), bm.phase());

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
        mon.get(0).lifeCycle(bm.beatNum(), bm.phase());

        if (!mon.get(0).isAlive()) {
          // ********** score here somehow ************//
          mon.clear();
          beatClear = bm.beatNum();
          score ++;
        }
      }
      // respawn the monster
      // try to avoid respawn on beat
      if (mon.size() == 0) {
        if ((bm.beatNum() - beatClear) == monsInterval2) {
          mon.add(new Monster(bm.interval(), xMon, yMon, wMon, hMon, bMon));
        }
      }

      shu.lifeCycle(bm.beatNum(), bm.phase());
      zhu.lifeCycle(bm.beatNum(), bm.phase());
      yue.lifeCycle(bm.beatNum(), bm.phase());

      textSize(28);
      fill(0);

      beatsSurvive = bm.beatNum() - beatFight;
      text("Beats survived: "+ beatsSurvive, 180, 720);

      text("Killed: " + score, 680, 720);

      break;

    case "defeated":
      if (mon.size() > 0) {
        mon.get(0).lifeCycle(bm.beatNum(), bm.phase());
      }

      showOptions();    // heal = practice mode, attack = fight mode

      text("Beats survived: "+ beatsSurvive, 180, 720);
      text("Killed: " + score, 680, 720);

      if (orders[0] == "Heal") {
        yue = new Defender(bm.interval(), xYue, yYue, wYue, hYue, bPlayer);
        zhu = new Warrior(bm.interval(), xZhu, yZhu, wZhu, hZhu, bPlayer);
        shu = new Mage(bm.interval(), xShu, yShu, wShu, hShu, bPlayer);

        stage = "practice";
        break;
      }
      if (orders[0] == "Attack") {
        yue = new Defender(bm.interval(), xYue, yYue, wYue, hYue, bPlayer);
        zhu = new Warrior(bm.interval(), xZhu, yZhu, wZhu, hZhu, bPlayer);
        shu = new Mage(bm.interval(), xShu, yShu, wShu, hShu, bPlayer);

        score = 0;
        beatFight = bm.beatNum();

        stage = "fight";
        break;
      }

      break;
    }
  }

  //compute some music characteristics that control all visuals and characters

  // call only once when status flipping
  void onBeat() {
    int n = bm.n();

    // players' cycle
    if (stage != "defeated") {
      if (n == 3) {
        power = beatJudges[0] + beatJudges[1] + beatJudges[2];
        //power = 6;
        if (orders[0] == "Attack" ) {
          //zhu.jump(true);
          swipe.rewind();
          swipe.cue(50);
          swipe.play();
          zhu.setState("attack");
          zhu.removeArrow();
          playerAttack(power);
          println("Attack", power);
        }
        if (orders[0] == "Heal" ) {
          magic.rewind();
          magic.play();
          shu.setState("heal");
          shu.removeArrow();
          println("Heal", power);
        }
        if (orders[0] == "Defend" ) {
          yue.setState("defend");
          yue.removeArrow();
          println("Defend", power);
          //playerDefend(power);  // see monsterattack
        }
      }
      if (n == 4) {
        for (int i = 0; i < 3; i++) {
          orders[i] = "Null";
          beatJudges[i] = 0;
        }
      }

      if (n == 5 && shu.currentState() == "heal") {
        playerHeal(power);
      }
    }

    // monsters' cycle: random decision to attack, charge up and execute the same time as players
    // make decision at beatNum 2, show intension at beat 345, charging at next beat 012, attack at next beat 345.
    if (stage == "fight" && mon.size() > 0 && mon.get(0).isAlive()) {    //beatNum > 24 && mon.get(0).alive
      if (n == 2) {
        if (monsOrder == "stay" && mon.get(0).currentState() == "stay") {
          int mood = int(random(0, 1));
          if (mood == 0) {
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

  void playerAttack(int power) {
    //zhu.attack(int phase, int interval);
    // ******** when player is alive then do attack ********
    // so they really need to share life, or just pretent to do so
    if (mon.size() > 0) {
      mon.get(0).blood -= power;
    }
  }

  void monsterAttack() {
    if (orders[0] == "Defend") {
      shield.rewind();
      shield.cue(50);
      shield.play();
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

  void playerHeal(int power) {
    if (power == 6) {
      if (zhu.blood < 2 * zhu.maxBlood) {
        zhu.blood += 3;
        yue.blood += 3;
        shu.blood += 3;
      }
    } else if (power > 2) {
      if (zhu.blood < 2* zhu.maxBlood) {
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
     myKeyInput();
     takeDamage();
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
    println(bm.currentTime());
    
    inputValues();
  }

  void myPortInput(String _input) {
    input = _input;
    inputValues();
  }

  void inputValues() {
    int index = ((bm.currentTime() + bm.interval()/2) / bm.interval()) % 6;  //align to center

    boolean onCycle = (index < 3);
    boolean onBeat = (bm.phase() <= bm.interval() *1/3 || bm.phase() >= bm.interval() *2/3);  // true if on beat
    //boolean onBeat = true;
    // beatNum 0, 1, 2, (3, 4, 5)
    // when there is key there will be jump
    // when there is a hit there will be effect, and register the first key

    if (input == "wand") {
      input = "";
      shu.jump(onCycle && onBeat);
      if (onCycle) {    // beatNum % 6 < 3 || beatNum == 5, because some may hit before the first beat
        if (onBeat) {
          dol.play();
        } else {
          dol_low.play();
        }
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
          println(index, orders[index], onBeat);
        }
      }
    }
    if (input == "swipe") {
      input = "";
      zhu.jump(onCycle && onBeat);
      if (onCycle) {    // beatNum % 6 < 3 || beatNum == 5, because some may hit before the first beat
        if (onBeat) {
          sol.play();
        } else {
          sol_low.play();
        } 
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
          println(index, orders[index], onBeat);
        }
      }
    }
    if (input == "defend") {
      input = "";
      yue.jump(onCycle && onBeat);
      if (onCycle) {    // beatNum % 6 < 3 || beatNum == 5, because some may hit before the first beat
        if (onBeat) {
          mi.play();
        } else {
          mi_low.play();
        } 
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
          println(index, orders[index], onBeat);
        }
      }
    }
  }

  // for practice purpose, slowly kill yourself
  void takeDamage() {
    if (key == '-') {
      println("Hey!!");
      zhu.changeBlood(-2);
      shu.changeBlood(-2);
      yue.changeBlood(-2);
    }
  }

}




public class Visual {
  PImage imgBkg;
  PImage imgPlanet;
  PImage imgEyes;
  PImage[] imgGrass;

  Visual() {
    imgBkg = loadImage("images/background/background.png");
    imgPlanet = loadImage("images/background/blinking planet.png");
    imgEyes = loadImage("images/background/blinking eye.png");
    imgGrass = new PImage[3];
    for (int i = 0; i < imgGrass.length; i++) {
      imgGrass[i] = loadImage("images/background/grass" + i + ".png");
    }
  }

  void show(int beatNum, int phase, int interval) {    
    // planet, quick fade in and slow fade out
    if (phase > 11*interval/12 && beatNum % 6 == 5) {
      tint(255, 126);
      image(imgPlanet, width/2, height/2);
      noTint();
    }
    if (beatNum%6 == 0 || beatNum%6 == 1|| (beatNum%6 == 2 && phase <= interval * 2/3)) {
      image(imgPlanet, width/2, height/2);
    } 
    if ( (beatNum%6 == 2 && phase > interval * 2/3)) {
      tint(255, 126);
      image(imgPlanet, width/2, height/2);
      noTint();
    }

    // trees
    image(imgBkg, width/2, height/2); 

    // eyes
    if (beatNum % 6 <= 1 ) {
      image(imgEyes, width/2, height/2);
    } else if (beatNum % 6 == 2) {
      tint(255, 170);
      image(imgEyes, width/2, height/2);
      noTint();
    } else if (beatNum % 6 == 5) {
      if (phase > interval * 2/3) {
        tint(255, 127);
        image(imgEyes, width/2, height/2);
        noTint();
      }
    }

    // grass
    if (phase <= interval * 2/3) {
      if (beatNum %3 == 0) {
        image(imgGrass[0], width/2, height/2);
      } else {
        image(imgGrass[2], width/2, height/2);
      }
    } else {
      image(imgGrass[1], width/2, height/2);
    }
  }
}