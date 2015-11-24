public class JudgeResult {
  boolean alive;
  boolean isGood;
  int tBirth;
  int life;

  JudgeResult(boolean _isGood) {
    tBirth = millis();
    life = 200;
    alive = true;
    isGood = _isGood;
  }

  void life() {
    if (millis() > tBirth + life) {
      alive = false;
    }
  }

  void show() {
    if (alive) {
      textSize(32);
      fill(0);
      if (isGood) {
        text("Good", width/2 - 50, height/2);
      } else {
        text("Missed", width/2 - 50, height/2);
      }
    }
  }
}