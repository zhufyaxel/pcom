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

  boolean life() {
    int currentTime = millis();
    boolean missed = false;
    // a short period after timeJudge, auto miss the note if not hit, and destruct the note
    if (currentTime > tJudge + interval/2) {
      if (!isHit) {
        isHit = true;
        println("miss");
        missed = true;
      }
      isGone = true;
    }
    return missed;
  }
  
  boolean judge(int time) {
    int tKey = time;
    int difference = abs(tKey - tJudge);
    boolean goodhit = false;
    // only judge half the interval around the tJudge
    if (!isHit) {
      if (difference <= interval/2) {
        // only judge +- 20% of interval so it should be easy
        if (difference <= 200) {
          println("good");
          goodhit = true;
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
    return (goodhit);
  }
  
}