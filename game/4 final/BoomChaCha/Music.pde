class BeatMachine {
  int interval;
  int startTime;
  int currentTime;
  int phase;
  int beatNum;
  int n;  // 0-Boom, 1-Cha, 2-Cha, 3, 4, 5
  boolean flipping;
  
  BeatMachine(int _interval, int _startTime) {
    interval = _interval;
    startTime = _startTime;
    currentTime = 0;
    phase = 0;
    beatNum = 0;
    n = 0;
    flipping = false;
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