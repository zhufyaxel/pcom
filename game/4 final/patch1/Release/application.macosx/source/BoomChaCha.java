import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 
import ddf.minim.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class BoomChaCha extends PApplet {

////BoomChaCha!




boolean portAvailable = false;  // physical or standalone
Serial myPort;  // Create object from Serial class
String val;      // Data received from the serial port
String portName = "/dev/cu.usbserial-AH01KCPQ";

String stage;  // "main" -> "tutorial" -> "main"
// "main" -> "fight" -> "main"
BGM bgm;
ArrayList<Tutorials> tutorials;
ArrayList<BeatGame> game;

PImage main;
PFont aw;

public void setup() {
  
  imageMode(CENTER);
  rectMode(CENTER);
  stage = "main";
  tutorials = new ArrayList<Tutorials>();
  game = new ArrayList<BeatGame>();
  bgm = new BGM("music/funny_drum_min.mp3", 150, 120);
  
  main = loadImage("images/main/tutorial_menu.png");
  aw = createFont("fonts/Comic Sans MS Bold.ttf", 32);
  textAlign(CENTER);
  textFont(aw);
  if (portAvailable) {
    myPort = new Serial(this, portName, 9600);                          
  }
}

public void draw() {
  if (portAvailable) {
    if (bgm.beatsPlayed < 6) {
     myPort.write('s');
    } else if (bgm.beatsPlayed < 18) {
     myPort.write('d');
     myPort.write('f');
     myPort.write('g');  
    }
  }
  
  bgm.step();  
  
  switch(stage) {
  case "main":
    image(main, width/2, height/2);
    break;
  case "tutorial":
    if (tutorials.get(0).pass) {
      tutorials.clear();
      stage = "main";
      break;
    } else {
      tutorials.get(0).execute();
      break;
    }
  case "fight":
    if (game.get(0).end) {
      game.clear();
      stage = "main";
      break;
    } else {
      game.get(0).execute();
      break;
    }
  }
}

public void keyPressed() {
  switch(stage) {
  case "main":
    if (key == 'a' || key == 'A') {
      tutorials.add(new Tutorials(bgm));
      stage = "tutorial";
      break;
    }
    if (key == 's'|| key == 'S') {
      game.add(new BeatGame(bgm));
      stage = "fight";
      break;
    }
    // main.myKeyInput();
    break;
  case "tutorial":
    tutorials.get(0).myKeyInput();
    break;
  case "fight":
    game.get(0).myKeyInput();
    break;
  }
}

public void serialEvent(Serial myPort) { 

 if ( myPort.available() > 0) {  // If data is available,
   val = myPort.readStringUntil('\n');
   if (val != null && val.length() > 2) {

     String input = "";

     if (val.charAt(0) == 'd') {
       if (val.charAt(2) == 'd') {
         input = "defend";
         println("defend");
       }
     }

     if (val.charAt(0) == 's') {
       if (val.charAt(2) == 's') {
         //println("swipe");
         input = "swipe";
         println("swipe");
       }
     }

     if (val.charAt(0) == 'w') {
       if (val.charAt(2) == 'w') {
         input = "wand";
         println("wand");
       }
     }

     switch(stage) {
     case "main":
       if (input == "wand") {
         tutorials.add(new Tutorials(bgm));
         stage = "tutorial";
         break;
       }
       if (input == "swipe") {
         game.add(new BeatGame(bgm));
         stage = "fight";
         break;
       }
       // main.myKeyInput();
       break;
     case "tutorial":
       tutorials.get(0).myPortInput(input);
       break;
     case "fight":
       game.get(0).myPortInput(input);
       break;
     }
   }
 }
} 
class BGM {
  Minim minim;
  AudioPlayer music;

  // parameters that can be called
  int interval;        // the length of a beat in milliseconds
  int timePlayed;      // time played from music starts in milliseconds, elder currentTime
  int phase;           // the position inside a beat in millliseconds
  int beatsPlayed;     // beats played beatNum
  int n;               // 0-Boom, 1-Cha, 2-Cha, 3, 4, 5
  boolean newBeatIn;   // when a new beat appears  elder flippling

  // inner parameters for calculation
  int musicBeats;   // length of music in beats
  int musicLength;
  int lastPosition;
  int looped;
  
  BGM(String path, int bpm, int _musicBeats) {
    minim = new Minim(BoomChaCha.this);
    music = minim.loadFile(path, 512);
    
    musicBeats = _musicBeats;
    interval = round(60000.0f/bpm); // milliseconds, 60 * 1000 / bpm
    musicLength = musicBeats * interval;

    music.setLoopPoints(0, musicLength);  //if 120 beats
    music.loop();
    
    lastPosition = 0;
    looped = 0;
    timePlayed = 0;

    phase = 0;
    beatsPlayed = 0;
    n = 0;
    newBeatIn = false;            
  }
  
  public void step() {
    // setting looped times by lastPosition
    if (music.position() < lastPosition) {
      looped += 1;
    }
    lastPosition = music.position();
    
    // getting timePlayed adjusted by looped times
    timePlayed = music.position() + looped * musicLength;
    phase = timePlayed % interval;
    
    // decide whether a new beat is coming, and get new beatsPlayed
    int beatsPlayedNew = timePlayed / interval;
    if (beatsPlayed < beatsPlayedNew) {
      beatsPlayed = beatsPlayedNew;
      newBeatIn = true;
    }
    else {
      newBeatIn = false;
    }
    n = beatsPlayed % 6;
  }
  
  public int interval() {
    return interval;
  }
  
  public int timePlayed() {
    return timePlayed;
  }
  
  public int phase() {
    return phase;
  }
  
  public int beatsPlayed() {
    return beatsPlayed;
  }
  
  public int n() {
    return n;
  }
  
  public boolean newBeatIn() {
    return newBeatIn;
  }
}
public class BeatGame {
  // BGM
  BGM bgm;

  // stage related
  String stage;   // stage 1: "practice" free trial
  // stage 2: "fight" play and monster fight, and score at the same time
  // stage 3: "defeated" player dead -> fight again: back to stage 2
  //                                 -> practice again: back to stage 1
  //                                 -> menu: back to menu
  // stage 4: "win" player win       -> fight again: back to stage 2
  //                                 -> practice again: back to stage 1
  //                                 -> menu: back to menu

  int score;
  int beatFight;
  int beatDefeated;
  int beatWin;
  int beatsSurvive;

  PImage defeated = loadImage("images/background/defeated.png");
  PImage win = loadImage("images/background/win.png");
  PImage options1 = loadImage("images/background/options1.png");
  PImage options2 = loadImage("images/background/options2.png");

  // input controls and vals (v2, multiple_key3)
  String[] orders;
  int[] beatJudges;
  int power;

  String input;  //serial input or key input
  boolean warriorCalled;
  boolean mageCalled;
  boolean defenderCalled;

  // monster's orders
  String monsOrder;
  int beatClear;    // time when clear up the monster
  int monsInterval1, monsInterval2;  // gap between a new monster respawn

  // visual
  Visual visual;

  // sound
  Minim minim;
  AudioPlayer magic, swipe, defence;
  AudioPlayer bad;
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

  boolean end;

  BeatGame (BGM _bgm) {
    // bgm
    bgm = _bgm;

    // global settings
    imageMode(CENTER);

    // visual
    visual = new Visual();

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

    //global vals
    stage = "practice";
    score = 0;
    beatFight = 0;
    beatDefeated = 0;
    beatWin = 0;
    beatsSurvive = 0;

    // input
    orders = new String[3];
    beatJudges = new int[3];
    for (int i = 0; i < 3; i++) {
      orders[i] = "Null";
      beatJudges[i] = 0;
    }

    warriorCalled = false;
    mageCalled = false;
    defenderCalled = false;

    // monster's order
    monsOrder = "stay";    // stay, attack
    monsInterval1 = 8;     // practice mode
    monsInterval2 = 14;    // fight mode

    // creatures' parameters
    xYue = 466; 
    yYue = 489; 
    wYue = 241*0.95f; 
    hYue = 388*0.95f;
    xZhu = 285; 
    yZhu = 489; 
    wZhu = 226*0.95f; 
    hZhu = 388*0.95f;
    xShu = 139; 
    yShu = 489; 
    wShu = 225*0.95f; 
    hShu = 388*0.95f;
    bPlayer = 4;

    xMon = 760; 
    yMon = 450; 
    wMon = 438*0.95f; 
    hMon = 465*0.95f;
    bMon = 10;    // 10 for easier

    // characters and monsters
    yue = new Defender(bgm.interval(), xYue, yYue, wYue, hYue, bPlayer);
    zhu = new Warrior(bgm.interval(), xZhu, yZhu, wZhu, hZhu, bPlayer);
    shu = new Mage(bgm.interval(), xShu, yShu, wShu, hShu, bPlayer);
    mon = new ArrayList<Monster>();
    mon.add(new Monster(bgm.interval(), xMon, yMon, wMon, hMon, bMon));

    end = false;
  }

  // main steps in draw()
  public void execute() {
    background(0);
    //bgm.step();
    if (bgm.newBeatIn()) {
      onBeat();
    }

    visual.show(bgm.beatsPlayed(), bgm.phase(), bgm.interval());

    // force quit to menu = '0'
    if (key == '0') {
      end = true;
    }

    switch(stage) {
    case "practice":
      if (key == '2') {
        stage = "fight";
        score = 0;
        beatFight = bgm.beatsPlayed();
        // replenish the players if alive, else wait until respawn
        if (zhu.isAlive()) {
          shu.replenish();
          zhu.replenish();
          yue.replenish();
        }
        
        // respawn the monster whatever
        if (mon.size() > 0) {
          mon.remove(0);
        }
        mon.add(new Monster(bgm.interval(), xMon, yMon, wMon, hMon, bMon));
        
        break;
      }

      if (!zhu.isAlive()) {
        stage = "defeated";
        break;
      }

      if (mon.size() > 0) {
        mon.get(0).lifeCycle(bgm.beatsPlayed(), bgm.phase());

        if (!mon.get(0).isAlive()) {
          // ********** score here somehow ************//
          score ++;
          mon.remove(0);
          beatClear = bgm.beatsPlayed();
        }
      }
      // respawn the monster
      // try to avoid respawn on beat
      if (mon.size() == 0) {
        if ((bgm.beatsPlayed() - beatClear) >= monsInterval1) {
          mon.add(new Monster(bgm.interval(), xMon, yMon, wMon, hMon, bMon));
        }
      }

      shu.lifeCycle(bgm.beatsPlayed(), bgm.phase());
      zhu.lifeCycle(bgm.beatsPlayed(), bgm.phase());
      yue.lifeCycle(bgm.beatsPlayed(), bgm.phase());

      textSize(28);
      fill(0);
      text("[Practice] Press '2' to enter real fight.", 320, 740);
      text("Killed: " + score, 750, 740);

      break;

    case "fight":
      if (key == '1') {
        stage = "practice";
        break;
      }
      
      beatsSurvive = bgm.beatsPlayed() - beatFight;
      
      if (beatsSurvive >= 500) {
        // longer happiness after success
        beatWin = bgm.beatsPlayed();
        stage = "win";
        break;
      } 
      else if (!zhu.isAlive()) {
        beatDefeated = bgm.beatsPlayed();
        stage = "defeated";
        break;
      }

      if (mon.size() > 0) {
        mon.get(0).lifeCycle(bgm.beatsPlayed(), bgm.phase());

        if (!mon.get(0).isAlive()) {
          // ********** score here somehow ************//
          mon.clear();
          beatClear = bgm.beatsPlayed();
          score ++;
        }
      }
      // respawn the monster
      // try to avoid respawn on beat
      if (mon.size() == 0) {
        if ((bgm.beatsPlayed() - beatClear) >= monsInterval2) {
          mon.add(new Monster(bgm.interval(), xMon, yMon, wMon, hMon, bMon));
        }
      }

      shu.lifeCycle(bgm.beatsPlayed(), bgm.phase());
      zhu.lifeCycle(bgm.beatsPlayed(), bgm.phase());
      yue.lifeCycle(bgm.beatsPlayed(), bgm.phase());

      textSize(28);
      fill(0);

      text("[Fight] Beats survived: "+ beatsSurvive + "/500", 260, 740);

      text("Killed: " + score, 750, 740);

      break;

    case "defeated":
      // show monster only
      if (mon.size() > 0) {
        mon.get(0).lifeCycle(bgm.beatsPlayed(), bgm.phase());
      }
      
      showDefeated();

      text("[Fight] Beats survived: "+ beatsSurvive, 260, 740);
      text("Killed: " + score, 750, 740);

      // show options 3 beats later
      if (bgm.beatsPlayed - beatDefeated >= 3) {
        showOptions1();    // heal = practice mode, attack = fight mode
        if (input == "wand") {
          input = "";  // in case no input for two rounds
          yue = new Defender(bgm.interval(), xYue, yYue, wYue, hYue, bPlayer);
          zhu = new Warrior(bgm.interval(), xZhu, yZhu, wZhu, hZhu, bPlayer);
          shu = new Mage(bgm.interval(), xShu, yShu, wShu, hShu, bPlayer);
  
          score = 0;
          stage = "practice";
          break;
        }
        if (input == "swipe") {
          input = "";  // in case no input for two rounds
          yue = new Defender(bgm.interval(), xYue, yYue, wYue, hYue, bPlayer);
          zhu = new Warrior(bgm.interval(), xZhu, yZhu, wZhu, hZhu, bPlayer);
          shu = new Mage(bgm.interval(), xShu, yShu, wShu, hShu, bPlayer);
  
          score = 0;
          beatFight = bgm.beatsPlayed();
  
          stage = "fight";
          break;
        }
        if (input == "defend") {
          input = "";  // in case no input for two rounds
          end = true;
          break;
        }
      }
      
      break;
      
    case "win":
      // show players only
      shu.lifeCycle(bgm.beatsPlayed(), bgm.phase());
      zhu.lifeCycle(bgm.beatsPlayed(), bgm.phase());
      yue.lifeCycle(bgm.beatsPlayed(), bgm.phase());

      showWin();

      text("[Fight] Beats survived: "+ beatsSurvive, 260, 740);
      text("Killed: " + score, 750, 740);

      // show options 6 beats later
      if (bgm.beatsPlayed - beatWin >= 6) {
        showOptions2();    // heal = practice mode, attack = fight mode
        if (input == "wand") {
          input = "";  // in case no input for two rounds
          yue = new Defender(bgm.interval(), xYue, yYue, wYue, hYue, bPlayer);
          zhu = new Warrior(bgm.interval(), xZhu, yZhu, wZhu, hZhu, bPlayer);
          shu = new Mage(bgm.interval(), xShu, yShu, wShu, hShu, bPlayer);
  
          score = 0;
          stage = "practice";
          break;
        }
        if (input == "swipe") {
          input = "";  // in case no input for two rounds
          yue = new Defender(bgm.interval(), xYue, yYue, wYue, hYue, bPlayer);
          zhu = new Warrior(bgm.interval(), xZhu, yZhu, wZhu, hZhu, bPlayer);
          shu = new Mage(bgm.interval(), xShu, yShu, wShu, hShu, bPlayer);
  
          score = 0;
          beatFight = bgm.beatsPlayed();
  
          stage = "fight";
          break;
        }
        if (input == "defend") {
          input = "";  // in case no input for two rounds
          end = true;
          break;
        }
      }
      
      break;
    }
  }

  //compute some music characteristics that control all visuals and characters

  // call only once when status flipping
  public void onBeat() {
    int n = bgm.n();

    // players' cycle
    if (stage != "defeated") {

      if (n == 3) {
        power = beatJudges[0] + beatJudges[1] + beatJudges[2];
        //power = 6;
        if (orders[0] == "Attack" ) {
          //zhu.jump(true);
          swipe.rewind();
          swipe.cue(100);
          swipe.play();
          zhu.setState("attack");
          playerAttack(power);
          println("Attack", power);
        }
        if (orders[0] == "Heal" ) {
          magic.rewind();
          magic.play();
          shu.setState("heal");
          println("Heal", power);
        }
        if (orders[0] == "Defend" ) {
          yue.setState("defend");
          println("Defend", power);
          //playerDefend(power);  // see monsterattack
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
        if (shu.currentState() == "heal") {
          playerHeal(power);
        }
      }
    }

    // monsters' cycle: random decision to attack, charge up and execute the same time as players
    // make decision at beatNum 2, show intension at beat 345, charging at next beat 012, attack at next beat 345.
    if (stage == "fight" && mon.size() > 0 && mon.get(0).isAlive()) {    //beatNum > 24 && mon.get(0).alive
      if (n == 2) {
        if (monsOrder == "stay" && mon.get(0).currentState() == "stay") {
          int mood = PApplet.parseInt(random(0, 2));
          if (mood == 1) {
            monsOrder = "attack";
          } else {
            monsOrder = "stay";
          }
        }
      }
      if (n == 3) {
        if (monsOrder == "attack" && mon.get(0).currentState() == "stay"  && !mon.get(0).dying) {
          mon.get(0).setState("prepare");
          bad.rewind();
          bad.play();
        } 
        if (!mon.get(0).dying && (mon.get(0).currentState() == "attack" || mon.get(0).currentState() == "charge")) {
          monsterAttack();
          monsOrder = "stay";
        }
      }
    }
  }

  public void playerAttack(int power) {
    //zhu.attack(int phase, int interval);
    // ******** when player is alive then do attack ********
    // so they really need to share life, or just pretent to do so
    if (mon.size() > 0) {
      mon.get(0).blood -= power;
    }
  }

  public void monsterAttack() {
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

  public void playerHeal(int power) {
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

  public void showDefeated() {
    image(defeated, width/2, height/2);
  }

  public void showWin() {
    image(win, width/2, height/2);
  }
  
  public void showOptions1() {
      image(options1, width/2, height/2);
  }
  
  public void showOptions2() {
      image(options2, width/2, height/2);
  }


  public void myKeyPressed() {
    myKeyInput();
    //takeDamage();
    //addBlood();
  }

  // physical input, same as keyboard
  public void myKeyInput() {
    if (key=='a' || key == 'A') {
      input = "wand";
    }
    if (key=='s' || key == 'S') {
      input = "swipe";
    }
    if (key=='d' || key == 'd') {
      input = "defend";
    }
    if (key == '-' || key == '_' ) {
      println("Hey!!");
      zhu.changeBlood(-2);
      shu.changeBlood(-2);
      yue.changeBlood(-2);
    }
    if (key == '+' || key == '=' ) {
      println("Yeah");
      zhu.changeBlood(+2);
      shu.changeBlood(+2);
      yue.changeBlood(+2);
    }
    if (stage == "practice" || stage == "fight") {
      inputValues();
    }
  }

  public void myPortInput(String _input) {
    input = _input;
    if (stage == "practice" || stage == "fight") {
      inputValues();
    }
  }

  public void inputValues() {
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

  //// for practice purpose, slowly kill yourself
  //void takeDamage() {
  //  if (key == '-' || key == '_' ) {
  //    println("Hey!!");
  //    zhu.changeBlood(-2);
  //    shu.changeBlood(-2);
  //    yue.changeBlood(-2);
  //  }
  //}
  
  //// for practice purpose, slowly kill yourself
  //void addBlood() {
  //  if (key == '+' || key == '=' ) {
  //    println("Yeah");
  //    zhu.changeBlood(+2);
  //    shu.changeBlood(+2);
  //    yue.changeBlood(+2);
  //  }
  //}
}




public class Visual {
  PImage imgBkg;
  PImage imgPlanet;
  PImage imgEyes;
  PImage[] imgGrass;
  PImage border;

  Visual() {
    imgBkg = loadImage("images/background/background.png");
    imgPlanet = loadImage("images/background/blinking planet.png");
    imgEyes = loadImage("images/background/blinking eye.png");
    imgGrass = new PImage[3];
    for (int i = 0; i < imgGrass.length; i++) {
      imgGrass[i] = loadImage("images/background/grass" + i + ".png");
    }
    border = loadImage("images/Tutorial_bkg/border.png");
  }

  public void show(int beatNum, int phase, int interval) {    
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

    // border
    switch (beatNum % 6) {
    case 0:
      if (phase <= interval * 2/3) {
        tint(255, 58, 57, 255);
        image(border, width/2, height/2);
        noTint();
      } else {
        int alpha = round(map(phase, interval/2, interval, 255, 30));
        tint(255, 58, 57, alpha);
        image(border, width/2, height/2);
        noTint();
      }
      break;
    case 1: 
    case 2:
      if (phase <= interval * 2/3) {
          tint(255, 101, 100, 255);
          image(border, width/2, height/2);
          noTint();
        } else {
          int alpha = round(map(phase, interval/2, interval, 255, 30));
          tint(255, 101, 100, alpha);
          image(border, width/2, height/2);
          noTint();
        }
        break;
    }



    //// border
    //if (beatNum % 6 < 2 || (beatNum % 6 == 2 && phase <= interval/2)) {
    //  tint(255,58,57,255);
    //  image(border, width/2, height/2);
    //  noTint();
    //}
    //if (beatNum % 6 == 2 && phase > interval / 2) {
    //  int alpha = round(map(phase, interval/2, interval, 255, 128));
    //  tint(255,58,57,alpha);
    //  image(border, width/2, height/2);
    //  noTint();
    //}
  }
}
// Creature > Player > Warrior, Mage and Defender
// Creature > Monster

public class Creature {
  // what should a creature apprear like?
  String state; //stay, attack, prepare, charge
  
  PImage stay[];
  
  PImage attack[];
  PImage defend[];
  PImage heal[];
  
  PImage beAttacked[];
  PImage prepare[];
  PImage charge[];
  
  // they should have blood and max blood
  boolean alive;
  boolean dying;
  int beatDying;
  
  boolean hideBlood;
  int blood, maxBlood;
  PImage[] heart;
  float adjustX, adjustY;    // for blood positioning

  boolean showBoom;
  PImage boom;
  
  boolean showCha;
  PImage cha;

  // they should have existence: position and size
  float x, y, w, h;  
  
  // movement related: position, speed, acceleration
  float y0;
  float v0, vy;
  float acc;
  
  // music related: 
  int interval;
  int phase;
  int beatNum;

  Creature(int _interval, float _x, float _y, float _w, float _h, int _b) {
    state = "stay";
    
    alive = true;
    dying = false;
    beatDying = -1;
    
    hideBlood = false;
    maxBlood = _b;    // full heart displayed
    blood = 2*_b;   // allow for half heart
    adjustX = 0;
    adjustY = 0;
    
    if (maxBlood <=0 ) {
      println("blood should be positive integer");
    }
    
    heart = new PImage[3];
    heart[0] = loadImage("images/heart/heart_hollow.png");
    heart[1] = loadImage("images/heart/heart_half.png");
    heart[2] = loadImage("images/heart/heart_full.png");
    
    showBoom = false;
    boom = loadImage("images/status/Boom.png");
    showBoom = false;
    cha = loadImage("images/status/Cha.png");

    x = _x;
    y = _y;
    w = _w;
    h = _h;
    
    y0 = y;
    v0 = -20;
    vy = 0;
    acc = 2;
    
    interval = _interval; 
  }
  
  public void displayStay() {
    if (alive && !dying) {
      if (beatNum % 3 == 0) {
        image(stay[0], x, y, w, h);
      } else if (beatNum % 3 == 1) {
        image(stay[1], x, y, w, h);
      } else {
        image(stay[2], x, y, w, h);
      }
      
      displayBlood();
    }
  }
  
  public void addBoom() {
    showBoom = true;
  }
  
  public void removeBoom() {
    showBoom = false;
  }
  
  public void addCha() {
    showCha = true;
  }
  
  public void removeCha() {
    showCha = false;
  }
  
  public void displayAttack() {
  }
  
  public void displayDefend() {
  }
  
  public void displayHeal() {
  }
  
  public void displayPrepare() {
  }
  
  public void displayCharge() {
  }

  public void displayBlood() {
    if (!hideBlood) {
      int size = 30;
      float currentX = x - PApplet.parseFloat(maxBlood)/2 * size + size/2 + adjustX;
      float currentY = y - h/2 - size/2 + adjustY;
      for (int i = 0; i < maxBlood; i++) {
        if (blood % 2 == 0) {
          if (i < blood/2) {
            image(heart[2], currentX, currentY, size, size);
          } else {
            image(heart[0], currentX, currentY, size, size);
          }
        } else {
          if (i < blood/2) {
            image(heart[2], currentX, currentY, size, size);
          } else if (i == blood/2) {
            image(heart[1], currentX, currentY, size, size);
          } else {
            image(heart[0], currentX, currentY, size, size);
          }
        }
        currentX += size;
      }
    }
  }
  
  // move with gravity
  public void move() {
    // with initial velocity or on the air it will move
    if (y < y0 || vy != 0) {        
      y = y + vy;
      vy = vy + acc;
    }
    // hit the ground and immediately stop
    if (y >= y0 && vy != 0) {  // y >= y0
      y = y0;
      vy = 0;
    }
  }
  
  // add initial velocity to jump
  public void jump(boolean onBeat) {
    // jump on ground then add some big vel, jump in the air then add small vel
    // jump on beat then high, else jump lower
    float vj;
    if (onBeat) {
      vj = v0;
    } else {
      vj = v0;  // /2
    }
    
    if (y == y0) {
      vy = vy + vj;
    } else if (y < y0) {
      //vy = vy + vj * 0.5;
    }
  }
  
  //display attack, charge up and dying differently for monster and players
  
  // return inner status
  public boolean isAlive() {
    return alive;
  }
  
  public String currentState() {
    return state;
  }
  
  public void setState(String _state) {
    state = _state;
  }
  
  public void hideBlood(boolean hide) {
    hideBlood = hide;
  }
  
  public void changeBlood(int num) {
    blood += num;
    blood = constrain(blood, 0, 2*maxBlood);
  }
  
  public void replenish() {
    blood = 2 * maxBlood;
  }
}
// Monster, Ball, BallsAni

public class Monster extends Creature {  
  boolean scored;
  //BallsAni balls;
  float zoom = 0.95f;

  Monster(int interval, float x, float y, float w, float h, int b) {
    super(interval, x, y, w, h, b);
    scored = false;
    //balls = new BallsAni(zoom, x, y, w, h);
    
    // animation
    stay = new PImage[3];
    prepare = new PImage[3];
    charge = new PImage[3];
    attack = new PImage[1];
    beAttacked = new PImage[2];
    
    stay[0] = loadImage("images/characters/monster/m/m4.png");
    stay[1] = loadImage("images/characters/monster/m/m3.png");
    stay[2] = loadImage("images/characters/monster/m/m2.png");
    
    adjustY = 60;    // adjust displayBlood position

    for (int i = 0; i < prepare.length; i++) {
      prepare[i] = loadImage("images/characters/monster/ma/ma"+ i + ".png");
    }
    for (int i = 0; i < charge.length; i++) {
      charge[i] = loadImage("images/characters/monster/ma/ma"+ (i+3) + ".png");
    }
    
    attack[0] = loadImage("images/characters/monster/ma/ma6.png");
    
    for (int i = 0; i < beAttacked.length; i++) {
      beAttacked[i] = loadImage("images/characters/monster/mba/mba" + (i+2) + ".png");
    }  
  }

  public void lifeCycle(int _beatNum, int _phase) {
    beatNum = _beatNum;
    phase = _phase;
    
    if (blood <=0) {
      if (!dying) {
        dying = true;
        beatDying = beatNum;
      }
    }
    if (dying) {
      displayDying();
    }
    if (alive && !dying) {
      switch(state) {
        case "stay":
          displayStay();
          break;
        case "prepare":
          if (beatNum % 6 == 0) {
            state = "charge";
            displayCharge();
            break;
          } else {
            displayPrepare();
            break;
          }
        case "charge":
          if (beatNum % 6 == 3) {
            state = "attack";
            displayAttack();
            break;
          } else {
            displayCharge();
            break;
          }
        case "attack":
          if (beatNum % 6 == 4) {
            state = "stay";
            displayStay();
            break;
          } else {
            displayAttack();
            break;
          }
      }
    }
  }

  public void displayPrepare() {
    if (beatNum % 6 == 3) {
      image(prepare[0], x, y, w, h);
      //balls.show(0);
      displayBlood();
    } else if (beatNum % 6 == 4) {
      tint(255,128,128);
      image(prepare[1], x, y, w, h);
      noTint();
      //balls.show(1);
      displayBlood();
    } else if (beatNum % 6 == 5) {
      image(prepare[2], x, y, w, h);
      //balls.show(2);
      displayBlood();
    }

  }
  
  public void displayCharge() {
    if (beatNum % 6 == 0) {
      tint(255,90,90);
      image(charge[0], x, y, w, h);
      noTint();
      //balls.show(3);
      displayBlood();
    } else if (beatNum % 6 == 1) {
      //tint(255,90,90);
      image(charge[1], x, y, w, h);
      noTint();
      //balls.show(4);
      displayBlood();
    } else if (beatNum % 6 == 2) {
      tint(255,90,90);
      image(charge[2], x, y, w, h);
      noTint();
      //balls.show(5);
      displayBlood();
    }
  }
  
  public void displayAttack() {
    if (beatNum % 6 == 3) {
      image(attack[0], x, y, w, h);
      displayBlood();
    }
  }
  
  public void displayDying() {
    blood = 0;
    if (blood < 0) {
      blood = 0;
    }
    
    if (beatNum - beatDying == 0) {  //beatNum - beatDying
      translate(x+w/3, y+h/2);
      rotate(PI/6);
      image(stay[0], -w/3, -h/2, w, h); 
      rotate(-PI/6);
       translate(-(x+w/3),-(y+h/2));
    } else if (beatNum - beatDying == 1) {  //beatNum - beatDying       
      translate(x+w/3, y+h/2);
      rotate(PI/2);
      image(stay[0], -w/3, -h/2, w, h);
      rotate(-PI/2);
      translate(-(x+w/3),-(y+h/2));
    } else if (beatNum - beatDying == 3) {
      translate(x+w/3, y+h/2);
      rotate(PI/2);
      image(stay[0], -w/3, -h/2, w, h);
      rotate(-PI/2);
      translate(-(x+w/3),-(y+h/2));
    } else if (beatNum - beatDying == 5) {
      translate(x+w/3, y+h/2);
      rotate(PI/2);
      image(stay[0], -w/3, -h/2, w, h);
      rotate(-PI/2);
      translate(-(x+w/3),-(y+h/2));
    } else if (beatNum - beatDying > 5){
      // dying = false;
      alive = false;
    }
  }
}


class Ball {
  float x, y, zoom, monX, monY, monW, monH;
  int size;
  float tx, ty;  //translated x, y

  Ball(float _zoom, float _monX, float _monY, float _monW, float _monH) {   
    // _x _y is position from topleft corder. translate the position into this canvas according to the size and position of monster
    x = 0;
    y = 0;
    zoom = _zoom;
    size = 0;
    monX = _monX;
    monY = _monY;
    monW = _monW;
    monH = _monH;
    mapPosition();
  }
  
  Ball(float _x, float _y, float _zoom, int _size, float _monX, float _monY, float _monW, float _monH) {   
    // _x _y is position from topleft corder. translate the position into this canvas according to the size and position of monster
    x = _x;
    y = _y;
    zoom = _zoom;
    size = _size;
    monX = _monX;
    monY = _monY;
    monW = _monW;
    monH = _monH;
    mapPosition();
  }
  
  public void show() {
    noStroke();
    fill(243,71,36);
    ellipse(tx, ty, size, size);
  }
  
  public void setSize(int _size) {
    if (size != _size) {
      size = _size;
    }
  }
  
  public void setPosition(float _x, float _y) {
    if (x != _x && y != _y) {
      x = _x;
      y = _y;
      mapPosition();
    }
  }
  
  public void mapPosition() {
    tx = (monX - monW/2) + x*zoom;
    ty = (monY - monH/2) + y*zoom;
  }
}



class BallsAni {
  Ball b0, b1, b2, b3;
  Ball b00, b01, b02, b10, b11, b12, b20, b21, b22, b30, b31, b32;    
  float zoom, monX, monY, monW, monH;
  
  BallsAni(float _zoom, float _monX, float _monY, float _monW, float _monH) {
    zoom = _zoom;
    monX = _monX;
    monY = _monY;
    monW = _monW;
    monH = _monH;
     
    // balls  
    b0 = new Ball(zoom, monX, monY, monW, monH);
    b0 = new Ball(zoom, monX, monY, monW, monH);
    b0 = new Ball(zoom, monX, monY, monW, monH);
    b0 = new Ball(zoom, monX, monY, monW, monH);
    
    b00 = new Ball(zoom, monX, monY, monW, monH);
    b01 = new Ball(zoom, monX, monY, monW, monH);
    b02 = new Ball(zoom, monX, monY, monW, monH);
    b10 = new Ball(zoom, monX, monY, monW, monH);
    b11 = new Ball(zoom, monX, monY, monW, monH);
    b12 = new Ball(zoom, monX, monY, monW, monH);
    b20 = new Ball(zoom, monX, monY, monW, monH);
    b21 = new Ball(zoom, monX, monY, monW, monH);
    b22 = new Ball(zoom, monX, monY, monW, monH);
  }
  
  public void show(int stage) {
    switch(stage) {
      case 0: // prepare 0
        b0.setPosition(99, 183);
        b0.setSize(5);
        b0.show();
        break;
      case 1: // prepare 1
        b0.setPosition(101, 199);
        b0.setSize(15);
        b0.show();
        break;
      case 2: // prepare 2
        b0.setPosition(89, 198);
        b0.setSize(20);
        b0.show();
        break;
      case 3: // charge 0
        b00.setPosition(64, 177);
        b00.setSize(10);
        b00.show();
        break;
      case 4: // charge 1
        b00.setPosition(66, 161);
        b00.setSize(15);
        b00.show();
        break;
      case 5: // charge 2
        b00.setPosition(67, 161);
        b00.setSize(20);
        b00.show();
        break;
      case 6: // attack
        b0.setPosition(99, 183);
        b0.setSize(5);
        b0.show();
        break;
      }
  }
  
}
// Player -> Mage, Warrior, Defender
// Note

public class Player extends Creature {
  float zoom;
  
  Player(int interval, float x, float y, float w, float h, int b) {
    super(interval, x, y, w, h, b);
    zoom = h/388;
    adjustY = 147 * zoom;    // adjust displayBlood position
  }

  public void lifeCycle(int _beatNum, int _phase) {
    beatNum = _beatNum;
    phase = _phase;
    blood = constrain(blood, 0, maxBlood * 2);

    if (alive && !dying) {
      move();
      
      switch(state) {
      case "stay":
        displayStay();
        break;

      case "attack":
        if (beatNum % 6 == 4) {
          state = "stay";
          displayStay();
          move();
          break;
        }
        displayAttack();
        break;

      case "defend":
        if (beatNum % 6 == 0) {
          state = "stay";
          displayStay();
          move();
          break;
        }
        displayDefend();
        break;

      case "heal":
        if (beatNum % 6 == 0) {
          state = "stay";
          displayStay();
          move();
          break;
        }
        displayHeal();
        break;
      }
    }
    if (blood <=0) {
      if (alive && !dying) {
        dying = true;
        beatDying = beatNum;
      }
    }
    if (dying) {
      displayDying();
    }
  }

  public void displayStay() {
    if (alive && !dying) {
      int n = beatNum % 3;
      if (beatNum % 6 < 3 && phase <= interval * 1/4) {
        image(stay[n], x, y, w, h);
        //tint(236, 54, 53, 240);  //237,63,120    //236,54,53
        //image(stay[n], x, y, w, h);
        //tint(255, 255, 255, 150);
        //image(stay[n], x, y, w, h);
        //noTint();
      } else {
        image(stay[n], x, y, w, h);
      } 
      
      if (showBoom) {
        //tint(255,120,120);
        image(boom, x - 10 + adjustX, y + h/2  - 140 + adjustY);
        //noTint();
      }
      if (showCha) {
        image(cha, x - 10 + adjustX, y + h/2  - 140 + adjustY);
      }
      
      displayBlood();
    }
  }

  public void displayDying() {
    blood = 0;
    if (blood < 0) {
      blood = 0;
    }
    if (beatNum - beatDying == 0) {
      image(stay[0], x, y, w, h);
      displayBlood();
    } else if (beatNum - beatDying == 1) {  //beatNum - beatDying == 1
      translate(x-w/3, y+h/2);
      rotate(-PI/6);
      image(stay[0], +w/3, -h/2, w, h);
      rotate(PI/6);
      translate(-(x-w/3), -(y+h/2));
    } else if (beatNum - beatDying == 2) {
      translate(x-w/3, y+h/2);
      rotate(-PI/2);
      image(stay[0], +w/3, -h/2, w, h);
      rotate(PI/2);
      translate(-(x-w/3), -(y+h/2));
    } else if (beatNum - beatDying == 4) {
      translate(x-w/3, y+h/2);
      rotate(-PI/2);
      image(stay[0], +w/3, -h/2, w, h);
      rotate(PI/2);
      translate(-(x-w/3), -(y+h/2));
    } else if (beatNum - beatDying > 4) {
      dying = false;
      alive = false;
    }
  }
}

public class Warrior extends Player {
  Warrior(int interval, float x, float y, float w, float h, int b) {
    super(interval, x, y, w, h, b);

    stay = new PImage[3];
    stay[0] = loadImage("images/characters/zhufengyuan/z/z2.png");
    stay[1] = loadImage("images/characters/zhufengyuan/z/z3.png");
    stay[2] = loadImage("images/characters/zhufengyuan/z/z1.png");

    attack = new PImage[4];
    for (int i = 0; i < attack.length; i++) {
      attack[i] = loadImage("images/characters/zhufengyuan/za/za" + (i+1) + ".png");
    }
  }

  // dumb slip at the monster
  public void displayAttack() {
    if (beatNum % 6 == 3) {
      if (phase <= interval * 1/18) {
        adjustX = 200;
        image(attack[0], x + 200, y, w, h);
      } else if (phase <= interval * 3/36) {
        adjustX = 350;
        image(attack[1], x + 350, y, w, h);
      } else if (phase <= interval * 4/36) {
        adjustX = 350;
        image(attack[2], x + 350, y, w, h);
      } else if (phase <= interval / 2) {
        adjustX = 350;
        image(attack[3], x + 350, y, w, h);
      } else if (phase <= interval * 11/18) {
        adjustX = 200;
        image(attack[2], x + 200, y, w, h);
      } else if (phase <= interval * 13/18) {
        adjustX = 0;
        image(attack[1], x, y, w, h);
      } else if (phase <= interval * 15/18) {
        image(attack[0], x, y, w, h);
      } else {
        image(stay[0], x, y, w, h);
      }
    }
    //if (beatNum % 6 == 4) {
    //  if (phase <= interval * 1/9) {

    //  } else if (phase <= interval * 2/9) {

    //  } else if (phase <= interval * 3/9) {

    //  } else {
    //    image(stay[1], x, y, w, h);
    //  }
    //}
    
    displayBlood();
  }

  //// dumb slant upright
  //void displayAttack() {
  //  if (beatNum % 6 == 3) {
  //    if (phase <= interval * 1/36) {
  //      adjustX = 200;
  //      adjustY = 100;
  //      image(attack[0], x + 200, y - 50, w, h);
  //    } else if (phase <= interval * 2/36) {
  //      adjustX = 300;
  //      adjustY = 50;
  //      image(attack[1], x + 300, y - 100, w, h);
  //    } else if (phase <= interval * 3/36) {
  //      image(attack[2], x + 300, y - 100, w, h);
  //    } else {
  //      image(attack[3], x + 300, y - 100, w, h);
  //    }
  //  }
  //  if (beatNum % 6 == 4) {
  //    if (phase <= interval * 1/9) {
  //      adjustX = 200;
  //      adjustY = 100;
  //      image(attack[2], x + 200, y - 50, w, h);
  //    } else if (phase <= interval * 2/9) {
  //      adjustX = 0;
  //      adjustY = 150;
  //      image(attack[1], x, y, w, h);
  //    } else if (phase <= interval * 3/9) {
  //      image(attack[0], x, y, w, h);
  //    } else {
  //      image(stay[1], x, y, w, h);
  //    }
  //  }
    
  //  displayBlood();
  //}
}

public class Mage extends Player {
  Mage(int interval, float x, float y, float w, float h, int b) {
    super(interval, x, y, w, h, b);

    stay = new PImage[3];
    stay[0] = loadImage("images/characters/wangshu/w/w2.png");
    stay[1] = loadImage("images/characters/wangshu/w/w3.png");
    stay[2] = loadImage("images/characters/wangshu/w/w1.png");

    heal = new PImage[6];
    for (int i = 0; i < heal.length; i++) {
      heal[i] = loadImage("images/characters/wangshu/wa/wa" + (i+1) + ".png");
    }

    adjustX =  - 15;    // adjust displayBlood position
  }

  public void displayHeal() {
    if (beatNum % 6 == 3) {
      if (phase <= interval * 1/3) {
        image(heal[0], x, y, w, h);
      } else if (phase <= interval * 2/3) {
        image(heal[1], x, y, w, h);
      } else {
        image(heal[2], x, y, w, h);
      }
    }
    if (beatNum % 6 == 4) {
      if (phase <= interval * 1/3) {
        image(heal[3], x, y, w, h);
      } else if (phase <= interval * 2/3) {
        image(heal[4], x, y, w, h);
      } else {
        image(heal[5], x, y, w, h);
      }
    }
    if (beatNum % 6 == 5) {
      if (phase <= interval * 2/3) {
        image(heal[5], x, y, w, h);
      } else {
        image(stay[2], x, y, w, h);
      }
    }

  }
} 

public class Defender extends Player {
  Defender(int interval, float x, float y, float w, float h, int b) {
    super(interval, x + 15, y, w, h, b);

    stay = new PImage[3];
    stay[0] = loadImage("images/characters/zhangyue/z/z2.png");
    stay[1] = loadImage("images/characters/zhangyue/z/z3.png");
    stay[2] = loadImage("images/characters/zhangyue/z/z1.png");

    defend = new PImage[5];
    for (int i = 0; i < defend.length; i++) {
      defend[i] = loadImage("images/characters/zhangyue/za/za" + (i+1) + ".png");
    }

    adjustX =  - 35;    // adjust displayBlood position
  }

  public void displayDefend() {
    if (beatNum % 6 == 3) {
      if (phase <= interval/3) {
        image(defend[0], x, y, w, h);
      } else if (phase <= interval * 2/3) {
        image(defend[1], x, y, w, h);
      } else {
        image(defend[2], x, y, w, h);
      }
    }
    if (beatNum % 6 == 4) {
        image(defend[1], x, y, w, h);
    }
    if (beatNum % 6 == 5) {
      if (phase <= interval * 1/6) {
        image(defend[0], x, y, w, h);
      } else if (phase <= interval * 2/6) {
        image(defend[3], x, y, w, h);
      } else {
        image(stay[2], x, y, w, h);
      }
    }
         
    displayBlood();
  }
}


class Note {
 AudioPlayer[] buffer;
 int count;
 int copies = 3;
 Note(Minim minim, String path) {
   buffer = new AudioPlayer[copies];
   count = 0;
   for (int i = 0; i < buffer.length; i++) {
     buffer[i] = minim.loadFile(path, 256);
   }
 }
 
 public void play() {
   buffer[count].rewind();
   buffer[count].play();
   count = (count + 1) % copies;
 }
}
class Tutorials {
  BGM bgm;
  Tutorial_take_weapon scene1;
  Tutorial_wave_rhythm scene2;
  Tutorial_attack scene3;
  Tutorial_heal scene4;
  Tutorial_defend scene5;
  int scene;
  int nextScene;  //for switching
  int beatPass;
  int beatsSwitching;
  boolean pass;

  Tutorials(BGM _bgm) {
    bgm = _bgm;
    scene1 = new Tutorial_take_weapon(bgm);
    scene2 = new Tutorial_wave_rhythm(bgm);
    scene3 = new Tutorial_attack(bgm);
    scene4 = new Tutorial_heal(bgm);
    scene5 = new Tutorial_defend(bgm);
    scene = 1;
    nextScene = 0;
    beatsSwitching = 0;
    pass = false;
  }

  public void execute() {
    // force quit to menu = '0'
    if (key == '0') {
      pass = true;
    }
    
    switch(scene) {
    case 0: 
      if (bgm.beatsPlayed - beatPass >= beatsSwitching) {
        scene = nextScene;
        break;
      } else {
        background(255); 
        break;
      }
    case 1:
      if (scene1.pass) {
        beatPass = bgm.beatsPlayed();
        scene = 0;
        nextScene = 2;
        break;
      } else {
        scene1.execute();   
        break;
      }
    case 2:
      if (scene2.pass) {
        beatPass = bgm.beatsPlayed();
        scene = 0;
        nextScene = 3;
        scene3.setStart(bgm.beatsPlayed());
        //nextScene = 0;  // = 3;
        //pass = true;  // Tutorial ended
        break;
      } else {
        scene2.execute();
        break;
      }
    case 3:
      if (scene3.pass) {
        beatPass = bgm.beatsPlayed();
        scene = 0;
        nextScene = 4;
        scene4.setStart(bgm.beatsPlayed());
        break;
      } else {
        scene3.execute();
        break;
      }
    case 4:
      if (scene4.pass) {
        beatPass = bgm.beatsPlayed();
        scene = 0;
        nextScene = 5;
        scene5.setStart(bgm.beatsPlayed());
        break;
      } else {
        scene4.execute();
        break;
      }
    case 5:
      if (scene5.pass) {
        beatPass = bgm.beatsPlayed();
        pass = true;  // Tutorial ended
        scene = 0;
        nextScene = 0;
        break;
      } else {
        scene5.execute();
        break;
      }
    }
  }

  public void myKeyInput() {
    switch (scene) {
    case 1:
      scene1.myKeyInput();
      break;
    case 2: 
      scene2.myKeyInput();
      break;
    case 3: 
      scene3.myKeyInput();
      break;
    case 4: 
      scene4.myKeyInput();
      break;
    case 5: 
      scene5.myKeyInput();
      break;
    }
  }
  
  public void myPortInput(String input) {
   switch (scene) {
    case 1:
      scene1.myPortInput(input);
      break;
    case 2: 
      scene2.myPortInput(input);
      break;
    case 3: 
      scene3.myPortInput(input);
      break;
    case 4: 
      scene4.myPortInput(input);
      break;
    case 5: 
      scene5.myPortInput(input);
      break;
    }
  }
}
public class Tutorial_attack {
  // BGM
  BGM bgm;

  //Visual part
  BkgVisual_attack bk;
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

  Tutorial_attack(BGM _bgm) {
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
    yue = new Defender(bgm.interval(), 466, 489, 241*0.95f, 388*0.95f, 4);
    zhu = new Warrior(bgm.interval(), 285, 489, 226*0.95f, 388*0.95f, 4);
    shu = new Mage(bgm.interval(), 139, 489, 225*0.95f, 388*0.95f, 4);
    mon = new Monster(bgm.interval(), 760, 450, 438*0.95f, 465*0.95f, 9);
    monsOrder = "stay";    // stay, attack
    monsInterval1 = 8;     // practice mode
    monsInterval2 = 14;    // fight mode

    sword = new Sword();
    wand = new Wand();
    shield = new Shield();
    bk = new BkgVisual_attack();
    startBeat = bgm.beatsPlayed();
    // sound (Minim!!)
    minim = new Minim(BoomChaCha.this);
    magic = minim.loadFile("music/magic.mp3", 512);
    swipe = minim.loadFile("music/swipe.mp3", 512);
    defence = minim.loadFile("music/shield.mp3", 512);

    dol = new Note(minim, "music/dol.mp3");
    mi = new Note(minim, "music/mi.mp3");
    sol = new Note(minim, "music/sol.mp3");
    dol_low = new Note(minim, "music/dol_low.mp3");
    mi_low = new Note(minim, "music/mi_low.mp3");
    sol_low = new Note(minim, "music/sol_low.mp3");

    pass = false;
    startBeat = 0;
  }

  public void setStart(int _startBeat) {
    startBeat = _startBeat;
    pass = false;
  }

  public void execute() {
    bk.display(bgm.beatsPlayed(), bgm.phase, bgm.interval);
    beats = bgm.beatsPlayed() - startBeat;

    shu.lifeCycle(bgm.beatsPlayed(), bgm.phase());
    zhu.lifeCycle(bgm.beatsPlayed(), bgm.phase());
    yue.lifeCycle(bgm.beatsPlayed(), bgm.phase());
    mon.lifeCycle(bgm.beatsPlayed(), bgm.phase());

    // initial stage
    if (beats <= 48) {
      bk.text = "Tutorial 3 of 5: Powerful Attack";
      fill(0, 0, 0, 200);
      noStroke();
      rectMode(CENTER);
      rect(width/2, height/2 + 48, width, height - 96);
      if (beats < 12) {
        fill(255);
        text("Enemy shows up! Let's learn attack.", width/2, height/2) ;
      } else if (beats < 24) {
        fill(255);
        text("Sway the sword on 'Boom', then you can do attack.", width/2, height/2);
      } else if (beats < 36) {
        fill(255);
        text("As you learned, ", width/2, height/2 - 40);
        text("if sword is followed by 'Cha Cha', ", width/2, height/2);
        text("attack will become more powerful.", width/2, height/2 + 40);
      } else if (beats < 48) {
        fill(255);
        text("Now, beat the enemy hard with BoomChaCha!", width/2, height/2);
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
      if (!mon.alive) {
        enablePass = true;
        bk.showGot = true;
        bk.text_mid = "Well done!";
      }
    } else {  // if beatPass != 0, 
      if (bgm.beatsPlayed() - beatPass >= 6) {
        bk.showGot = true;
        enablePass = true;
      }
    }
  }

  public void onBeat() {
    int n = bgm.n();
    if (n == 2) {
      // clear text
      bk.text_mid = null;
    }

    if (n == 3) {
      // get feedback
      if (orders[0] == "Attack") {
        power = beatJudges[0] + beatJudges[1] + beatJudges[2];
        //power = 6;
        //zhu.jump(true);
        swipe.rewind();
        swipe.cue(100);
        swipe.play();
        zhu.setState("attack");
        playerAttack(power);
        println("Attack", power);
        if (beatJudges[0] != 0 && beatJudges[1] != 0 && beatJudges[2] != 0) {
          bk.text_mid = "Powerful Attack!";
          //bk.excellent = true;
        } else {
          bk.text_mid = "Good! Assist with more 'Cha'.";
          //bk.good = true;
        }
      } else if (orders[0] != "Null") {
        bk.text_mid = "Try to start 'Boom' with sword to make an attack.";
        //bk.try_again = true;
      } else {
        if (beatJudges[1] != 0 || beatJudges[2] != 0) {
          bk.text_mid = "Try to make a 'Boom' with sword.";
          //bk.try_again = true;
        } else {
          // no input, do nothing
        }
      }
    }
    // players' cycle
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
    }
    /// change the words
  }


  public void myKeyInput() {
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

  public void myPortInput(String _input) {
    if (after_initial) {
      input = _input;
      inputValues();
    }
  }

  public void inputValues() {
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
  public void playerAttack(int power) {
    mon.blood -= power;
  }
}


public class BkgVisual_attack extends BkgVisual {
  PImage Instruction;
  PImage Excellent;
  PImage Good;
  PImage Try_again;
  PImage boom, cha;

  // booleans for feedback
  boolean excellent = false;
  boolean good = false;
  boolean try_again = false;

  BkgVisual_attack() {
    super();
    Instruction = loadImage("images/Tutorial_attack/t4.png");
    Excellent = loadImage("images/Tutorial_attack/perfect.png");
    Good = loadImage("images/Tutorial_attack/good.png");
    Try_again = loadImage("images/Tutorial_attack/try again.png");
    boom = loadImage("images/status/Boom.png");
    cha = loadImage("images/status/Cha.png");
    text_mid_y = 240;
  }

  public void display(int beatNum, int phase, int interval) {
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
    yue = new Defender(bgm.interval(), 466, 489, 241*0.95f, 388*0.95f, 4);
    zhu = new Warrior(bgm.interval(), 285, 489, 226*0.95f, 388*0.95f, 4);
    shu = new Mage(bgm.interval(), 139, 489, 225*0.95f, 388*0.95f, 4);
    mon = new Monster(bgm.interval(), 760, 450, 438*0.95f, 465*0.95f, 15);
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

  public void setStart(int _startBeat) {
    startBeat = _startBeat;
    pass = false;
  }

  public void execute() {
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
      if (score >= 3) {
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

  public void onBeat() {
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
            bk.text_mid = "Powerful defence! Counted " + score + "/3";
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

  public void monsterAttack() {
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

  public void myKeyInput() {
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

  public void myPortInput(String _input) {
    if (after_initial) {
      input = _input;
      inputValues();
    }
  }

  public void inputValues() {
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
  public void playerAttack(int power) {
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

  public void display(int beatNum, int phase, int interval) {
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
public class Tutorial_heal {
  // BGM
  BGM bgm;

  //Visual part
  BkgVisual_heal bk;
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

  Tutorial_heal(BGM _bgm) {
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
    yue = new Defender(bgm.interval(), 466, 489, 241*0.95f, 388*0.95f, 4);
    zhu = new Warrior(bgm.interval(), 285, 489, 226*0.95f, 388*0.95f, 4);
    shu = new Mage(bgm.interval(), 139, 489, 225*0.95f, 388*0.95f, 4);
    yue.changeBlood(-7);
    zhu.changeBlood(-7);
    shu.changeBlood(-7);
    mon = new Monster(bgm.interval(), 760, 450, 438*0.95f, 465*0.95f, 15);
    monsOrder = "stay";    // stay, attack
    monsInterval1 = 8;     // practice mode
    monsInterval2 = 14;    // fight mode

    sword = new Sword();
    wand = new Wand();
    shield = new Shield();
    bk = new BkgVisual_heal();
    startBeat = bgm.beatsPlayed();
    // sound (Minim!!)
    minim = new Minim(BoomChaCha.this);
    magic = minim.loadFile("music/magic.mp3", 512);
    swipe = minim.loadFile("music/swipe.mp3", 512);
    defence = minim.loadFile("music/shield.mp3", 512);

    dol = new Note(minim, "music/dol.mp3");
    mi = new Note(minim, "music/mi.mp3");
    sol = new Note(minim, "music/sol.mp3");
    dol_low = new Note(minim, "music/dol_low.mp3");
    mi_low = new Note(minim, "music/mi_low.mp3");
    sol_low = new Note(minim, "music/sol_low.mp3");

    pass = false;
    startBeat = 0;
  }

  public void setStart(int _startBeat) {
    startBeat = _startBeat;
    pass = false;
  }

  public void execute() {
    bk.display(bgm.beatsPlayed(), bgm.phase, bgm.interval);
    beats = bgm.beatsPlayed() - startBeat;

    shu.lifeCycle(bgm.beatsPlayed(), bgm.phase());
    zhu.lifeCycle(bgm.beatsPlayed(), bgm.phase());
    yue.lifeCycle(bgm.beatsPlayed(), bgm.phase());
    mon.lifeCycle(bgm.beatsPlayed(), bgm.phase());

    // initial stage
    if (beats <= 48) {
      bk.text = "Tutorial 4 of 5: Powerful Heal";
      fill(0, 0, 0, 200);
      noStroke();
      rectMode(CENTER);
      rect(width/2, height/2 + 48, width, height - 96);
      if (beats < 12) {
        fill(255);
        text("You're hurt. Let's learn healing.", width/2, height/2) ;
      } else if (beats < 24) {
        fill(255);
        text("Wave the wand on 'Boom', then you can heal yourself.", width/2, height/2);
      } else if (beats < 36) {
        fill(255);
        text("Likewise,", width/2, height/2 - 40);
        text("if wand is followed by 'Cha Cha', ", width/2, height/2);
        text("it will become more powerful.", width/2, height/2 + 40);
      } else if (beats < 48) {
        fill(255);
        text("Now, try to heal fast, as you'll keep getting hurt", width/2, height/2);
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
      if (zhu.blood == zhu.maxBlood * 2) {
        bk.text_mid = "Well done!";
        beatPass = bgm.beatsPlayed();
      }
    } else {  // if beatPass != 0, 
      if (bgm.beatsPlayed() - beatPass >= 6) {
        bk.showGot = true;
        enablePass = true;
      }
    }
  }

  public void onBeat() {
    int n = bgm.n();
    if (n == 0) {
      if (zhu.blood > 1) {
        zhu.blood --;
        yue.blood --;
        shu.blood --;
      }
    }

    if (n == 2) {
      // clear text
      bk.text_mid = null;
    }

    if (n == 3) {
      // get feedback
      if (orders[0] == "Heal") {
        power = beatJudges[0] + beatJudges[1] + beatJudges[2];
        magic.rewind();
        magic.play();
        shu.setState("heal");

        println("Heal", power);
        if (beatJudges[0] != 0 && beatJudges[1] != 0 && beatJudges[2] != 0) {
          bk.text_mid = "Powerful Heal!";
          //bk.excellent = true;
        } else {
          bk.text_mid = "Good! Assist with more 'Cha'.";
          //bk.good = true;
        }
      } else if (orders[0] != "Null") {
        bk.text_mid = "Try to start 'Boom' with wand to heal.";
        //bk.try_again = true;
      } else {
        if (beatJudges[1] != 0 || beatJudges[2] != 0) {
          bk.text_mid = "Try to make a 'Boom' with wand.";
          //bk.try_again = true;
        } else {
          // no input, do nothing
        }
      }
    }
    // players' cycle
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
      if (shu.currentState() == "heal") {
        playerHeal(power);
      }
      bk.excellent = false;
      bk.good = false;
      bk.try_again = false;
    }
    /// change the words
  }




  public void myKeyInput() {
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

  public void myPortInput(String _input) {
    if (after_initial) {
      input = _input;
      inputValues();
    }
  }

  public void inputValues() {
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
  public void playerHeal(int power) {
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
}


public class BkgVisual_heal extends BkgVisual {
  PImage Instruction;
  PImage Excellent;
  PImage Good;
  PImage Try_again;
  PImage boom, cha;

  // booleans for feedback
  boolean excellent = false;
  boolean good = false;
  boolean try_again = false;

  BkgVisual_heal() {
    super();
    Instruction = loadImage("images/Tutorial_heal/t4.png");
    Excellent = loadImage("images/Tutorial_heal/perfect.png");
    Good = loadImage("images/Tutorial_heal/good.png");
    Try_again = loadImage("images/Tutorial_heal/try again.png");
    boom = loadImage("images/status/Boom.png");
    cha = loadImage("images/status/Cha.png");
    text_mid_y = 240;
  }

  public void display(int beatNum, int phase, int interval) {
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
// players on stage, hit boom and recognize each other

class Tutorial_take_weapon {
  // BGM copied from tutorial.bgm, refresh every loop
  BGM bgm;
  int startBeat;
  int beatShow;  // when characters appear

  //Visual part
  BkgVisual_take_weapon bk;
  Defender yue;
  Warrior zhu;
  Mage shu;

  // Guide_Content
  Sword sword;
  Wand wand;
  Shield shield;

  // sound
  Minim minim;
  AudioPlayer magic, swipe, defence;
  Note dol, mi, sol;
  Note dol_low, mi_low, sol_low;

  //something for judgement
  String input;
  String feedback;
  String[] orders;
  int[] beatJudges;
  boolean warriorCalled = false;
  boolean mageCalled = false;
  boolean defenderCalled = false;

  boolean enablePass;
  boolean pass;

  Tutorial_take_weapon(BGM _bgm) {
    // bgm
    bgm = _bgm;

    // input
    orders = new String[3];
    beatJudges = new int[3];
    for (int i = 0; i < 3; i++) {
      orders[i] = "Null";
      beatJudges[i] = 0;
    }
    //Characters, x,y,w,h,blood
    yue = new Defender(bgm.interval(), 812, 450, 241*1.2f, 388*1.2f, 4);
    zhu = new Warrior(bgm.interval(), 512, 450, 226*1.2f, 388*1.2f, 4);
    shu = new Mage(bgm.interval(), 240, 450, 225*1.2f, 388*1.2f, 4);
    yue.alive = false;
    zhu.alive = false;
    shu.alive = false;
    yue.hideBlood = true;
    zhu.hideBlood = true;
    shu.hideBlood = true;

    sword = new Sword();
    wand = new Wand();
    shield = new Shield();
    bk = new BkgVisual_take_weapon();

    // sound (Minim!!)
    minim = new Minim(BoomChaCha.this);
    magic = minim.loadFile("music/magic.mp3", 512);
    swipe = minim.loadFile("music/swipe.mp3", 512);
    defence = minim.loadFile("music/shield.mp3", 512);

    dol = new Note(minim, "music/dol.mp3");
    mi = new Note(minim, "music/mi.mp3");
    sol = new Note(minim, "music/sol.mp3");
    dol_low = new Note(minim, "music/dol_low.mp3");
    mi_low = new Note(minim, "music/mi_low.mp3");
    sol_low = new Note(minim, "music/sol_low.mp3");

    enablePass = false;
    pass = false;
    startBeat = bgm.beatsPlayed();
    beatShow = 0;
  }

  //void setStart(int _startBeat) {
  //  startBeat = _startBeat;
  //  pass = false;
  //}

  public void execute() {
    bk.display(bgm.beatsPlayed(), bgm.phase, bgm.interval);

    if (bgm.newBeatIn()) {
      if (bgm.beatsPlayed() >= 5) {
        if (bgm.n == 0 && !zhu.alive) {
          zhu.alive = true;
          zhu.jump(true);
          bk.text_mid = "Sword performs attack!";
          beatShow = bgm.beatsPlayed();
        }
        if (beatShow != 0 && bgm.beatsPlayed - beatShow == 3) {
          //myPort.write('d');
          zhu.setState("attack");
          swipe.play();
        }
        if (beatShow != 0 && bgm.beatsPlayed - beatShow == 6) {
          //myPort.write('f');
          yue.alive = true;
          yue.jump(true);
          bk.text_mid = "Shield prevents damage!";
        }
        if (beatShow != 0 && bgm.beatsPlayed - beatShow == 9) {
          //myPort.write('f');
          yue.setState("defend");
          defence.play();
        }
        if (beatShow != 0 && bgm.beatsPlayed - beatShow == 12) {
          //myPort.write('g');
          shu.alive = true;
          shu.jump(true);
          bk.text_mid = "Wand heals all!";
        }
        if (beatShow != 0 && bgm.beatsPlayed - beatShow == 15) {
          //myPort.write('g');
          shu.setState("heal");
          magic.play();
        }
        if (beatShow != 0 && bgm.beatsPlayed - beatShow == 18) {
          bk.text_mid = "Wand heals. Sword attacks. Shield defends.";
        }
        if (beatShow != 0 && bgm.beatsPlayed - beatShow == 24) {
          bk.showGot = true;
          enablePass = true;
        }
      }
    }

    shu.lifeCycle(bgm.beatsPlayed(), bgm.phase());
    zhu.lifeCycle(bgm.beatsPlayed(), bgm.phase());
    yue.lifeCycle(bgm.beatsPlayed(), bgm.phase());
  }
  
  public void myKeyInput() {
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

 public void myPortInput(String _input) {
   input = _input;
   inputValues();
 }
 
 public void inputValues() {
   if (input == "swipe") {
     if (enablePass) {
       sol.play();
       pass = true;
     }
   }
 }
}


public class Sword {
 PImage swords[];
 Sword() {
   swords = new PImage[3];
   for (int i = 0; i < 3; i++) {
     swords[i] = loadImage("images/Tutorial_take_weapon/animation/knife/k"+i+".png");
   }
 }
 public void display(int index) {
   imageMode(CENTER);
   image(swords[index], width/2, height/2);
 }
}

public class Wand {
 PImage wands[];
 Wand() {
   wands = new PImage[3];
   for (int i = 0; i < 3; i++) {
     wands[i] = loadImage("images/Tutorial_take_weapon/animation/mozhanh/m"+(i+1)+".png");
   }
 }
 public void display(int index) {
   imageMode(CENTER);
   image(wands[index], width/2, height/2);
 }
}

public class Shield {
 PImage shields[];
 Shield() {
   shields = new PImage[3];
   for (int i = 0; i < 3; i++) {
     shields[i] = loadImage("images/Tutorial_take_weapon/animation/dun/d"+(i+1)+".png");
   }
 }
 public void display(int index) {
   imageMode(CENTER);
   image(shields[index], width/2, height/2);
 }
}


class BkgVisual {
  PImage imgBkg;
  PImage imgEyes;
  // words
  String text;
  String text_mid;
  int text_mid_y;  // position of text_mid
  PFont aw;
  PImage pots[];
  PImage border;
  
  boolean showGot;
  PImage gotit;
  //  PImage[] shadow;//0 for wand, 1 for sword, 2 for shield
  //  boolean[] shadowExist;
  BkgVisual() {
    imgBkg = loadImage("images/Tutorial_take_weapon/background.png");
    imgEyes = loadImage("images/Tutorial_take_weapon/blinking eye.png");
    aw = createFont("fonts/Comic Sans MS Bold.ttf", 32);
    pots = new PImage[6];
    for (int i = 0; i < 6; i++) {
      pots[i] = loadImage("images/Tutorial_take_weapon/pots"+i+".png");
    }
    border = loadImage("images/Tutorial_bkg/border.png");
    
    showGot = false;
    gotit = loadImage("images/Tutorial_bkg/gotit.png");
    
    text_mid_y = 300;
  }

  public void display(int beatNum, int phase, int interval) {     
    // trees
    imageMode(CENTER);
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
    // pots
    image(pots[beatNum % 6], width/2, height/2);
    
    // border
    if (beatNum % 6 < 2 || (beatNum % 6 == 2 && phase <= interval/2)) {
      tint(255,200);
      image(border, width/2, height/2);
      noTint();
    }
    if (beatNum % 6 == 2 && phase > interval / 2) {
      int alpha = round(map(phase, interval/2, interval, 200, 128));
      tint(255,alpha);
      image(border, width/2, height/2);
      noTint();
    }
    
    // text
    textAlign(CENTER);
    textFont(aw);
    if (text != null) {
      fill(0);
      text(text, width/2, 70);
    }
    if (text_mid != null) {
      fill(255);
      text(text_mid, width/2, text_mid_y);
    }
    
    // showGotit, skip
    if (showGot) {
      if (beatNum % 3 < 2) {
        image(gotit, width/2, 720);
      } else {
        int alpha = round(map(phase, 0, interval, 255, 0));
        tint(255, alpha);
        image(gotit, width/2, 720);
        noTint();
      }
    }

    // shadows
  }
}


class BkgVisual_take_weapon extends BkgVisual {
  BkgVisual_take_weapon() {
    super();
    text = "Tutorial 1 of 5: Weapons and abilities";  // of 5
  }

  public void display(int beatNum, int phase, int interval) {     
    super.display(beatNum, phase, interval);
  }
}
// ask players to wave one by one following the rhythm

class Tutorial_wave_rhythm {
  // BGM copied from tutorial.bgm, refresh every loop
  BGM bgm;
  int startBeat;

  //Visual part
  BkgVisual bk;
  Defender yue;
  Warrior zhu;
  Mage shu;

  // Guide_Content
  Sword sword;
  Wand wand;
  Shield shield;

  // sound
  Minim minim;
  AudioPlayer magic, swipe, defence;
  Note dol, mi, sol;
  Note dol_low, mi_low, sol_low;

  //something for judgement
  String input;
  String feedback;
  String[] orders;
  int[] beatJudges;
  boolean warriorCalled = false;
  boolean mageCalled = false;
  boolean defenderCalled = false;

  int score;  // when they acted right three times then pass
  boolean enablePass;
  boolean pass;

  Tutorial_wave_rhythm(BGM _bgm) {
    // bgm
    bgm = _bgm;

    // input
    orders = new String[3];
    beatJudges = new int[3];
    for (int i = 0; i < 3; i++) {
      orders[i] = "Null";
      beatJudges[i] = 0;
    }
    //Characters, x,y,w,h,blood
    yue = new Defender(bgm.interval(), 812, 450, 241*1.2f, 388*1.2f, 4);
    zhu = new Warrior(bgm.interval(), 512, 450, 226*1.2f, 388*1.2f, 4);
    shu = new Mage(bgm.interval(), 240, 450, 225*1.2f, 388*1.2f, 4);
    yue.hideBlood = true;
    zhu.hideBlood = true;
    shu.hideBlood = true;

    sword = new Sword();
    wand = new Wand();
    shield = new Shield();
    bk = new BkgVisual();
    bk.text = "Tutorial 2 of 5: Act with rhythm";
    bk.text_mid = "Follow the guides. Act when border blinks.";

    // sound (Minim!!)
    minim = new Minim(BoomChaCha.this);
    magic = minim.loadFile("music/magic.mp3", 512);
    swipe = minim.loadFile("music/swipe.mp3", 512);
    defence = minim.loadFile("music/shield.mp3", 512);

    dol = new Note(minim, "music/dol.mp3");
    mi = new Note(minim, "music/mi.mp3");
    sol = new Note(minim, "music/sol.mp3");
    dol_low = new Note(minim, "music/dol_low.mp3");
    mi_low = new Note(minim, "music/mi_low.mp3");
    sol_low = new Note(minim, "music/sol_low.mp3");

    score = 0;
    enablePass = false;
    pass = false;
    startBeat = bgm.beatsPlayed();
  }

  public void execute() {
    bk.display(bgm.beatsPlayed(), bgm.phase, bgm.interval);

    if (bgm.newBeatIn()) {
      onBeat();
    }

    // where there was no guides...try memory
    if (score < 3) {
      visual_guides();
    } 
    
    // feedback
    if (bgm.n >= 3 && bgm.n <=5) {
      if (feedback != null) {
        text(feedback, width/2, height/2);
      }
    }

    shu.lifeCycle(bgm.beatsPlayed(), bgm.phase());
    zhu.lifeCycle(bgm.beatsPlayed(), bgm.phase());
    yue.lifeCycle(bgm.beatsPlayed(), bgm.phase());
    
    text("Goal:", 900, 680);
    text(score + "/3", 900, 720);
    if (score >= 3) {
      bk.text_mid = "Good job!";
      if (bgm.n == 2) {
        enablePass = true;
        bk.showGot = true;
      }
    }
  }

  public void visual_guides() {
    if (bgm.n == 5) {
      if (bgm.phase() > bgm.interval() * 2 / 3) {
        sword.display(0);
      }
    }
    if (bgm.n == 0) {
      if (bgm.phase() < bgm.interval() / 4) {
        sword.display(1);
      }
      if (bgm.phase() < bgm.interval() / 2 && bgm.phase() > bgm.interval() /4) {
        sword.display(2);
      }
      if (bgm.phase() > bgm.interval() *3/4) {
        shield.display(0);
      }
    }
    if (bgm.n == 1) {
      if (bgm.phase() < bgm.interval() / 4) {
        shield.display(1);
      }
      if (bgm.phase() < bgm.interval() / 2 && bgm.phase() > bgm.interval() /4) {
        shield.display(2);
      }
      if (bgm.phase() > bgm.interval() *3/4) {
        wand.display(0);
      }
    }
    if (bgm.n == 2) {
      if (bgm.phase() < bgm.interval() / 4) {
        wand.display(1);
      }
      if (bgm.phase() < bgm.interval() / 2 && bgm.phase() > bgm.interval() /4) {
        wand.display(2);
      }
    }
  }

  public void onBeat() {
    int n = bgm.n();
    int power = beatJudges[0] + beatJudges[1] + beatJudges[2];
    if (n == 3) {
      if (orders[0] == "Null" && orders[1] == "Null" && orders[2] == "Null") {
        feedback = "";
      } else if (orders[0] == "Attack" && orders[1] == "Defend" && orders[2] == "Heal") {
        swipe.rewind();
        swipe.cue(100);
        swipe.play();
        zhu.setState("attack");
        if (power == 6) {
          feedback = "Perfect! + 1";
          score += 1;
        } else {
          feedback = "Correct! + 1";
          score += 1;
        }
      } else if (orders[0] == "Null") {
        feedback = "Need the Boom!";
      } else if (orders[1] == "Null" || orders[2] == "Null") {
        feedback = "Need more Cha!";
      }
    }
    // players' cycle
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
    if (n == 5 ) {
      feedback = "";
    }
  }

  public void myKeyInput() {
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

  public void myPortInput(String _input) {
    input = _input;
    inputValues();
  }

  public void inputValues() {
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
}
  public void settings() {  size(1024, 768, P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#000000", "--hide-stop", "BoomChaCha" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
