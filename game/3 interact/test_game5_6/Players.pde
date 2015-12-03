public class Player extends Creature {

  Player(int interval, float x, float y, float w, float h, int b) {
    super(interval, x, y, w, h, b);
    adjustY = 150;    // adjust displayBlood position
  }

  void lifeCycle(int _beatNum, int _phase) {
    beatNum = _beatNum;
    phase = _phase;

    if (alive && !dying) {
      move();
      
      switch(state) {
      case "stay":
        displayStay();
        break;

      case "attack":
        if (beatNum % 6 == 5) {
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

  void displayStay() {
    if (alive && !dying) {
      int n = beatNum % 3;
      if (beatNum % 6 < 3 && phase <= interval * 1/3) {
        image(stay[n], x, y, w, h);
        tint(236, 54, 53, 240);  //237,63,120    //236,54,53
        image(stay[n], x, y, w, h);
        tint(255, 255, 255, 150);
        image(stay[n], x, y, w, h);
        noTint();
      } else {
        image(stay[n], x, y, w, h);
      }

      displayBlood();
    }
  }

  void displayDying() {
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

  void displayAttack() {
    if (beatNum % 6 == 3) {
      if (phase <= interval * 1/36) {
        adjustX = 200;
        image(attack[0], x + 200, y, w, h);
      } else if (phase <= interval * 2/36) {
        adjustX = 300;
        image(attack[1], x + 300, y, w, h);
      } else if (phase <= interval * 3/36) {
        adjustX = 300;
        image(attack[2], x + 300, y, w, h);
      } else {
        adjustX = 300;
        image(attack[3], x + 300, y, w, h);
      }
    }
    if (beatNum % 6 == 4) {
      if (phase <= interval * 1/9) {
        adjustX = 200;
        image(attack[2], x + 200, y, w, h);
      } else if (phase <= interval * 2/9) {
        adjustX = 0;
        image(attack[1], x, y, w, h);
      } else if (phase <= interval * 3/9) {
        image(attack[0], x, y, w, h);
      } else {
        image(stay[1], x, y, w, h);
      }
    }
    
    displayBlood();
  }
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

  void displayHeal() {
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

  void displayDefend() {
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