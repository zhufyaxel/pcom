public class ManiaGame {
  SoundFile song;
  ArrayList<Note> notes;
  int[] noteTimes = new int[14];
  int speed;   //global y speed;
  int bpm;
  int interval;
  
  ManiaGame () {
     rectMode(CENTER);
     fill(255);
     
     notes = new ArrayList<Note>();
     speed = 10;   //global y speed;
     bpm = 90;
     interval = 60 * 1000 / bpm;
     //twinkle stars
     for (int i = 0; i < 7; i++) {
       noteTimes[i] = i+4;
     }
     for (int i = 7; i < 14; i++) {
       noteTimes[i] = i+5;
     }       
     
     //twinkle stars music
     song = new SoundFile(key_mania_object.this, "twinkle star.mp3");  // this this!!!! parent...
     
     //initializing time
     int latency = millis();
     song.play();
     
     //add new notes and make for delay
     for (int i = 0; i < noteTimes.length; i++) {
       notes.add(new Note(noteTimes[i] * interval + latency, speed));
     } 
  }
  
  void step() {
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
  
  void keyevent (int currentTime) {
    if (notes.size() > 0) {    //in case there isn't any note to play
      Note part = notes.get(0);
      part.judge(currentTime);
    }
  }
}