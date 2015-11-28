public class Monster extends Creature {
  PImage[] monster;
  Monster(float x, float y, float w, float h, int b) {
    super(x, y, w, h, b);
    monster = new PImage[3];
    monster[0] = loadImage("images/characters/mon0.png");
    monster[1] = loadImage("images/characters/mon1.png");
    monster[2] = loadImage("images/characters/mon2.png");
  }

  void display(int beatNum) {
    display(monster, beatNum);
  }
}