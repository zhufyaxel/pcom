BeatJudge bj = new BeatJudge(100);

void setup () {
  colorMode(HSB, 360, 100, 100, 100);
}


void draw() {
  background(0);
  bj.visualize();
}


void keyPressed() {
  int time = millis();
  println("time", time);
  bj.judge(time);
}