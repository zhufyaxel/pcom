//----------start-----------

import processing.sound.*;

ArrayList<SinOsc> oscs = new ArrayList<SinOsc>();
ArrayList<Env> envs = new ArrayList<Env>();

//int[] scale = { // frandre
//  57, 64, 59, 64, 60, 62, 64, 62, 66, 
//  69, 64, 71, 72, 71, 72, 69, 67, 64, 67, 62, 64, 60,
//  57, 64, 59, 64, 60, 62, 64, 62, 66, 
//  69, 64, 71, 72, 71, 72, 69, 67, 69
//}; 

int[] scale = {   //melody
 76, 79, 88, 86, 76, 84, 76, 79, 84, 83, 
 74, 77, 81, 89, 88, 76, 86, 86, 84, 81, 79,  
 72, 76, 79, 88, 86, 76, 84, 76, 79, 84, 83,  81, 
 79, 84, 89, 88, 84, 86, 81, 83, 84, 0, 0, 0,
}; 

int note = 0;

void magicSound() {
  oscs.add(new SinOsc(this));
  envs.add(new Env(this));
  int total = oscs.size();
  SinOsc sinPart = oscs.get(total-1);
  sinPart.play(translateMIDI(scale[note]), 1);
  Env envPart = envs.get(total-1);
  envPart.play(sinPart, 0.001, 0.04, 0.1, 0.7);   //0.2, 0.3, 1, 0.3     
  note = (note + 1) % scale.length;    
}

float translateMIDI(int note) {
  return pow(2, ((note-69)/12.0))*440;
}

//--------end ----------


void setup() {
  size(200,200);
}

void draw() {
}

void keyPressed() {
  magicSound();
}