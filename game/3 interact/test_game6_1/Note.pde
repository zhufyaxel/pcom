//I just wanted to mute it before it reaches the end.
class Note {
  boolean isPlaying;
  SoundFile sound;
  int timeStart;
  int duration = 2000;
  
  Note (String file) {
    sound = new SoundFile(test_game6_1.this, file);
    sound.amp(0.1);
    sound.play();
    isPlaying = true;
    timeStart = millis();
    duration = 1800;
  }
  
  void life() {
    if (millis() - timeStart > duration) {
      silence();
    }
  }
  
  void silence() {
    sound.amp(0);
    sound.stop();
    isPlaying = false;
  }
}