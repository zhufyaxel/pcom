public class NoteJudge {
  //just create a note and decide whether the key hits it when good
  int tJudge;
  int interval;
  boolean isHit, isGone;  
  
  NoteJudge(int time, int bpm){
    // make some of them global later
    tJudge = time;
    interval = 60 * 1000 / bpm; //milliseconds
    isHit = false; 
    isGone = false;
    }

  void life() {
    int currentTime = millis();
    // a short period after timeJudge, auto miss the note if not hit, and destruct the note
    if (currentTime > tJudge + interval/2) {
      if (!isHit) {
        isHit = true;
        println("miss");
      }
      isGone = true;
    } 
  }
  
  void judge(int time) {
    int tKey = time;
    int difference = abs(tKey - tJudge);
    // only judge half the interval around the tJudge
    if (!isHit) {
      if (difference <= interval/2) {
        // only judge +- 20% of interval so it should be easy
        if (difference <= interval/5) {
          println("good");
          isHit = true;
          //isGone = true;
        }
        else {
          println("miss");
          isHit = true;
          //isGone = true;
        } 
      }
    } else {  //hit twice
      println("miss");
    }
  }
  
}