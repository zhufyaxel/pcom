// Monster, Ball, BallsAni

public class Monster extends Creature {  
  boolean scored;
  //BallsAni balls;
  float zoom = 0.95;

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
  }

  void displayPrepare() {
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
  
  void displayCharge() {
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
  
  void displayAttack() {
    if (beatNum % 6 == 3) {
      image(attack[0], x, y, w, h);
      displayBlood();
    }
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
  
  void show() {
    noStroke();
    fill(243,71,36);
    ellipse(tx, ty, size, size);
  }
  
  void setSize(int _size) {
    if (size != _size) {
      size = _size;
    }
  }
  
  void setPosition(float _x, float _y) {
    if (x != _x && y != _y) {
      x = _x;
      y = _y;
      mapPosition();
    }
  }
  
  void mapPosition() {
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
  
  void show(int stage) {
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