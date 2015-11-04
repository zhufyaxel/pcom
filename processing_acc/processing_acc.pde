import processing.serial.*;

Serial myPort;
float ax = 0;
float ay = 0;
float az = 0;

float threshold = 100;
PVector acc_former;
PVector acc_current;

void setup(){
  size(1000,800);
  printArray(Serial.list());
  String portName = "/dev/cu.usbmodem1411";
  //String portName = "/dev/cu.AdafruitEZ-Link7436-SPP";
  println(portName);
  myPort = new Serial(this, portName, 9600);
  
  acc_former = new PVector(0,0,0);
  acc_current = new PVector(0,0,0);
}

void draw(){
  background(128);
  PVector a = new PVector(ax, ay, az);
  float r = a.mag() + 10;
  //println(a.mag());
  color cl = color(ax + 10,ay + 10,az + 10);
  fill(cl);
  noStroke();
  ellipse(width/2, height/2, r,r);
  
  if (acc_current.mag() > acc_former.mag() && acc_current.mag() > threshold && acc_former.mag() < threshold){
    //////////////////addtonehere////////////////
    ellipse(width/3, height/3, r,r);
    println("here");
  }
  acc_former.set(acc_current);

}

void serialEvent(Serial myPort) {
    if (myPort.available() > 0){
    String inBuffer = myPort.readStringUntil('\n');   
    if (inBuffer != null) {
      
      String[] list = split(inBuffer, ',');
        if (list.length >= 3){
          ax = float(list[0]);
          ay = float(list[1]);
          az = float(list[2]);
          acc_current.set(ax,ay,az);
          //println(ax,ay,az);
          //println(acc_current.x, acc_current.y, acc_current.z);
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