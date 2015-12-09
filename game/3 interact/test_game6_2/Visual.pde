public class Visual {
  PImage imgBkg;
  PImage imgPlanet;
  PImage imgEyes;
  PImage[] imgGrass;

  Visual() {
    imgBkg = loadImage("images/background/background.png");
    imgPlanet = loadImage("images/background/blinking planet.png");
    imgEyes = loadImage("images/background/blinking eye.png");
    imgGrass = new PImage[3];
    for (int i = 0; i < imgGrass.length; i++) {
      imgGrass[i] = loadImage("images/background/grass" + i + ".png");
    }
  }

  void show(int beatNum, boolean beatIn, int phase, int interval) {    
    // planet, quick fade in and slow fade out
    if (phase > 11*interval/12 && beatNum % 6 == 5) {
      tint(255, 126);
      image(imgPlanet, width/2, height/2);
      noTint();
    }
    if (beatNum%6 == 0 || beatNum%6 == 1|| (beatNum%6 == 2 && beatIn)) {
      image(imgPlanet, width/2, height/2);
    } 
    if ( (beatNum%6 == 2 && !beatIn)) {
      tint(255, 126);
      image(imgPlanet, width/2, height/2);
      noTint();
    }

    // trees
    image(imgBkg, width/2, height/2); 

    // eyes
    if (beatNum % 6 <= 1 ) {
      image(imgEyes, width/2, height/2);
    } else if (beatNum % 6 == 2) {
      tint(255, 170);
      image(imgEyes, width/2, height/2);
      noTint();
    } else if (beatNum % 6 == 5) {
      if (!beatIn) {
        tint(255, 127);
        image(imgEyes, width/2, height/2);
        noTint();
      }
    }

    // grass
    if (beatIn) {
      if (beatNum %3 == 0) {
        image(imgGrass[0], width/2, height/2);
      } else {
        image(imgGrass[2], width/2, height/2);
      }
    } else {
      image(imgGrass[1], width/2, height/2);
    }
  }
}