public class Player extends Creature {
  Player(float x, float y, float w, float h, int b) {
    super(x, y, w, h, b);
  }
  
  void displayBlood() {
    int size = 35;
    float currentX = x - float(maxBlood)/2 * size + size/2;
    float currentY = y - h/2 - size/2 + 150;
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
  
  void dying(PImage player[], int beatNum) {
    blood = 0;
    if (blood < 0) {
      blood = 0;
    }
    if (beatNum - beatDying == 0){
      image(player[0], x, y, w, h);
      displayBlood();
    } else if (beatNum - beatDying == 1) {  //beatNum - beatDying == 1
      translate(x-w/3, y+h/2);
      rotate(-PI/6);
      image(player[0], +w/3, -h/2, w, h);
      rotate(PI/6);
      translate(-(x-w/3),-(y+h/2));
    } else if (beatNum - beatDying == 2) {
      translate(x-w/3, y+h/2);
      rotate(-PI/2);
      image(player[0], +w/3, -h/2, w, h);
      rotate(PI/2);
      translate(-(x-w/3),-(y+h/2));
    } else if (beatNum - beatDying == 4){
      translate(x-w/3, y+h/2);
      rotate(-PI/2);
      image(player[0], +w/3, -h/2, w, h);
      rotate(PI/2);
      translate(-(x-w/3),-(y+h/2));
    } else if (beatNum - beatDying > 4){
      dying = false;
      alive = false;
    }
  }
  
}

public class Warrior extends Player {
  PImage[] warrior;
  PImage[] warriorAtt;
  Warrior(float x, float y, float w, float h, int b) {
    super(x, y, w, h, b);
    warrior = new PImage[3];
    warrior[0] = loadImage("images/characters/zhufengyuan/z/z2.png");
    warrior[1] = loadImage("images/characters/zhufengyuan/z/z3.png");
    warrior[2] = loadImage("images/characters/zhufengyuan/z/z1.png");
    
    warriorAtt = new PImage[4];
    warriorAtt[0] = loadImage("images/characters/zhufengyuan/za/za1.png");
    warriorAtt[1] = loadImage("images/characters/zhufengyuan/za/za2.png");
    warriorAtt[2] = loadImage("images/characters/zhufengyuan/za/za3.png");
    warriorAtt[3] = loadImage("images/characters/zhufengyuan/za/za4.png");
  }
  
  void lifeCycle(int beatNum) {
    if (alive && !dying) {
      display(beatNum);
      move();
    }
    if (blood <=0) {
      if (alive && !dying) {
        dying = true;
        beatDying = beatNum;
      }
    }
    if (dying) {
      dying(beatNum);
    }
  }
  
  void display(int beatNum) {
    display(warrior, beatNum);
  }
  
  //
  //void attack(int phase, int interval) {
  //  if (phase < interval / 4) {
  //    //attack image here
  //    //image
  //  }
  //}
  
  void dying(int beatNum) {
    dying(warrior, beatNum);
  }
}

public class Mage extends Player {
  PImage[] mage;
  Mage(float x, float y, float w, float h, int b) {
    super(x, y, w, h, b);
    mage = new PImage[3];
    mage[0] = loadImage("images/characters/wangshu/w/w2.png");
    mage[1] = loadImage("images/characters/wangshu/w/w3.png");
    mage[2] = loadImage("images/characters/wangshu/w/w1.png");
  }
  
  void lifeCycle(int beatNum) {
    if (alive && !dying) {
      display(beatNum);
      move();
    }
    if (blood <=0) {
      if (alive && !dying) {
        dying = true;
        beatDying = beatNum;
      }
    }
    if (dying) {
      dying(beatNum);
    }
  }
  
  void display(int beatNum) {
    display(mage, beatNum);
  }
  
  void dying(int beatNum) {
    dying(mage, beatNum);
  }
}

public class Defender extends Player {
  PImage[] defender;
  Defender(float x, float y, float w, float h, int b) {
    super(x, y, w, h, b);
    defender = new PImage[3];
    defender[0] = loadImage("images/characters/zhangyue/z/z4.png");
    defender[1] = loadImage("images/characters/zhangyue/z/z5.png");
    defender[2] = loadImage("images/characters/zhangyue/z/z3.png");
  }

  void displayBlood() {
    int size = 35;
    float currentX = x - float(maxBlood)/2 * size + size/2 - 40;
    float currentY = y - h/2 - size/2 + 150;
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
  
  void lifeCycle(int beatNum) {
    if (alive && !dying) {
      display(beatNum);
      move();
    }
    if (blood <=0) {
      if (alive && !dying) {
        dying = true;
        beatDying = beatNum;
      }
    }
    if (dying) {
      dying(beatNum);
    }
  }
  
  void display(int beatNum) {
    display(defender, beatNum);
  }
  
  void dying(int beatNum) {
    dying(defender, beatNum);
  }
}