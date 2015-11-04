int Ax0;
int Ay0;
int Az0;

void setup() {
  Serial.begin(9600);
  Ax0 = analogRead(A2);
  Ay0 = analogRead(A1);
  Az0 = analogRead(A0);
  while (Serial.available() <= 0) {
    Serial.println("hello"); // send a starting message
    delay(300);              // wait 1/3 second
  }
//  Serial.print(Ax0);
//  Serial.print(Ay0);
//  Serial.println(Az0);
}

void loop() {
  if (Serial.available() > 0){
    int Ax = analogRead(A2) - Ax0;
    int Ay = analogRead(A1) - Ay0;
    int Az = analogRead(A0) - Az0;
    Serial.print(Ax);
    Serial.print(',');
    Serial.print(Ay);
    Serial.print(',');
    Serial.print(Az);
    Serial.println(',');
  }
//  if (Ax > 5 || Ax < -5){
//    Serial.print("Ax = ");
//    Serial.println(Ax);
//  }
//
//  if (Ay > 5 || Ay < -5){
//    Serial.print("Ay = ");
//    Serial.println(Ay);
//  }
//
//  if (Az > 5 || Az < -5){
//    Serial.print("Az = ");
//    Serial.println(Az);
//  }

}
