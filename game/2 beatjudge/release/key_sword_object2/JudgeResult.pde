class JudgeResult {
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
      fill(255);
      if (isGood) {
        text("Good", 250, 300);
      } else {
        text("Missed", 250, 300);
      }
    }
  }
}