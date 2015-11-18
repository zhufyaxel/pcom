class BeatGame {
  ArrayList<NoteJudge> notes;
  ArrayList<JudgeResult> results;
  ArrayList<Beat> beats;
  
  int bpm;
  int interval;
  
  int index;
  int state; //state 0 - waiting for the first hit
             //state 1, 2 waiting for the next two assist
             //state 3 execution for three bars and then wait
  //int latency;
  
  boolean showNote;

  BeatGame(int _bpm) {
    rectMode(CENTER);
    
    bpm = _bpm;
    interval = 60 * 1000 / bpm;
    index = 0;
    state = 0;
    
    notes = new ArrayList<NoteJudge>();
    notes.add(new NoteJudge(index * interval, bpm));
    notes.add(new NoteJudge((index+1) * interval, bpm));
    
    results = new ArrayList<JudgeResult>();
    
    beats = new ArrayList<Beat>();
    
    showNote = true;
  }

  void step() {
    NoteJudge nPart = notes.get(0);
    
    if (millis() > nPart.tJudge - 16 ) {
      beats.add(new Beat(nPart.tJudge));
      showNote = false;
    }
    
    if (beats.size() > 0) {
      Beat bPart = beats.get(0);
      bPart.show();
      bPart.update();
      if (!bPart.alive) {
        beats.remove(0);
      }
    }
    
    boolean missed = nPart.life();
    if (missed) {
      results.add(new JudgeResult(!missed));
    }
    
    for (int i = 0; i < results.size(); i++) {
      JudgeResult jPart = results.get(i);
      jPart.life();
      jPart.show();
    }
    
    if (nPart.isGone) {
        notes.remove(0);
        index++;
        notes.add(new NoteJudge((index+1) * interval, bpm));
        
        showNote = true;
    }
  }
  
  void keyevent(int currentTime) {
    if (notes.size() > 0) {
      NoteJudge part = notes.get(0);
      boolean isGood = part.judge(currentTime);  
      results.add(new JudgeResult(isGood));
    }  
  }
}