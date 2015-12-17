class Tutorial_wave_rhythm {
  // sound
  Minim minim;
  AudioPlayer bgm;
  BeatMachine bm;
  
  // input controls
  String input;  //serial input or key input
  
  // background visual
  Tutorial_wave_rhythm_bkg bkg;
  
  //// Characters
  //Defender yue;
  //Warrior zhu;
  //Mage shu;
  
  //// positions and parameters
  //float xYue, yYue, wYue, hYue;
  //float xZhu, yZhu, wZhu, hZhu;
  //float xShu, yShu, wShu, hShu;
  //int bPlayer;
  
  Tutorial_wave_rhythm(int bpm) {
    // global settings
    imageMode(CENTER);
    minim = new Minim(test_tutorial.this);
    bgm = minim.loadFile("music/funny_170.mp3", 512);
    bm = new BeatMachine(bpm);
    bkg = new Tutorial_wave_rhythm_bkg();
  }
}

class Tutorial_wave_rhythm_bkg {
  
}