class Cannon {
  int cannonNumber;
  int x;
  int y = 65;
  int ammo = 15;
  Cannon( int num ) {
    cannonNumber = num;
    x = 60+( ( num ) * 340 ); // defines where the missiles come from
  }

  void fireCannon() { // draws line from specified cannon to mouse coordinates
    //println("fired cannon");
    if ( mouseY < height-y && ammo > 0 && !menuOpen ) { // if your mouse is in the playing area, and you have ammo, and the game is running, fire missile
      newMissile( x, height-y, mouseX, mouseY, true );
      ammo--; // lose one ammo for shooting
    }
    
  }
  void display() {
    fill(255);
    textSize(25);
    text(ammo, x-textWidth(str(ammo))/2, height-y+35);
  }
  void reset() {
    ammo = 15;
  }
}
