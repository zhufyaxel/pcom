yuans y;

void setup(){
  size(1000,800);
  y = new yuans(100);
}

void draw(){
  y.display();
}

public class yuan{
  int r;
  PVector pos;
  yuan(int _r, int x, int y){
    r = _r;
    pos = new PVector(x,y);
  }
  
  void display(){
    ellipse(pos.x, pos.y, r,r);
  }
}

public class yuans{
  yuan[] test;
  yuans(int n){
    test = new yuan[n];
    for (int i = 0; i < n; i++){
      test[i] = new yuan(int(random(10,100)),int(random(10,1000)), int(random(10,1000)));
    }
  }
  
  void display(){
    for(int i = 0; i < test.length; i++){
      test[i].display();
    }
  }
}