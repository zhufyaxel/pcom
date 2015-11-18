class Note {
  //create a new falling Note and show it 1s before you should hit it
  int tShow, tJudge;  
  boolean isHit, enShow, isGone;  
  int x, y, ySpeed;
  
  Note(int time, int speed){
    // make some of them global later
    isHit = false; 
    enShow = false;
    isGone = false;
    x = width / 2;
    y = 0;
    ySpeed = speed;  // px per frame
    tJudge = time;
    int tMove = height * 1000 /(ySpeed * 60); // 60 frames = 1 sec = 1000 milliseconds
    tShow = tJudge - tMove;  

  }

  void life() {
    int currentTime = millis();
    // at timeShow, enable the showing of note
    // a short period after timeJudge, auto miss the note if not hit, and destruct the note
    if (!enShow) {
      if (currentTime >= tShow) {
        enShow = true;
      }
    } 
    if (currentTime > tJudge + 100) {
      if (!isHit) {
        isHit = true;
        println("miss");
      }
      enShow = false;
      isGone = true;
    } 
  }

  void display() {
    if (enShow) {  //buffer this later
      rect(x, y, 100, 20);
    }
  }
  
  void move() {
    if (enShow) {
      y = y + ySpeed;  // 10px per frame, 600px per second
    }
  }
  
  void judge(int time) {
    int tKey = time;
    // only judge 100ms before tJudge
    if (tKey >= tJudge - 200) {
      if (tKey <= tJudge - 100) {
        isHit = true;
        println("bad");
        enShow = false;
        //isGone = true;
      }
      else if (tKey <= tJudge - 50) {
       isHit = true;
       println("good");
       enShow = false;
       //isGone = true;
      } 
      else if (tKey <= tJudge + 50) {
       isHit = true;
       println("great!");
       enShow = false;
       //isGone = true;
      }
      else if (tKey <= tJudge + 100) {
        isHit = true;
        println("good");
        enShow = false;
        //isGone = true;
      } else {
        //auto miss
      }
    }
  }
  
}