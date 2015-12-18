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
  
  void displayStay() {
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
  
  void addBoom() {
    showBoom = true;
  }
  
  void removeBoom() {
    showBoom = false;
  }
  
  void addCha() {
    showCha = true;
  }
  
  void removeCha() {
    showCha = false;
  }
  
  void displayAttack() {
  }
  
  void displayDefend() {
  }
  
  void displayHeal() {
  }
  
  void displayPrepare() {
  }
  
  void displayCharge() {
  }

  void displayBlood() {
    if (!hideBlood) {
      int size = 30;
      float currentX = x - float(maxBlood)/2 * size + size/2 + adjustX;
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
  void jump(boolean onBeat) {
    // jump on ground then add some big vel, jump in the air then add small vel
    // jump on beat then high, else jump lower
    float vj;
    if (onBeat) {
      vj = v0;
    } else {
      vj = v0/2;  // /2
    }
    
    if (y == y0) {
      vy = vy + vj;
    } else if (y < y0) {
      //vy = vy + vj * 0.5;
    }
  }
  
  //display attack, charge up and dying differently for monster and players
  
  // return inner status
  boolean isAlive() {
    return alive;
  }
  
  String currentState() {
    return state;
  }
  
  void setState(String _state) {
    state = _state;
  }
  
  void hideBlood(boolean hide) {
    hideBlood = hide;
  }
  
  void changeBlood(int num) {
    blood += num;
    blood = constrain(blood, 0, 2*maxBlood);
  }
  
}