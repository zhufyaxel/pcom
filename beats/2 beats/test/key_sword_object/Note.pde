class Note {
  //create a new falling Note and show it 1s before you should hit it
  int tShow, tJudge;  
  boolean isHit, enShow, isGone;  
  boolean stopCombo;  //hey I'm here to stop you!!!!
  int x, y, xSpeed;

  Note(int time, int speed) {
    // make some of them global later
    isHit = false; 
    enShow = false;
    isGone = false;
    y = height / 2;
    x = width;
    xSpeed = speed;  // px per frame
    tJudge = time;
    int tMove = (width - 100) * 1000 /(xSpeed * 60); // 60 frames = 1 sec = 1000 milliseconds
    tShow = tJudge - tMove;
  }

  void life(boolean startCombo) {
    int currentTime = millis();
    // at timeShow, enable the showing of note
    // a short period after timeJudge, auto miss the note if not hit, and destruct the note
    if (!enShow) {
      if (currentTime >= tShow) {
        enShow = true;
      }
    } 
    if (currentTime > tJudge + 100) {
      //if !start Combo then no miss
      if (startCombo) {  
        if (!isHit) {
          isHit = true;
          println("missed!");
          stopCombo = true;
        }
      }
      enShow = false;
      isGone = true;
    }
  }

  void display() {
    if (enShow) {  //buffer this later
      rect(x, y, 20, 200);
    }
  }

  void move() {
    if (enShow) {
      x = x - xSpeed;  // 10px per frame, 600px per second
    }
  }

  void judge(int time) {
    int tKey = time;
    // if on pace print good, else missed
    if (tKey >= tJudge - 100 && tKey <= tJudge + 100) {
      isHit = true;
      println("good");
      startCombo = true;
      isGone = true;
    } else {
      //isHit = true;
      println("missed!");
      stopCombo = true;
      //isGone = true;
    }
  }
}