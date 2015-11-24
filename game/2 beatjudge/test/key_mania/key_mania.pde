// I need an array of time of notes
// and an array to store those living notes
// and maybe a pointer that point to the current note, so I can match this to the key event.

import processing.sound.*;

SoundFile song;

ArrayList<Note> notes = new ArrayList<Note>();
// most basically, just first create an integer array and make sure the list 'notes' has something to do, unless all the notes are played
int[] noteTimes = { 4, 5, 6, 7, 8, 9, 10,  
                    12, 13, 14, 15, 16, 17, 18};
                    //twinkle stars

void setup() {
  size(600,600);
  rectMode(CENTER);
  int speed = 10;   //global y speed;
  int bpm = 90;
  int interval = 60 * 1000 / bpm;
  song = new SoundFile(this, "twinkle star.mp3");
  int currentTime = millis();
  song.play();
  for (int i = 0; i < noteTimes.length; i++) {
    notes.add(new Note(noteTimes[i] * interval + currentTime, speed));
  }
  fill(255);
}

void draw() {
  background(0);
  for (int i = 0; i < notes.size(); i++) {
    Note part = notes.get(i);
    part.life();
    part.display();
    part.move();
    // if end then delete
    if (part.isGone) {
      notes.remove(i);
    }
  }
}

void keyPressed() {
  background(255,255,0);
  int currentTime = millis();
  if (notes.size() > 0) {    //in case there isn't any note to play
    Note part = notes.get(0);
    part.judge(currentTime);
  }
}