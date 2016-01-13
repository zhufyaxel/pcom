int x, y[70];
int z;
int n = 70;
int index = 0;
int count = 0;
int y_ave = 0;
boolean start = false;
void setup() {
  Serial.begin(9600);
  for (int i = 8; i < 12; i++) {
    pinMode(i, OUTPUT);
  }
  for (int i = 0; i < n; i++) {
    y[i] = analogRead(A4);
  }
}

void loop() {
  if (!start) {
    if (Serial.available() > 0) {
      char val = Serial.read();
      if (val == 'f') {
        for (int i = 8; i < 12; i ++) {
          digitalWrite(i, HIGH);
        }
        start = true;
      }
    }
  }
  if (start) {
    x = analogRead(A5);
    y[index] = analogRead(A4);
    z = analogRead(A3);
    ////Average of z/////
    int tempsum = 0;
    for (int i = 0; i < n; i++) {
      tempsum = tempsum + y[i];
    }
    y_ave = tempsum / n;
    /////Judge here//////
    int y_min = y_ave;
    int index_y_min = index;
    int y_max = y_ave;
    int index_y_max = index;
    for (int i = 0; i < n; i ++) {
      int I = (index + i) % n;
      if (y[I] > y_max) {
        y_max = y[I];
        index_y_max = I;
      }
      if (y[I] < y_min) {
        y_min = y[I];
        index_y_min = I;
      }
    }
    int difindex = (index_y_max - index_y_min);
    if (difindex <= 0) {
      difindex = difindex + n;
    }
    if (y_ave - y_min > 50 && y_max - y_ave > 50 && difindex < 3) {
      index = 0;
      count++;
      Serial.println("s,s,");
      lightOn();
      for (int i = 0; i < n; i++) {
        y[i] = analogRead(A4);
      }
    }
    index ++;
    if (index >= n) {
      index = 0;
    }
  }
  ///receive s for end
  if (Serial.available() > 0) {
      char val = Serial.read();
      if (val == 's') {
        for (int i = 8; i < 12; i ++) {
          digitalWrite(i, HIGH);
        }
        delay(200);
        for (int i = 8; i < 12; i ++) {
          digitalWrite(i, LOW);
        }
        start = false;
      }
  }
  
}

void lightOn() {
  //in 200 ms, running from top to bottom
  for (int i = 11; i >= 9; i--) {
    digitalWrite(i, HIGH);
    delay(25);
  }
  digitalWrite(8, HIGH);
  for (int i = 11; i >= 9; i--) {
    digitalWrite(i, LOW);
    delay(25);
  }
  digitalWrite(8, LOW);
}

