//tutorial_wave_rhythm

import processing.serial.*;
import ddf.minim.*;

Tutorial_wave_rhythm t2;

void setup() {
  size(1024, 768, P2D);
  int bpm = 170;
  t2 = new Tutorial_wave_rhythm(bpm);
}

void draw() {
  t2.execute();
}

void keyPressed() {
  t2.myKeyPressed();
}