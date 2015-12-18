public class Circle{
  int r;
  PVector pos;
  Circle(int _r, int x, int y){
    r = _r;
    pos = new PVector(x,y);
  }
  void step(){
    println("fuckyou");
    if (pos.x > width || pos.y > height){
      pos.set(random(0,width), random(0,height));
    }
  }
  void display(){
    ellipse(pos.x, pos.y, r,r);
    
  }
}

public class runningCircle extends Circle{
  PVector speed;
  runningCircle(int _r, int x, int y, int vx, int vy){
    super(_r,x,y);
    speed = new PVector(vx, vy);
  }
  
  void step(){
    if (pos.x > width || pos.y > height){
      speed.set(random(0,width), random(0,height));
      speed.setMag(10);
    }
     super.step();
     pos.add(speed);
  }
}