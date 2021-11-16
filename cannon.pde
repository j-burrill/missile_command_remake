/*
  this class is to display and manage the ammo of the cannons
 */

class Cannon {
  int cannonNumber;
  int x;
  int y = 65;
  int defaultAmmo = 15;
  int ammo = defaultAmmo;
  
  Cannon( int num ) {
    cannonNumber = num;
    x = 60 + ( ( num ) * 340 ); // defines where the missiles come from
  }

  void fireCannon() { // draws path for the missile from specified cannon to mouse coordinates
    //println("fired cannon");
    if ( ammo > 0 && !menuOpen ) { // if your mouse is in the playing area, and you have ammo, and the game is running, fire missile
      Point start = new Point( x, height-y );
      Point finish = new Point( mouseX, mouseY );
      newMissile( start, finish, true, null );
      ammo--; // lose one ammo for shooting
    }
  }

  void display() {
    fill(125, 83, 54);
    stroke(125, 83, 54);
    strokeWeight(0);
    drawMoutain(x-60, height-floorH);

    fill(255);
    textSize(25);
    String ammoTxt = str(ammo);
    if (ammo == 0) {
      ammoTxt="OUT"; // display OUT instead of 0 because it's more fun
    }
    text(ammoTxt, x-textWidth(ammoTxt)/2, height-y+35); // display the ammo count
  }
  void reset() {
    ammo = defaultAmmo; // reset ammo
  }

  void drawMoutain(int leftX, int bottomY) { // this generates the little pyramids the cannons sit on
    int levelH = 15;
    int levels = 4;
    int startW = 120;
    int wDifference = startW/levels; // change these to change mountain dimensions

    for (int i = levels; i>0; i--) {
      rect(leftX + ( wDifference/2 * i ), bottomY - ( levelH * i ), startW - wDifference * i, levelH ); // draw rectangles on top of each other
    }
  }
}
