int x0 = 0;
int y0 = 0;
int z0 = 0;

int xp = 0;
int yp = 0;
int zp = 0;

int n = 10;
int x[10];
int y[10];
int z[10];

int fcount = 0;
void setup() {
  Serial.begin(9600);
  x0 = analogRead(A5);
  y0 = analogRead(A4);
  z0 = analogRead(A3);
  for (int i = 8; i < 14; i++) {
    pinMode(i, OUTPUT);
  }
  for (int i = 0; i < n ; i ++) {
    x[i] = y[i] = z[i] = 0;
  }
}

void loop() {
  x[fcount] = analogRead(A5) - x0;
  y[fcount] = analogRead(A4) - y0;
  z[fcount] = analogRead(A3) - z0;

  //int x_rea
  boolean forward = false;
  int init = (fcount + 1) % 10;
  // Serial.println(z[fcount] - z[init]);
  if (z[init] - z[fcount] > 15 ) {
    forward = true;
  }

  //Serial.println(z[fcount]);
  if (forward) {
    Serial.println("d,f,");
    int z_min = z[0];
    for (int i = 0; i < n; i++) {
      if (z[i] < z_min) {
        z_min = z[i];
      }
    }
    for (int i = 0; i < n ; i++) {
      z[i] = z_min - 100;
    }
    fcount = 0;
    for (int i = 13; i > 7; i--) {
      digitalWrite(i, HIGH);
      Serial.println("d,f,");
      delay(30);
    }
    for (int i = 0; i < 7; i++) {
      delay(30);
      Serial.println("d,f,");
    }
    for (int i = 0; i < 3; i++){
      delay(30);
    }
    for (int i = 13; i > 7; i--) {
      digitalWrite(i, LOW);
      Serial.println("d,f,");
      delay(30);
    }
    delay(140);
  }

  xp = x[fcount];
  yp = y[fcount];
  zp = z[fcount];

  fcount++;
  fcount = fcount % n;
}
