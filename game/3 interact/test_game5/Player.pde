public class Creature {
  // do something!
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
  
  String state;
  String displaystate;
  String type;

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
    int size = 30;
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
}

public class Player extends Creature {
  Player(float x, float y, float w, float h, int b) {
    super(x, y, w, h, b);
  }
}