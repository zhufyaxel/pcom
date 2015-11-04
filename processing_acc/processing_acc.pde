import processing.serial.*;

Serial myPort;
int ax = 0;
int ay = 0;
int az = 0;

void setup(){
  size(1000,800);
  printArray(Serial.list());
  //String portName = "/dev/cu.usbmodem1411";
  String portName = "/dev/cu.AdafruitEZ-Link7436-SPP";
  println(portName);
  myPort = new Serial(this, portName, 9600);
}

void draw(){
  background(128);
  PVector a = new PVector(ax, ay, az);
  float r = a.mag() + 10;
  println(a.mag());
  color cl = color(ax + 10,ay + 10,az + 10);
  fill(cl);
  noStroke();
  ellipse(width/2, height/2, r,r);
}

void serialEvent(Serial myPort) {
    if (myPort.available() > 0){
    String inBuffer = myPort.readStringUntil('\n');   
    if (inBuffer != null) {
      
      String[] list = split(inBuffer, ',');
        if (list.length >= 3){
          ax = int(list[0]);
          ay = int(list[1]);
          az = int(list[2]);
          //println(ax,ay,az);
        }
        else{
          myPort.write('x');
        }
    }
  }
}
void keyPressed(){
  if (key == 's'){
    println("stop");
    myPort.stop();
  }
}