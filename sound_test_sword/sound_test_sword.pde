import processing.sound.*;

SoundFile[] swords = new SoundFile[5];

void swordSound() {
  int index = floor(random(5));
  swords[index].play();
}

void setup() {
  size(640, 360);
  background(255);
    
  // loading sound file
  swords[0] = new SoundFile(this, "sword_swipe.mp3");
  swords[1] = new SoundFile(this, "sword_strike.mp3");
  swords[2] = new SoundFile(this, "swords_x_2_hit_001.mp3");
  swords[3] = new SoundFile(this, "swords_x_2_hit_002.mp3");
  swords[4] = new SoundFile(this, "swords_x_2_hit_scrape_004.mp3");
}      

void draw() {
}

void keyPressed() {
  swordSound();
}