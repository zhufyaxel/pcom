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