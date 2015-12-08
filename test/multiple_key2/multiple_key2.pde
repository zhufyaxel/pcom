boolean[] keys;
boolean[] vals;
int lastTime, currentTime;

Ball b1, b2, b3;

void setup()
{
  size(500, 500);
  frameRate(60);
  colorMode(HSB, 360, 100, 100);
  noStroke();

  keys=new boolean[3];
  vals = new boolean[3];
  for (int i = 0; i < 3; i++) {
    keys[i] = false;
    vals[i] = false;
  }
  lastTime = currentTime = millis();

  b1 = new Ball(100, 250, 100, 0);
  b2 = new Ball(250, 250, 100, 120);
  b3 = new Ball(400, 250, 100, 240);
}
void draw() 
{
  background(0);
  b1.show();
  b1.move();
  b2.show();
  b2.move();
  b3.show();
  b3.move();

  // at the end of a period, show the result of all three keys
  currentTime = millis();
  if (currentTime - lastTime >= 500) {
    if (vals[0]) {  
      print("1");
    } else {
      print("0");
    }

    if (vals[1]) {  
      print("1");
    } else {
      print("0");
    }

    if (vals[2]) {  
      print("1");
    } else {
      print("0");
    }

    vals[0] = false;
    vals[1] = false;
    vals[2] = false;

    println(";");
    lastTime = currentTime;
  }
}

void keyPressed()
{
  // when a key is down, add upward velocity
  // remember whether a, s, d is vals at least once in a period
  if (key=='a') {
    keys[0] = true;
    b1.jump();
    if (!vals[0]) {
      vals[0] = true;
    }
  }
  if (key=='s') {
    keys[1] = true;
    b2.jump();
    if (!vals[1]) {
      vals[1] = true;
    }
  }
  if (key=='d') {
    keys[2] = true;
    b3.jump();
    if (!vals[2]) {
      vals[2] = true;
    }
  }
}

void keyReleased() {
  if (key=='a') {
    keys[0] = false;
  }
  if (key=='s') {
    keys[1] = false;
  }
  if (key=='d') {
    keys[2] = false;
  }
}