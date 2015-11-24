public class BeatGame {

  //character part
  Characters c;

  //store a bunch of note judge according to bpm
  ArrayList<NoteJudge> notes;
  //store a bunch of visual guiding beats according to bpm
  ArrayList<Beat> beats;
  //store the results text
  ArrayList<JudgeResult> results;

  StringList orders;
  int power;

  int bpm;
  int interval;

  //current index of this note judge
  int index; 
  
  //int state; //state 0 - waiting for the first hit
  ////state 1, 2 waiting for the next two assist
  ////state 3 execution for three bars and then wait
  int latency;

  boolean showNote;

  BeatGame(int _bpm) {
    rectMode(CENTER);

    //character
    c = new Characters();

    bpm = _bpm;
    interval = 60 * 1000 / bpm;
    latency = millis();
    index = 0;
    //state = 0;

    notes = new ArrayList<NoteJudge>();
    notes.add(new NoteJudge(index * interval + latency, bpm));
    notes.add(new NoteJudge((index+1) * interval + latency, bpm));

    results = new ArrayList<JudgeResult>();

    beats = new ArrayList<Beat>();
    
    orders = new StringList();
    power = 0;

    showNote = true;
  }

  void step() {
    // always blink at sixth
    if (index%6 == 0) {
      background(255,255,0);
      if (orders.size() > 0) {
        if (orders.get(0) == "a") {
           c.Zhu.state = "attack";
           c.Zhu.setPower(power);
         }
         power = 0;
         orders.clear();
      }
    }
    
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
      JudgeResult jPart = new JudgeResult(!missed);
      jPart.show();
      results.add(jPart);
    }

    for (int i = 0; i < results.size(); i++) {
      JudgeResult jPart = results.get(i);
      jPart.life();
      jPart.show();
    }

    if (nPart.isGone) {
      notes.remove(0);
      index++;
      notes.add(new NoteJudge((index+1) * interval + latency, bpm));

      showNote = true;
    }
  }

  void keyevent(int currentTime) {
    if (notes.size() > 0) {
      NoteJudge part = notes.get(0);
      boolean isGood = part.judge(currentTime);
      if (isGood) {
        if (power <3) {
          power++;
        }
      }
      
      if (key == 'a' || key == 'A') {
        orders.append("a");
      }
      if (key == 's' || key == 'S') {
        orders.append("s");
      }
      if (key == 'd' || key == 'D') {
        orders.append("d");
      }
      
      //if (isGood) {
        
      //  //if (key == 'd' || key == 'D')
      //  //  c.Zhu.forward();
      //  //if (key == 'a' || key == 'A')
      //  //  c.Zhu.backward();
      //  //if (key == 'z' || key == 'Z')
      //  //  c.Zhu.state = "attack";
      //}
      
      //if (orders.size() == 3) {
      //  if (orders.get(0) == "a") {
      //    c.Zhu.state = "attack";
      //    c.Zhu.setPower(power);
      //  }
      //  background(255,255,0);
      //  power = 0;
      //  orders.clear();
      //}   
      
      JudgeResult jPart = new JudgeResult(isGood);
      jPart.show();
      results.add(jPart);
    }
  }
}