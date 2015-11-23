
public class Creature {
  // first three elements for the basic Creature information
  PVector pos;
  PVector size;
  int blood;
  int Maxblood;
  boolean alive;
  String state;
  String displaystate;
  String type;
  // ball for its physical form
  FCircle ball;
  // belows are PImage elements
  PImage[] stay;
  PImage[] attack;
  int loopFrame = 10;
  Creature(float x, float y, float w, float h, int b) {
    pos = new PVector(x, y);
    size = new PVector(w, h);
    alive = true;
    Maxblood = blood = b;
    state = "stay";
    displaystate = "stay";
    ball = new FCircle(min(w, h));
    ball.setPosition(x, y);
    ball.setRestitution(0.5);
    ball.setFriction(0.5);
    world.add(ball);
    
    stay = new PImage[0];
    attack = new PImage[0];
    
  }
  
  void addStay(PImage[] _stay){
    stay = _stay;
    for (int i = 0; i < stay.length; i++){
       stay[i].resize(int(size.x),int(size.y)); 
    }
  }
  
  void addAttack(PImage[] _attack){
    attack = _attack;
    for (int i = 0; i < attack.length; i++){
       attack[i].resize(int(size.x),int(size.y)); 
    }
  }

  void step() {
    switch(state) {
    case "attack":
      attack();
      break;
    }

  }

  void display() {
    pos.set(ball.getX(), ball.getY());
    if (blood < 0)
      blood = 0;
    if (blood > Maxblood)
      blood = Maxblood;
    displayBlood();
    switch(displaystate) {
    case "stay":
      displayStay();
      break;
    case "attack":
      displayAttack();
      break;
    }
  }

  int att = 0;
  void attack() {
    displaystate = "attack";
    state = "stay";
  }

  void displayBlood() {
    pushMatrix();
    translate(pos.x - size.x/2, pos.y - size.y/2 - 15);
    colorMode(HSB, 2*PI, 100, 100);
    for (int i = 0; i < blood; i++) {
      color cl = color(map(i, 0, Maxblood, 0, PI), 100, 100);
      strokeWeight(1);
      stroke(0, 0, 0);
      fill(cl);
      rect(size.x/Maxblood * i, 0, size.x/Maxblood, 10);
    }
    popMatrix();
  }
  
  int currentFrameStay = 0;
  void displayStay() {
    pushMatrix();
    translate(pos.x, pos.y);
    int n = stay.length;
    if (frameCount%loopFrame == 0){
      currentFrameStay++;
    }
    if (currentFrameStay >= n){
      currentFrameStay = 0;
    }
    if (n != 0){
      imageMode(CENTER);
      image(stay[currentFrameStay], 0, 0);
      //ellipse(pos.x, pos.y, 100,100);
    }
    popMatrix();
  }
  
  int currentFrameAttack = 0;
  int LoopStay = 5;
  void displayAttack() {
    pushMatrix();
    translate(pos.x, pos.y);
    int n = attack.length;
    if (frameCount%LoopStay == 0){
      currentFrameAttack++;
    }
    if (currentFrameAttack >= n){
      currentFrameAttack = 0;
      displaystate = "stay";
    }
    if (n != 0){
      imageMode(CENTER);
      image(attack[currentFrameAttack], 0, 0);
      //ellipse(pos.x, pos.y, 100,100);
    }
    popMatrix();
  }

  void forward() {
    ball.setVelocity(100, -200);
  }

  void backward() {
    ball.setVelocity(-100, -200);
  }
 
}