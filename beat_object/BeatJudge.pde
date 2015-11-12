class BeatJudge {
  int bpm, period;

  BeatJudge (int bpm) {
    period = 60 * 1000 / bpm; // in miliseconds     
  }
  
  void visualize() {
    //a square appear in the center, first red, then white
    int amp = 100;
    int saturation;
    float alpha;
    
    int time = millis();
    int phase = time % period;  

    //calculate alpha
    if (phase <= period/2) {
      alpha = 0;
      saturation = 0;
    } else {
      alpha = 2.0 * amp - 2.0 * amp * phase / period;
      if (phase < 3 * period / 5) {
        saturation = 100;
      } else {
        saturation = 0;
      }
    }

    //draw the square
    fill(0, saturation, 100, alpha);
    rect(25, 25, 50, 50);
  }
  
  void judge(int time) {
    int phase = time % period;
    int diff = abs(phase - period/2);
    if (diff <= 0.2 * period) {  // this feels good. or try great 0.1, good 0.3, else miss
      println("Great");
    } else {
      println("miss");
    }
  }
}