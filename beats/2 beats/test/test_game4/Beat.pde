public class Beat {
  boolean alive;
  int tBirth;
  int life;
  int rectStroke;
  
  Beat(int time) {
    tBirth = time;
    alive = true;
    life = 20;
    rectStroke = 255;
  }
  
  void show() {
    stroke(rectStroke);
    strokeWeight(10);
    noFill();
    rect(width/2,height/2,width,height);
  }
  
  void update() {
    int tNow = millis();
    int tDiff = tNow - tBirth;
    if (tDiff > life) {
      alive = false;
    } else {
      rectStroke = - 255 * tDiff / life + 255;
    }
  }
}