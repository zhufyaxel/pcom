class Tutorials {
  BGM bgm;
  Tutorial_take_weapon scene1;
  Tutorial_wave_rhythm scene2;
  Tutorial_attack scene3;
  Tutorial_heal scene4;
  Tutorial_defend scene5;
  int scene;
  int nextScene;  //for switching
  int beatPass;
  int beatsSwitching;
  boolean pass;

  Tutorials(BGM _bgm) {
    bgm = _bgm;
    scene1 = new Tutorial_take_weapon(bgm);
    scene2 = new Tutorial_wave_rhythm(bgm);
    scene3 = new Tutorial_attack(bgm);
    scene4 = new Tutorial_heal(bgm);
    scene5 = new Tutorial_defend(bgm);
    scene = 1;
    nextScene = 0;
    beatsSwitching = 0;
    pass = false;
  }

  void execute() {
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
        scene3.setStart(bgm.beatsPlayed());
        break;
      } else {
        scene2.execute();
        break;
      }
    case 3:
      if (scene3.pass) {
        beatPass = bgm.beatsPlayed();
        scene = 0;
        nextScene = 4;
        scene4.setStart(bgm.beatsPlayed());
        break;
      } else {
        scene3.execute();
        break;
      }
    case 4:
      if (scene4.pass) {
        beatPass = bgm.beatsPlayed();
        scene = 0;
        nextScene = 5;
        scene5.setStart(bgm.beatsPlayed());
        break;
      } else {
        scene4.execute();
        break;
      }
    case 5:
      if (scene5.pass) {
        beatPass = bgm.beatsPlayed();
        pass = true;  // Tutorial ended
        scene = 0;
        nextScene = 0;
        break;
      } else {
        scene5.execute();
        break;
      }
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
    case 4: 
      scene4.myKeyInput();
      break;
    case 5: 
      scene5.myKeyInput();
      break;
    }
  }
  
  void myPortInput(String input) {
   switch (scene) {
    case 1:
      scene1.myPortInput(input);
      break;
    case 2: 
      scene2.myPortInput(input);
      break;
    case 3: 
      scene3.myPortInput(input);
      break;
    case 4: 
      scene4.myPortInput(input);
      break;
    case 5: 
      scene5.myPortInput(input);
      break;
    }
  }
}