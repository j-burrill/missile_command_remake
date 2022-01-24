/*
 this controls the little X's that appear when you fire a missile
 */

class Reticle {
  PImage crossImg = loadImage("crosshair.png");
  Point pos;
  int imgSize = 15;
  Missile parentMissile;

  color tintC = color(255);
  int currentColourIndex = 0;
  int flashTimer = 0;
  int flashDelay = cfg.getInt("game_colourFlashFrameDelay"); // amount of frames between the reticle changing colour
  boolean enableColourFlash = cfg.getBoolean("reticle_enableColourFlash");


  Reticle( Point p, Missile parent ) {
    pos = p;
    parentMissile = parent;
  }

  void display() {
    if (enableColourFlash) {
      flash();
    }
    checkParent();
    // the base image is white and i use tint() to control its colour
    tint(tintC);
    image( crossImg, pos.x-imgSize/2, pos.y-imgSize/2, imgSize, imgSize ); // the reticle is actually an image drawn here
  }

  void checkParent() {
    if ( parentMissile.missile_nose.x > width ) {
      pos.x=width+100;
    }
  }

  void flash() { // every x frames update the colour to the next in the list
    if ( --flashTimer <= 0 ) {
      flashTimer = flashDelay;

      this.tintC = getColour( currentColourIndex = nextIndex( currentColourIndex ) );
    }
  }
}
