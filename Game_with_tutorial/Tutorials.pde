class Tutorials {
 BGM bgm;
 Tutorial_take_weapon scene1;
 Tutorial_wave_rhythm scene2;
 //Tutorial_attack scene3;
 //Tutorial_heal scene4;
 //Tutorial_defend scene5;
 int stage;
 boolean pass;
  
 Tutorials() {
   bgm = new BGM("music/funny_170.mp3", 170, 120);
   scene1 = new Tutorial_take_weapon(bgm);
   scene2 = new Tutorial_wave_rhythm(bgm);
   stage = 2;
 }
  
 void execute() {
   bgm.step();
   switch(stage) {
     case 1:
       scene1.execute(bgm);
       if (scene1.pass) {
         stage = 2;
         break;
       }
       break;
     case 2:
       scene2.execute(bgm);
       if (scene2.pass) {
         stage = 3;
         break;
       }
       break;      
     case 3:
       background(255,255,0);
       break;
        
     //case 2:
     //  scene2.execute(bgm);
     //  if (scene2.end()) {
     //    scene3 = new Tutorial_attack(bgm);
     //    stage = 3;
     //    break;
     //  }
     //  break;
     //case 3:
     //  scene3.execute(bgm);
     //  if (scene2.end()) {
     //    scene3 = new Tutorial_attack(bgm);
     //    stage = 3;
     //    break;
     //  }
     //  break;
   }
 }
 
 void myKeyInput() {
   switch (stage) {
     case 1:
       scene1.myKeyInput();
       break;
     case 2: 
       scene2.myKeyInput();
       break;
     case 3: 
       
       break;
   }
 }
}