// I need an array of time of notes
// and an array to store those living notes
// and maybe a pointer that point to the current note, so I can match this to the key event.

BeatGame mygame;

void setup() {
  size(600,600);
  int bpm = 90;
  mygame = new BeatGame(bpm);
}

void draw() {
  background(0,0,0,0.05);
  mygame.step();
}

void keyPressed() {
  int currentTime = millis();
  mygame.keyevent(currentTime);
}

//BeatGame mygame;

//boolean startCombo = false;

//int keyPressedTimes = 0;

//void setup() {
//  size(700,600);
//  rectMode(CENTER);
//  int speed = 15;   //global x speed; better be a divisor of width
//  int bpm = 100;
//  int interval = 60 * 1000 / bpm;
//  int latency = millis();
//  for (int i = 0; i < noteTimes.length; i++) {
//    noteTimes[i] = i + 3;
//    notes.add(new Note(noteTimes[i] * interval + latency, speed));
//  }
//  stroke(255);
//  // latency : println(millis()); around 300 ms in setup
//}

//void draw() {
//  background(0);
//  fill(255);
//  line(100, 0, 100, height);
//  for (int i = 0; i < notes.size(); i++) {
//    Note part = notes.get(i);
//    part.life(startCombo);
//    part.display();
//    part.move();
//    // if end then delete
//    if (part.isGone) {
//      notes.remove(i);
//    }
//    if (startCombo) {
//      if (part.stopCombo) {
//        startCombo = false;
//        part.stopCombo = false;
//      }
//    }
//  }
//}

//void keyPressed() {
//  background(255,255,0);
//  int currentTime = millis();
//  keyPressedTimes ++;
//  println("keys:", keyPressedTimes);
//  if (notes.size() > 0) {  //avoid error when empty
//    Note part = notes.get(0);
//    part.judge(currentTime);
//  }
//}