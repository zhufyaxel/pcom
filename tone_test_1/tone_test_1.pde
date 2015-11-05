// Learning Processing
// Daniel Shiffman
// http://www.learningprocessing.com

import processing.sound.*;

class note {
  
}

SqrOsc osc;

Env envelope;

int[] scale = { 
  57, 64, 59, 64, 60, 62, 64, 62, 66, 
  69, 64, 71, 72, 71, 72, 69, 67, 64, 67, 62, 64, 60,
  57, 64, 59, 64, 60, 62, 64, 62, 66, 
  69, 64, 71, 72, 71, 72, 69, 67, 69
}; 


int note = 0;
void setup() {
  size(200, 200);
  osc = new SqrOsc(this);
  envelope = new Env(this);
}

void draw() {
  background(255);
  PVector v = new PVector(); 
  
  //if (frameCount % 60 == 0) {
  //  osc.play(translateMIDI(scale[note]), 1);
  //  println(translateMIDI(scale[note]));
  //  envelope.play(osc, 0.01, 0.5, 1, 0.5);
  //  note = (note + 1) % scale.length;
  //}
}

float translateMIDI(int note) {
  return pow(2, ((note-69)/12.0))*440;
}

void keyPressed() {
    osc.play(translateMIDI(scale[note]), 1);
    println(translateMIDI(scale[note]));
    envelope.play(osc, 0.001, 0.004, 0.3, 0.4);
    note = (note + 1) % scale.length;  
}