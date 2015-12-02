public class Monster extends Creature {
  String state;
  int lastBeatNum;
  
  PImage[] monster;
  PImage[] monsterPrep;
  PImage[] monsterCharge;
  PImage monsterAtt;

  Monster(float x, float y, float w, float h, int b) {
    super(x, y, w, h, b);
    state = "stay";
    
    monster = new PImage[3];
    monster[0] = loadImage("images/characters/monster/m/m3.png");
    monster[1] = loadImage("images/characters/monster/m/m4.png");
    monster[2] = loadImage("images/characters/monster/m/m2.png");
    
    monsterPrep = new PImage[3];
    for (int i = 0; i < 3; i++) {
      monsterPrep[i] = loadImage("images/characters/monster/ma/ma"+ i + ".png");
    }
    
    monsterCharge = new PImage[3];
    for (int i = 0; i < 3; i++) {
      monsterCharge[i] = loadImage("images/characters/monster/ma/ma"+ (i+3) + ".png");
    }
    
    monsterAtt = loadImage("images/characters/monster/ma/ma6.png");
  }

  void lifeCycle(int beatNum) {
    if (blood <=0) {
      if (!dying) {
        dying = true;
        beatDying = beatNum;
      }
    }
    if (dying) {
      dying(beatNum);
    }
    if (alive && !dying) {
      switch(state) {
        case "stay":
          display(beatNum);
          break;
        case "prepare":
          if (beatNum % 6 == 0) {
            state = "charge";
            break;
          } else {
            displayPrep(beatNum);
            break;
          }
        case "charge":
          if (beatNum % 6 == 3) {
            state = "attack";
            break;
          } else {
            displayCharge(beatNum);
            break;
          }
        case "attack":
          if (beatNum % 6 == 4) {
            state = "stay";
            break;
          } else {
            displayAtt(beatNum);
            break;
          }
      }
    }
    
    lastBeatNum = beatNum;
    
  }

  void display(int beatNum) {
    display(monster, beatNum);
  }
  
  void displayPrep(int beatNum) {
    tint(128,0,0);
    if (beatNum % 6 == 3) {
      image(monsterPrep[0], x, y, w, h);
      displayBlood();
    } else if (beatNum % 6 == 4) {
      image(monsterPrep[1], x, y, w, h);
      displayBlood();
    } else if (beatNum % 6 == 5) {
      image(monsterPrep[2], x, y, w, h);
      displayBlood();
    }
    noTint();
  }
  
  void displayCharge(int beatNum) {
    tint(255,0,0);
    if (beatNum % 6 == 0) {
      image(monsterCharge[0], x, y, w, h);
      displayBlood();
    } else if (beatNum % 6 == 1) {
      image(monsterCharge[1], x, y, w, h);
      displayBlood();
    } else if (beatNum % 6 == 2) {
      image(monsterCharge[2], x, y, w, h);
      displayBlood();
    }
    noTint();
  }
  
  void displayAtt(int beatNum) {
    tint(255,0,0);
    if (beatNum % 6 == 3) {
      image(monsterAtt, x, y, w, h);
      displayBlood();
    }
    noTint();
  }

  void displayBlood() {
    int size = 35;
    float currentX = x - float(maxBlood)/2 * size + size/2;
    float currentY = y - h/2 - size/2 + 50;
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
  
  void dying(int beatNum) {
    blood = 0;
    if (blood < 0) {
      blood = 0;
    }
    
    if (beatNum - beatDying == 0) {  //beatNum - beatDying
      translate(x+w/3, y+h/2);
      rotate(PI/6);
      image(monster[0], -w/3, -h/2, w, h); 
      rotate(-PI/6);
 translate(-(x+w/3),-(y+h/2));
    } else if (beatNum - beatDying == 1) {  //beatNum - beatDying       
      translate(x+w/3, y+h/2);
      rotate(PI/2);
      image(monster[0], -w/3, -h/2, w, h);
      rotate(-PI/2);
      translate(-(x+w/3),-(y+h/2));
    } else if (beatNum - beatDying == 3) {
      translate(x+w/3, y+h/2);
      rotate(PI/2);
      image(monster[0], -w/3, -h/2, w, h);
      rotate(-PI/2);
      translate(-(x+w/3),-(y+h/2));
    } else if (beatNum - beatDying >= 9){
      dying = false;
      alive = false;
    }
  }
}