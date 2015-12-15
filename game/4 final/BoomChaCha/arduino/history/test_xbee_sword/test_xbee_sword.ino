int x0, y0, z0;
int a0;
int n = 10;
int x[10];
int y[10];
int z[10];
int a[10];
int fcount;
int tempcount = 0;

boolean aup;
void setup() {
  for (int i = 8; i < 12; i++) {
    pinMode(i, OUTPUT);
  }
  x0 = analogRead(A5);
  y0 = analogRead(A4);
  z0 = analogRead(A3);
  a0 = sqrt(x0 * x0 + y0 * y0);
  fcount = 0;
  for (int i = 0; i < n; i++) {
    x[i] = 0;
    y[i] = 0;
    z[i] = 0;
    a[i] = 0;
  }

  aup = false;
  Serial.begin(9600);
}

void loop() {
  int x_read = analogRead(A5);
  int y_read = analogRead(A4);
  int z_read = analogRead(A3);
  int x_a = x_read / 10;
  int y_a = y_read / 10;
  int a_read = sqrt(x_a * x_a + y_a * y_a);

  x[fcount] = x_read;
  y[fcount] = y_read;
  z[fcount] = z_read;
  a[fcount] = a_read;

  /////add judge among here
  
  int acount = 0;
  boolean swipe = false;
  for (int i = 1; i < n; i++) {
    if (a[i] - a[0] > 1) {
      acount ++;
    }
  }
  if (acount > 6) {
    tempcount++;
    swipe = true;
    //Serial.println(tempcount);
    for (int i = 0; i < n; i ++) {
      a[i] = 9999;
    }
    fcount = 1;
    //delay(100);
  }

  int xcount = 0;
  //Serial.println(x_read);
  int xmin = x[0];
  int i_min = 0;
  int xmax = x[0];
  int i_max = 0;
  for (int i = 0; i < n; i++) {
    if (x[i] < xmin) {
      xmin = x[i];
      i_min = i;
    }
    if (x[i] > xmax) {
      xmax = x[i];
      i_max = i;
    }
  }

  if (swipe){
    Serial.println("s,s");
    for (int i = 11; i >= 8; i--){
      digitalWrite(i,HIGH);
      Serial.println("s,s");
      delay(50);
    }
    Serial.println("s,s");
    delay(50);
    Serial.println("s,s");
    delay(50);
    for (int i = 11; i >= 8; i--){
      digitalWrite(i,LOW);
      Serial.println("s,s");
      delay(50);
    }
  }
  //if (xmin < 260 && xmax > 400) {
//    Serial.println("fuck");
//    Serial.println(xmin);
//    Serial.println(xmax);
  //}
  //  for (int i = 1; i < n; i++) {
  //    if (x[i] - x[0] > 10) {
  //      xcount ++;
  //    }
  //  }
  //  if (acount > 6) {
  //    tempcount++;
  //    Serial.println("swipe");
  //    //Serial.println(tempcount);
  //    for (int i = 0; i < n; i ++) {
  //      a[i] = 9999 - i;
  //    }
  //    fcount = 0;


  /////
  x0 = x_read;
  y0 = y_read;
  z0 = z_read;
  a0 = a_read;

  fcount++;
  fcount = fcount % n;
  ///
  if (Serial.read() == 'D') {
    for (int i = 8; i < 12; i++) {
      digitalWrite(i, HIGH);
    }
    delay(0);
    for (int i = 8; i < 12; i++) {
      digitalWrite(i, LOW);
    }
  }

}
