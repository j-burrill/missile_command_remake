/*
  this class is to display and manage the ammo of the cannons
 */

class Cannon {
  int mountain_levelH = cfg.getInt("cannon_mountain_levelH"); // these are for the mountain
  int mountain_levels = cfg.getInt("cannon_mountain_levels");
  int mountain_startW = cfg.getInt("cannon_mountain_startW");

  int cannonNumber;
  int xPos;
  int yPos = height-(floorHeight + mountain_levelH * mountain_levels);
  int defaultAmmo = cfg.getInt("cannon_defaultAmmo");
  int ammo = defaultAmmo;



  Cannon( int num ) {
    cannonNumber = num;
    //xPos = 60 + ( ( num ) * 340 ); // defines where the missiles come from // old
  }

  void fireCannon() { // draws path for the missile from specified cannon to mouse coordinates
    //println("fired cannon");
    if ( ammo > 0 && !menuOpen ) { // if your mouse is in the playing area, and you have ammo, and the game is running, fire missile
      Point start = new Point( xPos, yPos+mountain_levelH ); // need to subtract the height of one level because of the way i draw the mountain
      Point finish = new Point( mouseX, mouseY );
      newMissile( start, finish, true, null );
      ammo--; // lose one ammo for shooting
    }
  }

  void display() {
    xPos = findXpos();

    fill(dirtColour);
    stroke(dirtColour);
    strokeWeight(0);
    drawMoutain(xPos-mountain_startW/2, height-floorHeight);


    fill(255);
    textSize(25);
    String ammoTxt = str(ammo);
    if (ammo == 0) {
      ammoTxt="OUT"; // display OUT instead of 0 because it's more fun
    }
    text(ammoTxt, xPos-textWidth(ammoTxt)/2, height-floorHeight-10); // display the ammo count
  }

  void reset() {
    ammo = defaultAmmo; // reset ammo
  }

  void drawMoutain(int leftX, int bottomY) { // this generates the little pyramids the cannons sit on
    int wDifference = mountain_startW / mountain_levels;

    for (int i = mountain_levels; i>0; i--) { // draw rectangles on top of each other
      int m_xPos = leftX + ( wDifference/2 * i );
      int m_yPos = bottomY - ( mountain_levelH * i );
      int m_width = mountain_startW - wDifference * i;
      int m_height = mountain_levelH;
      rect( m_xPos, m_yPos, m_width, m_height );
    }
  }

  int findXpos() {
    int distBetweenMountains = width/cannonCount;
    return distBetweenMountains/2 + distBetweenMountains*(cannonNumber)+1;
  }
}
