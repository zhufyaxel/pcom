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