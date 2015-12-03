public class Monster extends Creature {  
  boolean scored;
  int lastBeatNum;

  Monster(int interval, float x, float y, float w, float h, int b) {
    super(interval, x, y, w, h, b);
    scored = false;
    
    stay = new PImage[3];
    
    stay[0] = loadImage("images/characters/monster/m/m4.png");
    stay[1] = loadImage("images/characters/monster/m/m3.png");
    stay[2] = loadImage("images/characters/monster/m/m2.png");
    
    adjustY = 50;    // adjust displayBlood position
    
    prepare = new PImage[3];
    charge = new PImage[3];
    attack = new PImage[1];
    
    for (int i = 0; i < 3; i++) {
      prepare[i] = loadImage("images/characters/monster/ma/ma"+ i + ".png");
    }
    for (int i = 0; i < 3; i++) {
      charge[i] = loadImage("images/characters/monster/ma/ma"+ (i+3) + ".png");
      //charge[i] = loadImage("images/characters/monster/mba/mba"+ (i+1) + ".png");
    }
    
    attack[0] = loadImage("images/characters/monster/ma/ma6.png");
    //attack[0] = loadImage("images/characters/monster/mba/mba6.png");
  }

  void lifeCycle(int _beatNum, int _phase) {
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
    lastBeatNum = beatNum;
  }

  void displayPrepare() {
    tint(255,128,128);
    if (beatNum % 6 == 3) {
      image(prepare[0], x, y, w, h);
      displayBlood();
    } else if (beatNum % 6 == 4) {
      image(prepare[1], x, y, w, h);
      displayBlood();
    } else if (beatNum % 6 == 5) {
      image(prepare[2], x, y, w, h);
      displayBlood();
    }
    noTint();
  }
  
  void displayCharge() {
    tint(255,90,90);
    if (beatNum % 6 == 0) {
      image(charge[0], x, y, w, h);
      displayBlood();
    } else if (beatNum % 6 == 1) {
      image(charge[1], x, y, w, h);
      displayBlood();
    } else if (beatNum % 6 == 2) {
      image(charge[2], x, y, w, h);
      displayBlood();
    }
    noTint();
  }
  
  void displayAttack() {
    tint(255,50,50);
    if (beatNum % 6 == 3) {
      image(attack[0], x, y, w, h);
      displayBlood();
    }
    noTint();
  }
  
  void displayDying() {
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
      dying = false;
      alive = false;
    }
  }
}