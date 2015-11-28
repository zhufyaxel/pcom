public class Player extends Creature {
  Player(float x, float y, float w, float h, int b) {
    super(x, y, w, h, b);
  }
}

public class Warrior extends Player {
  PImage[] warrior;
  Warrior(float x, float y, float w, float h, int b) {
    super(x, y, w, h, b);
    warrior = new PImage[3];
    warrior[0] = loadImage("images/characters/zhu0.png");
    warrior[1] = loadImage("images/characters/zhu1.png");
    warrior[2] = loadImage("images/characters/zhu2.png");
  }
  
  void display(int beatNum) {
    display(warrior, beatNum);
  }
}

public class Mage extends Player {
  PImage[] mage;
  Mage(float x, float y, float w, float h, int b) {
    super(x, y, w, h, b);
    mage = new PImage[3];
    mage[0] = loadImage("images/characters/wangshu0.png");
    mage[1] = loadImage("images/characters/wangshu1.png");
    mage[2] = loadImage("images/characters/wangshu2.png");
  }

  void display(int beatNum) {
    display(mage, beatNum);
  }
}

public class Defender extends Player {
  PImage[] defender;
  Defender(float x, float y, float w, float h, int b) {
    super(x, y, w, h, b);
    defender = new PImage[3];
    defender[0] = loadImage("images/characters/yue0.png");
    defender[1] = loadImage("images/characters/yue1.png");
    defender[2] = loadImage("images/characters/yue2.png");
  }

  void display(int beatNum) {
    display(defender, beatNum);
  }
}