///**
// * Simple Read
// * 
// * Read data from the serial port and change the color of a rectangle
// * when a switch connected to a Wiring or Arduino board is pressed and released.
// * This example works with the Wiring / Arduino program that follows below.
// */


//import processing.serial.*;

//Serial myPort;  // Create object from Serial class
//String val;      // Data received from the serial port
//String portName = "/dev/cu.usbserial-AH01KCPQ";
  
//void serialEvent(Serial myPort) { 
//  if ( myPort.available() > 0) {  // If data is available,
//    val = myPort.readStringUntil('\n');
//    if (val != null && val.length() > 2){
//      if (val.charAt(0) == 'd'){
//        if (val.charAt(2) == 'f'){
//          println("defence");
//          game.myPort("defend");
//        }
//      }
      
//      if (val.charAt(0) == 's'){
//        if (val.charAt(2) == 's'){
//          println("swipe");
//          game.myPort("swipe");
//        }
//      }
//    }
//  }
//} 