boolean[] keys;
boolean[] keysShown;
int lastTime, currentTime;

Ball b1, b2, b3;

void setup()
{
  size(500, 500);
  frameRate(60);
  colorMode(HSB, 360, 100, 100);
  noStroke();

  keys=new boolean[3];
  keysShown = new boolean[3];
  for (int i = 0; i < 3; i++) {
    keys[i] = false;
    keysShown[i] = false;
  }
  lastTime = currentTime = millis();

  b1 = new Ball(100, 250, 100, 0);
  b2 = new Ball(250, 250, 100, 120);
  b3 = new Ball(400, 250, 100, 240);
}
void draw() 
{
  background(0);
  b1.jump();
  b1.show();
  b2.jump();
  b2.show();
  b3.jump();
  b3.show();

  // at the end of a period, show the result of all three keys
  currentTime = millis();
  if (currentTime - lastTime >= 500) {
    if (keys[0]) {  
      print("1");
    } else {
      print("0");
    }

    if (keys[1]) {  
      print("1");
    } else {
      print("0");
    }

    if (keys[2]) {  
      print("1");
    } else {
      print("0");
    }

    keys[0] = false;
    keys[1] = false;
    keys[2] = false;

    keysShown[0] = false;
    keysShown[1] = false;
    keysShown[2] = false;

    lastTime = currentTime;
    println(";");
  }
}

void keyPressed()
{
  // when a key is down, jump the ball only once
  // remember whether a, s, d is pressed at least once in a period
  if (key=='a') {
    if (!keysShown[0]) {
      keys[0] = true;
      b1.jumping = true;
      keysShown[0] = true;
    }
  }
  if (key=='s') {
    if (!keysShown[1]) {
      keys[1] = true;
      b2.jumping = true;
      keysShown[1] = true;
    }
  }
  if (key=='d') {
    if (!keysShown[2]) {
      keys[2] = true;
      b3.jumping = true;
      keysShown[2] = true;
    }
  }
}

class Ball {
  int x; 
  float y;
  float y0;
  int size;
  int hue;

  boolean jumping;
  float acc;
  float vy;
  float v0;

  Ball(int _x, float _y, int _size, int _hue) {
    x = _x;
    y0 = y = _y;
    size = _size;
    hue = _hue;

    jumping = false;
    acc = 2;
    v0 = vy = -20;
  }
  void show() {
    fill(hue, 100, 100);
    ellipse(x, y, size, size);
  }
  void jump() {
    if (jumping) {
      vy = vy + acc;
      y = int(y + vy);
    }
    if (vy >= -v0) {
      y = y0;
      vy = v0;
      jumping = false;
    }
  }
}