public class Characters {
  Creature Zhu;
  Creature Enemy;

  Characters() {
    Zhu = new Creature(150, 400, 234, 331, 10);
    PImage[] ZhuStay;
    ZhuStay = new PImage[2];
    ZhuStay[0] = loadImage("zhu.png");
    ZhuStay[1] = loadImage("zhu1.png");
    Zhu.addStay(ZhuStay);
    PImage ZhuAtt[] = new PImage[4];
    for (int i = 0; i < ZhuAtt.length; i++) {
      ZhuAtt[i] = loadImage("zhuatt"+i+".png");
    }
    Zhu.addAttack(ZhuAtt);

    Enemy = new Creature(width - 200, 400, 234, 331, 5);
    PImage[] monststay = new PImage[2];
    for (int i = 0; i < monststay.length; i++) {
      monststay[i] = loadImage("monststay"+i+".png");
    }
    Enemy.addStay(monststay);
  }

  void display() {
    Zhu.display();
    Enemy.display();
  }
  int b = 0;
  void step() {
    println("step, state", Zhu.state);
    if (Zhu.state == "attack" && abs(Zhu.pos.x - Enemy.pos.x) < 400) {
      Enemy.blood--;
    }
    Zhu.step();
    Enemy.step();


    int i = int(random(0, 2));
    println("mode", i);
    if (i == 0) {
      Enemy.forward();
      println("Ene forward");
    }
    if (i == 1) {
      Enemy.backward();
      println("Ene backward");
    }
    b++;
    if (b >=4 ) {
      Enemy.blood++;
      b = 0;
    }
  }
}