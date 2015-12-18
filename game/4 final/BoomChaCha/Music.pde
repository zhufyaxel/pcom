class BGM {
  Minim minim;
  AudioPlayer music;

  // parameters that can be called
  int interval;        // the length of a beat in milliseconds
  int timePlayed;      // time played from music starts in milliseconds, elder currentTime
  int phase;           // the position inside a beat in millliseconds
  int beatsPlayed;     // beats played beatNum
  int n;               // 0-Boom, 1-Cha, 2-Cha, 3, 4, 5
  boolean newBeatIn;   // when a new beat appears  elder flippling

  // inner parameters for calculation
  int musicBeats;   // length of music in beats
  int musicLength;
  int lastPosition;
  int looped;
  
  BGM(String path, int bpm, int _musicBeats) {
    minim = new Minim(BoomChaCha.this);
    music = minim.loadFile(path, 512);
    
    musicBeats = _musicBeats;
    interval = round(60000.0/bpm); // milliseconds, 60 * 1000 / bpm
    musicLength = musicBeats * interval;

    music.setLoopPoints(0, musicLength);  //if 120 beats
    music.loop();
    
    lastPosition = 0;
    looped = 0;
    timePlayed = 0;

    phase = 0;
    beatsPlayed = 0;
    n = 0;
    newBeatIn = false;            
  }
  
  void step() {
    // setting looped times by lastPosition
    if (music.position() < lastPosition) {
      looped += 1;
    }
    lastPosition = music.position();
    
    // getting timePlayed adjusted by looped times
    timePlayed = music.position() + looped * musicLength;
    phase = timePlayed % interval;
    
    // decide whether a new beat is coming, and get new beatsPlayed
    int beatsPlayedNew = timePlayed / interval;
    if (beatsPlayed < beatsPlayedNew) {
      beatsPlayed = beatsPlayedNew;
      newBeatIn = true;
    }
    else {
      newBeatIn = false;
    }
    n = beatsPlayed % 6;
  }
  
  int interval() {
    return interval;
  }
  
  int timePlayed() {
    return timePlayed;
  }
  
  int phase() {
    return phase;
  }
  
  int beatsPlayed() {
    return beatsPlayed;
  }
  
  int n() {
    return n;
  }
  
  boolean newBeatIn() {
    return newBeatIn;
  }
}