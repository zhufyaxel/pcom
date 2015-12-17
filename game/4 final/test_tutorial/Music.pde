// BeatMachine
// Tutorial_Music

class BeatMachine {
  int interval;
  int startTime;
  int currentTime;
  int phase;
  int beatNum;
  int n;  // 0-Boom, 1-Cha, 2-Cha, 3, 4, 5
  boolean flipping;
  
  BeatMachine(int bpm) {
    interval = round(60000.0/bpm); // milliseconds, 60 * 1000 / bpm 
    currentTime = 0;
    phase = 0;
    beatNum = 0;
    n = 0;
    flipping = false;
  }
  
  void setStartTime(int _startTime) {
    startTime = _startTime;
  }
  
  void step() {
    currentTime = millis() - startTime;
    phase = currentTime % interval;
    int newBeatNum = currentTime / interval;
    if (beatNum < newBeatNum) {
      beatNum = newBeatNum;
      flipping = true;
    }
    else {
      flipping = false;
    }
    n = beatNum % 6;
  }
  
  int interval() {
    return interval;
  }
  
  int currentTime() {
    return currentTime;
  }
  
  int phase() {
    return phase;
  }
  
  int beatNum() {
    return beatNum;
  }
  
  int n() {
    return n;
  }
  
  boolean flipping() {
    return flipping;
  }
}