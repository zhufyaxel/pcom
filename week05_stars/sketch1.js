// stars will appear automatically, but you can create a lot more waving or clicking your cursor!
// scroll up and down to control the span of new stars

// the star is loaded as image
var img;
var stars = [];

// counter for lower speed: count every period to create a new star, rather than 60/s
var counter = 0;
var period = 1;

var counter1 = 0;
var period1 = 50;

var counter2 = 0;
var period2 = 1;

// range of new stars appearing, alter when scrolling
var showerRange = 0;

// click to turn on or off a source
var isDrawing = false;

var myX;
var myY;

function Star(_x,_y) {
  this.x = _x;
  this.y = _y;
  this.xSpeed = random(5,7);  //4,6
  this.ySpeed = random(3,6);  //2,4
  this.phase = random(360);
  this.phaseSpeed = (this.xSpeed + this.ySpeed)/3 - 1.2
  this.size = random(20,70);  //50,100
  this.gone = false;  //stars get cleared if gone out of screen
  this.fall = function(){
    translate(this.x,this.y);
    rotate(this.phase*2*PI/360);
    image(img, -this.size/2, -this.size/2, this.size, this.size);
    rotate(-this.phase*2*PI/360);
    translate(-this.x,-this.y);
    //star showering
    if (this.x <= width + this.size) {
      this.x += this.xSpeed;
    } else {
      this.gone = true;
    }
    if (this.y <= height + this.size) {
    this.y += this.ySpeed;
    } else {
      this.gone = true;
    }
    // star rotating
    this.phase += this.phaseSpeed;  //0.7
    this.phase = this.phase % 360;
  }
}

function preload() {
  img = loadImage("assets/stars-100.png");
}

function setup() {
  createCanvas(windowWidth, windowHeight);
}

function draw() {
  background('rgba(0,0,0,0.15)'); //creating shadows with alpha
  
  // create stars randomly as default
  if (counter1 === period1) { // lower speed: count every period to create a new star, rather than 60/s
    var s1 = new Star(random(width/2), random(height/2));
    stars.push(s1);
    counter1 = 0;
    period1 = floor(random(1,60)); // period for next star
  } else {
    counter1 ++;
  }

  // turn on or off a source of stars when mouse is clicked 
  if (isDrawing) {
    if (counter === period) { // lower speed: count every period to create a new star, rather than 60/s
      var s = new Star(myX + random(-showerRange,showerRange), myY + random(-showerRange,showerRange));
      stars.push(s);
      counter = 0;
    } else {
      counter ++;
    }
  }
  
  // show all stars
  for (var i = 0; i < stars.length; i++) {
    stars[i].fall();
    // clear the stars out of screen
    if (stars[i].gone) {
      stars.splice(i,1);
    }
  }
}

// draw a lot of new stars when moving cursor
function mouseMoved(){
  if (counter2 === period2) {
    var s = new Star(mouseX + random(-showerRange,showerRange), mouseY + random(-showerRange,showerRange));
    stars.push(s);
    counter2 = 0;
  } else {
    counter2 ++;
  }
}

// alter the range of new stars appearing
function mouseWheel(){
  showerRange += event.delta*25;
  if (showerRange < 0) {
    showerRange = 0;
  } else if (showerRange > 300) {
    showerRange = 300;
  } 
  // show the range of stroke when the range is changed
  noFill();
  stroke('rgba(255,255,0,0.7)');
  ellipse(mouseX, mouseY, showerRange, showerRange);
}

// turn on or off a source of stars
function mouseClicked() {
  isDrawing = !isDrawing;
  // remember the clicked spot and make it as source
  myX = mouseX;
  myY = mouseY;
}