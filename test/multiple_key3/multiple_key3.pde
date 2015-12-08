// test how can I process the three inputs, when I have multiple values;
// I have three periods:
// 0: three values { 'g', 'b', ' '}
// 1: three values { 'b', 'g', 'g'}
// 2: three values { ' ', 'g', 'g'}

// make it easier....
// 0: three values { 1, 0, 0 }
// 1: three values { 0, 1, 1 }
// 2: three values { 0, 0, 1 }

// nope easier...
// instructions { 'a', 's', ' '}
// bestScore { 2, 1, 0 } // good, bad, miss

//boolean[] keys;
char[] orders;
int[] bestScores;

int lastTime, currentTime;

int beatNum = 0;

Ball b1, b2, b3;

void setup()
{
  size(500, 500);
  frameRate(60);
  colorMode(HSB, 360, 100, 100);
  noStroke();

  //keys=new boolean[3];
  orders = new char[3];
  bestScores = new int[3];
  for (int i = 0; i < 3; i++) {
    //keys[i] = false;
    orders[i] = '0';
    bestScores[i] = 0;
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

  //for (int i = 0; i < 3; i ++) {
  //  if (keys[i]) {
  //    if (!vals[i]) {
  //      vals[i] = true;
  //    }
  //  }
  //}

  // at the end of a period, show the result of all three keys
  currentTime = millis();
  if (currentTime - lastTime >= 500) {
    println(beatNum);
    // show value and clear up
    
    if (beatNum < 3) {
      for (int i = 0; i < 3; i++) {
        print(orders[i]);
      }
      println(";");
    }
    else if (beatNum == 3) {
      if (orders[0] == 'a' ) {
        println("attack");
      }
      if (orders[0] == 's' ) {
        println("heal");
      }
      if (orders[0] == 'd' ) {
        println("defend");
      }
    }
    else if (beatNum == 5) {
      for (int i = 0; i < 3; i++) {
        orders[i] = '0';
      }
    }
    
    lastTime = currentTime;
    
    // periodical
    beatNum ++;
    beatNum = beatNum % 6;
    

  }
}

void keyPressed()
{
  // when a key is down, add upward velocity
  // remember whether a, s, d is pressed at least once in a period
  if (beatNum < 3) {
    if (key=='a') {
      b1.jump();
      if (orders[beatNum] == '0') {
        orders[beatNum] = 'a';
      }
    }
    if (key=='s') {
      b2.jump();
      if (orders[beatNum] == '0') {
        orders[beatNum] = 's';
      }
    }
    if (key=='d') {
      b3.jump();
      if (orders[beatNum] == '0') {
        orders[beatNum] = 'd';
      }
    }
  }
}

//void keyReleased() {
//  if (key=='a') {
//    keys[0] = false;
//  }
//  if (key=='s') {
//    keys[1] = false;
//  }
//  if (key=='d') {
//    keys[2] = false;
//  }
//}