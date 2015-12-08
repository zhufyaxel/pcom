class Ball {
  int x; 
  float y;
  int size;
  int hue;

  float y0;
  float acc;
  float vy;
  float v0;

  Ball(int _x, float _y, int _size, int _hue) {
    x = _x;
    y0 = y = _y;
    size = _size;
    hue = _hue;

    acc = 2;
    vy = 0;
    v0 = -20;
  }
  void show() {
    fill(hue, 100, 100);
    ellipse(x, y, size, size);
  }
  void move() {
    // with initial velocity or on the air it will move
    if (y < y0 ||vy != 0) {        
      y = int(y + vy);
      vy = vy + acc;
    }
    // hit the ground and immediately stop
    if (y >= y0 && vy != 0) {  // y >= y0
      y = y0;
      vy = 0;
    }
  }
  void jump() {
    // jump on ground then add some big vel, jump in the air then add small vel
    if (y == y0) {
      vy = vy + v0;
    } else if (y < y0) {
      vy = vy + v0 * 0.7;
    }
  }
  
}