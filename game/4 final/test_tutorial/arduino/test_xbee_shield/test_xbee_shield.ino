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

   if (z < -50) {
      Serial.println("d,f,");
      lightOn();
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
  
//    //in 800 ms, running a loop so every light stay for 300 ms
//  digitalWrite(13, HIGH);
//  delay(100);
//
//  digitalWrite(12, HIGH);
//  delay(100);
//
//  digitalWrite(11, HIGH);
//  delay(100);
//
//  digitalWrite(10, HIGH);
//  digitalWrite(13, LOW);
//  delay(100);
//
//  digitalWrite(9, HIGH);
//  digitalWrite(12, LOW);
//  delay(100);
//
//  digitalWrite(8, HIGH);
//  digitalWrite(11, LOW);
//  delay(100);
//
//  digitalWrite(10, LOW);
//  delay(100);
//
//  digitalWrite(9, LOW);
//  delay(100);
//
//  digitalWrite(8, LOW);
}

