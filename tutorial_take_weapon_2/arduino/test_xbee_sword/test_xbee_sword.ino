//ss
int x0, y0, z0;
int x, y, z;

void setup() {
  Serial.begin(9600);
  x0 = analogRead(A5);
  y0 = analogRead(A4);
  z0 = analogRead(A3);
  for (int i = 8; i < 14; i++) {
    pinMode(i, OUTPUT);
  }
}

void loop() {
   x = analogRead(A5) - x0;
   y = analogRead(A4) - y0;
   z = analogRead(A3) - z0;
//   Serial.print(x);
//   Serial.print(",");
//   Serial.print(y);
//   Serial.print(",");
//   Serial.println(z);
   delay(33);

   if (y < -100) {
      Serial.println("s,s,");
      lightOn();
   }
}

void lightOn() {
  //in 600 ms
  for (int i = 11; i >= 9; i--) {
    digitalWrite(i, HIGH);
    delay(100);
  }
  digitalWrite(8, HIGH);
  for (int i = 11; i >= 9; i--) {
    digitalWrite(i, LOW);
    delay(100);
  }
  digitalWrite(8, LOW);
}


