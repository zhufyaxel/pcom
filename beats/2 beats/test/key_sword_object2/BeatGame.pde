class BeatGame {
  ArrayList<NoteJudge> notes;
  int bpm;
  int interval;
  int index;
  int state; //state 0 - waiting for the first hit
             //state 1, 2 waiting for the next two assist
             //state 3 execution for three bars and then wait
  //int latency;

  BeatGame(int _bpm) {
    bpm = _bpm;
    interval = 60 * 1000 / bpm;
    index = 0;
    state = 0;
    notes = new ArrayList<NoteJudge>();
    notes.add(new NoteJudge(index * interval, bpm));
    notes.add(new NoteJudge((index+1) * interval, bpm));
  }

  void step() {
    NoteJudge part = notes.get(0);
    part.life();
    if (part.isGone) {
        println(index);
        notes.remove(0);
        index++;
        notes.add(new NoteJudge((index+1) * interval, bpm));
    }
  }
  
  void keyevent(int currentTime) {
    if (notes.size() > 0) {
      NoteJudge part = notes.get(0);
      part.judge(currentTime);  
    }  
  }
}