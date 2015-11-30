public class Monster extends Creature {
  PImage[] monster;
  Monster(float x, float y, float w, float h, int b) {
    super(x, y, w, h, b);
    monster = new PImage[3];
    monster[0] = loadImage("images/characters/mon0.png");
    monster[1] = loadImage("images/characters/mon1.png");
    monster[2] = loadImage("images/characters/mon2.png");
  }

  void lifeCycle(int beatNum) {
    if (blood <=0) {
      if (!dying) {
        dying = true;
        beatDying = beatNum;
      }
    }
    if (dying) {
      dying(beatNum);
    }
    if (alive && !dying) {
      display(beatNum);
      move();
    }
  }
  
  void display(int beatNum) {
    display(monster, beatNum);
  }
  
  void dying(int beatNum) {
    blood = 0;
    if (blood < 0) {
      blood = 0;
    }
    
    if (beatNum - beatDying == 0) {  //beatNum - beatDying
      translate(x+w/3, y+h/2);
      rotate(PI/6);
      image(monster[0], -w/3, -h/2, w, h); 
      rotate(-PI/6);
 translate(-(x+w/3),-(y+h/2));
    } else if (beatNum - beatDying == 1) {  //beatNum - beatDying       
      translate(x+w/3, y+h/2);
      rotate(PI/2);
      image(monster[0], -w/3, -h/2, w, h);
      rotate(-PI/2);
      translate(-(x+w/3),-(y+h/2));
    } else if (beatNum - beatDying == 3) {
      translate(x+w/3, y+h/2);
      rotate(PI/2);
      image(monster[0], -w/3, -h/2, w, h);
      rotate(-PI/2);
      translate(-(x+w/3),-(y+h/2));
    } else if (beatNum - beatDying >= 9){
      dying = false;
      alive = false;
    }
  }
}