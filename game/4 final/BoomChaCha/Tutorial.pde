class Tutorials {
  BGM bgm;
  Tutorial_take_weapon scene1;
  Tutorial_wave_rhythm scene2;
  Tutorial_attack scene3;
  //Tutorial_heal scene4;
  //Tutorial_defend scene5;
  int scene;
  int nextScene;  //for switching
  int beatPass;
  int beatsSwitching;
  boolean pass;

  Tutorials() {
    bgm = new BGM("music/funny_170.mp3", 170, 120);
    scene1 = new Tutorial_take_weapon(bgm);
    scene2 = new Tutorial_wave_rhythm(bgm);
    scene3 = new Tutorial_attack(bgm);
    scene = 1;
    nextScene = 0;
    beatsSwitching = 0;
    pass = false;
  }

  void execute() {
    bgm.step();
    switch(scene) {
    case 0: 
      if (bgm.beatsPlayed - beatPass >= beatsSwitching) {
        scene = nextScene;
        break;
      } else {
        background(255); 
        break;
      }
    case 1:
      if (scene1.pass) {
        beatPass = bgm.beatsPlayed();
        scene = 0;
        nextScene = 2;
        break;
      } else {
        scene1.execute();   
        break;
      }
    case 2:
      if (scene2.pass) {
        beatPass = bgm.beatsPlayed();
        scene = 0;
        nextScene = 3;
        scene3.setStart(bgm.beatsPlayed() + 12);
        break;
      } else {
        scene2.execute();
        break;
      }
    case 3:
      scene3.execute();
      break;
    }
  }

  void myKeyInput() {
    switch (scene) {
    case 1:
      scene1.myKeyInput();
      break;
    case 2: 
      scene2.myKeyInput();
      break;
    case 3: 
      scene3.myKeyInput();
      break;
    }
  }
  
  //void myPortInput() {
  //  switch (scene) {
  //  case 1:
  //    scene1.myPortInput();
  //    break;
  //  case 2: 
  //    scene2.myPortInput();
  //    break;
  //  case 3: 
  //    scene3.myPortInput();
  //    break;
  //  }
  //}
}

void myPortInput() {
}