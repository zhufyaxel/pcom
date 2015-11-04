//import processing.sound.*;

//public class Tonenode{
//  SinOsc osc;
//  Env envelope;

//  int[] scale = { 60, 62, 64, 65, 67, 69, 71, 72}; 
//  int note;
  
//  Tonenode(){
//    osc = new SinOsc(this);
//    envelope = new Env(this);
//    note = int(random(0,7));
//  }
  
//  void display(){
//    osc.play(translateMIDI(scale[note]), 1);
//    envelope.play(osc, 0.01, 0.5, 1, 0.5);
//    note = (note + 1) % scale.length;
//  }
//}

//float translateMIDI(int note) {
//  return pow(2, ((note-69)/12.0))*440;
//}