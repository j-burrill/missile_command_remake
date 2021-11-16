/*
 this controls the little X's that appear when you fire a missile
 */

class Reticle {
  PImage crossimg = loadImage("crosshair.png");
  int x, y;
  int imgSize = 15;
  color tintC = color(255);
  Missile parentMissile;
  int flashTimer = 0;
  final int flashDelay = 5; // amount of frames between the reticle changing colour

  Reticle( int ix, int iy, Missile parent ) {
    x=ix;
    y=iy;
    parentMissile = parent;
  }

  void display() {
    checkParent();
    tint(tintC);
    image( crossimg, x-imgSize/2, y-imgSize/2, imgSize, imgSize );
  }

  void checkParent() {
    if ( parentMissile.missile_nose.x > width ) {
      x=width+100;
    }
  }
  
  void flash() {
    flashTimer--;
    if ( flashTimer <= 0 ) {
      
    }
  }
}
