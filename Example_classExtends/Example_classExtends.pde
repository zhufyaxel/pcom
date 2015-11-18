runningCircle exa;
void setup(){
  size(1000,800);
  exa = new runningCircle(10,100,100,5,5);
}

void draw(){
  background(0);
  exa.step();
  exa.display();
}