/*
 this controls the little X's that appear when you fire a missile
 */

class Reticle {
  PImage crossImg = loadImage("crosshair.png");
  int x, y;
  int imgSize = 15;
  Missile parentMissile;

  color tintC = color(255);
  int currentColourIndex = 0;
  int flashTimer = 0;
  int flashDelay = cfg.getInt("game_colourFlashFrameDelay"); // amount of frames between the reticle changing colour
  boolean enableColourFlash = cfg.getBoolean("reticle_enableColourFlash");
  boolean reticle_debugEnabled = cfg.getBoolean("debug_reticle");


  Reticle( int ix, int iy, Missile parent ) {
    x=ix;
    y=iy;
    parentMissile = parent;
  }

  void display() {
    if (enableColourFlash) {
      flash();
    }
    checkParent();
    tint(tintC);
    image( crossImg, x-imgSize/2, y-imgSize/2, imgSize, imgSize ); // the reticle is actually an image
  }

  void checkParent() {
    if ( parentMissile.missile_nose.x > width ) {
      x=width+100;
    }
  }

  void flash() { // every x frames update the colour to the next in the list
    flashTimer--;
    if ( flashTimer <= 0 ) {
      flashTimer = flashDelay;

      tintC = getColour( currentColourIndex = nextIndex( currentColourIndex ) );
    }
    if (reticle_debugEnabled) {
      println("reticle flashTimer: "+flashTimer);
      println("reticle currentColourIndex: "+currentColourIndex);
    }
  }
}
