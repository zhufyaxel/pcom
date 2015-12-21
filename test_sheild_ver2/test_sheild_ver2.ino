int x, y;
int z[70];
int n = 70;
int index = 0;
int count = 0;
int z_ave = 0;
boolean start = false;
void setup() {
  Serial.begin(9600);
  for (int i = 8; i < 14; i++) {
    pinMode(i, OUTPUT);
  }
  for (int i = 0; i < n; i++) {
    z[i] = analogRead(A3);
  }
}

void loop() {
  if (!start) {
    if (Serial.available() > 0) {
      char val = Serial.read();
      if (val == 'd') {
        for (int i = 8; i < 14; i ++) {
          digitalWrite(i, HIGH);
        }
        start = true;
      }
    }
  }
  if (start) {
    x = analogRead(A5);
    y = analogRead(A4);
    z[index] = analogRead(A3);
    index ++;
    if (index >= n) {
      index = 0;
    }
    ////Average of z/////
    int tempsum = 0;
    for (int i = 0; i < n; i++) {
      tempsum = tempsum + z[i];
    }
    z_ave = tempsum / n;
    //Serial.println(z[index]);
    /////Judge here//////
    int z_min = z_ave;
    int index_z_min = index;
    int z_max = z_ave;
    int index_z_max = index;
    for (int i = 0; i < n; i ++) {
      int I = (index + i) % n;
      if (z[I] > z_max) {
        z_max = z[I];
        index_z_max = I;
      }
      if (z[I] < z_min) {
        z_min = z[I];
        index_z_min = I;
      }
    }
    int difindex = (index_z_max - index_z_min);
    if (difindex <= 0) {
      difindex = difindex + n;
    }
    if (z_ave - z_min > 50 && z_max - z_ave > 50 && difindex < 3) {
      index = 0;
      count++;
      Serial.println("d,d,");
      lightOn();
      for (int i = 0; i < n; i++) {
        z[i] = z[index];
      }
    }
    if (Serial.available() > 0) {
      char val = Serial.read();
      if (val == 's') {
        for (int i = 8; i < 14; i ++) {
          digitalWrite(i, HIGH);
        }
        delay(200);
        for (int i = 8; i < 14; i ++) {
          digitalWrite(i, LOW);
        }
        start = false;
      }

    }
    //  count++;
    //  if (millis() % 100 == 0) {
    //    Serial.print("times in 100 ms: ");
    //    Serial.println(count);
    //    count = 0;
    //    Serial.print("z_min = ");
    //    Serial.println(z_min);
    //  }
  }
}

void lightOn() {
  //in 600 ms, running from top to bottom

  digitalWrite(13, HIGH);
  delay(100);

  digitalWrite(12, HIGH);
  digitalWrite(8, HIGH);
  delay(100);

  digitalWrite(11, HIGH);
  digitalWrite(9, HIGH);
  delay(100);

  digitalWrite(10, HIGH);
  digitalWrite(13, LOW);
  delay(100);

  digitalWrite(12, LOW);
  digitalWrite(8, LOW);
  delay(100);

  digitalWrite(11, LOW);
  digitalWrite(9, LOW);
  delay(100);

  digitalWrite(10, LOW);
}

