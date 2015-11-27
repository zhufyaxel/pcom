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