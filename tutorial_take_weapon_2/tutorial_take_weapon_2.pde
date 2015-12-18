import processing.serial.*;
import ddf.minim.*;

Tutorial_take_weapon tutorial1;

void setup() {
  size(1024, 768, P2D);
  tutorial1 = new Tutorial_take_weapon();
}

void draw() {
  tutorial1.execute();
}