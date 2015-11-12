void draw() {
  background(0);
  colorMode(HSB,360,100,100,1);
  
  //initialize sawtooth change
  int m = millis();
  int amp = 1;
  int bpm = 100;
  int period = 60*1000/bpm;  //in miliseconds
  
  float alpha = sawTooth(m, amp, period);
  
  stroke(0,0,100,alpha);
  if (alpha > 0.8) {
    fill(0,100,100,alpha);
  } else {
    fill(0,0,100,alpha);
  }    
  rect(25, 25, 50, 50);
  //println("last millis", millis());
}

float sawTooth(int time, int amp, int period) {
  float y;
  int phase = time % period;
  if (phase <= period/2) {
    //y = 2.0*amp*phase/period;
    y = 0;  //upside deleted
  } else {
    y = 2.0*amp - 2.0*amp*phase/period;
  }
  return y;
}

void judge(int time, int period) {
  int phase = time % period;
  int diff = abs(phase - period/2);
  if (diff <= 0.3 * period) {
    println("Great");
  } else if (diff < 0.4 * period) {
    println("Good");
  } else {
    println("Bad");
  }
}

void keyPressed() {
  int m = millis();
  println("key",m);
  judge(m,600);
}