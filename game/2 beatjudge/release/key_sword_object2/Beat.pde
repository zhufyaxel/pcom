class Beat {
  boolean alive;
  int tBirth;
  int life;
  int rectColor;
  
  Beat(int time) {
    tBirth = time;
    alive = true;
    life = 20;
    rectColor = 255;
  }
  
  void show() {
    fill(rectColor);
    rect(300,300,600,600);
    fill(0);
    rect(300,300,590,590);
  }
  
  void update() {
    int tNow = millis();
    int tDiff = tNow - tBirth;
    if (tDiff > life) {
      alive = false;
    } else {
      rectColor = - 255 * tDiff / life + 255;
    }
  }
}