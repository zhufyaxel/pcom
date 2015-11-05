import processing.sound.*;

ArrayList<SqrOsc> oscs = new ArrayList<SqrOsc>();
ArrayList<Env> envs = new ArrayList<Env>();

int[] scale = { 
  57, 64, 59, 64, 60, 62, 64, 62, 66, 
  69, 64, 71, 72, 71, 72, 69, 67, 64, 67, 62, 64, 60,
  57, 64, 59, 64, 60, 62, 64, 62, 66, 
  69, 64, 71, 72, 71, 72, 69, 67, 69
}; 

int note = 0;

void setup() {
  size(200,200);
}

void draw() {
}

void keyPressed() {
  oscs.add(new SqrOsc(this));
  envs.add(new Env(this));
  int total = oscs.size();
  SqrOsc sqrPart = oscs.get(total-1);
  sqrPart.play(translateMIDI(scale[note]), 1);
  Env envPart = envs.get(total-1);
  envPart.play(sqrPart, 0.001, 0.04, 0.1, 0.7);   //0.2, 0.3, 1, 0.3     
  note = (note + 1) % scale.length;    
}

float translateMIDI(int note) {
  return pow(2, ((note-69)/12.0))*440;
}