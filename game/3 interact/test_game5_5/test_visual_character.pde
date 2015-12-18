class tempatt {
  boolean attstate = false;
  int i = 0;
  int x = 0;
  int y = 0;
  
  tempatt(int _x, int _y){
    x = _x;
    y = _y;
  }
  void att() {
    i ++;
    color cl = color(255, 0, 0);
    fill(cl);
    noStroke();
    if (attstate) {
      ellipse(x, y, 200+random(10, 300), 200+random(10, 300));
    }
    if (i > 30) {
      i = 0;
      attstate = false;
    }
    if (attstate == false){
      i = 0;
    }
  }
}