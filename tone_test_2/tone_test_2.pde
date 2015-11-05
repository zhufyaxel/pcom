// Learning Processing
// Daniel Shiffman
// http://www.learningprocessing.com

import processing.sound.*;

class Note {
  SqrOsc osc = new SqrOsc(this);
  Env envelope = new Env(this);  
  
  Note() {
  }
  
  void play(float freq) {
    osc.play(freq, 1);
    println(freq);
    envelope.play(osc, 0.001, 0.004, 0.3, 0.4);    
  }
}

Note myNote;

int[] scale = { 
  57, 64, 59, 64, 60, 62, 64, 62, 66, 
  69, 64, 71, 72, 71, 72, 69, 67, 64, 67, 62, 64, 60,
  57, 64, 59, 64, 60, 62, 64, 62, 66, 
  69, 64, 71, 72, 71, 72, 69, 67, 69
}; 


int note = 0;


void setup() {
  size(200, 200);
  myNote = new Note();
}

void draw() {
  background(255);
  PVector v = new PVector();   
}

float translateMIDI(int note) {
  return pow(2, ((note-69)/12.0))*440;
}

void keyPressed() {
  myNote.play(translateMIDI(scale[note]));  
  note = (note + 1) % scale.length;  
}