// Creature > Player > Warrior, Mage and Defender
// Creature > Monster

public class Creature {
  // what should a creature apprear like?

  // they should have blood and max blood
  boolean alive;
  int blood;
  int maxBlood;
  PImage[] heart;

  // they should have existence and be able to move
  float x;
  float y;
  float w;  //width
  float h;  //height
  
  // movement related
  float y0;
  float v0;
  float vy;
  float acc;

  //String state;
  //String displaystate;
  //String type;

  Creature(float _x, float _y, float _w, float _h, int _b) {
    alive = true;
    maxBlood = _b;    // full heart displayed
    blood = 2*_b;   // allow for half heart
    if (maxBlood <=0 ) {
      println("blood should be positive integer");
    }
    heart = new PImage[3];
    heart[0] = loadImage("data/images/heart/heart_hollow.png");
    heart[1] = loadImage("data/images/heart/heart_half.png");
    heart[2] = loadImage("data/images/heart/heart_full.png");

    x = _x;
    y = _y;
    w = _w;
    h = _h;
    
    y0 = y;
    v0 = -20;
    vy = 0;
    acc = 2;
  }
  
  void display(PImage[] character, int beatNum) {
    if (beatNum % 3 == 0) {
      image(character[0], x, y, w, h);
    } else if (beatNum % 3 == 1) {
      image(character[1], x, y, w, h);
    } else {
      image(character[2], x, y, w, h);
    }

    displayBlood();
  }

  void displayBlood() {
    int size = 35;
    float currentX = x - float(maxBlood)/2 * size + size/2;
    float currentY = y - h/2 - size/2;
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
  
  // move with gravity
  void move() {
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
  void jump() {
    // jump on ground then add some big vel, jump in the air then add small vel
    if (y == y0) {
      vy = vy + v0;
    } else if (y < y0) {
      vy = vy + v0 * 0.5;
    }
  }
}