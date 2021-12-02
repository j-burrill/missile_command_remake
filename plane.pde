class Plane {
  int planeSpeed;
  Point planePos;
  int targetXPos;
  PImage planeImg = loadImage("plane.png");
  int imgSize = cfg.getInt("plane_imgSize");
  color planeC = color(255, 0, 0);
  boolean rightSideSpawn;
  boolean plane_debugEnabled = cfg.getBoolean("debug_plane");

  Plane( Point startingPos, int bombX, boolean Rspawn ) {
    planePos = startingPos;
    targetXPos = bombX;
    if (Rspawn) {
      // set the speed to move the other way
      planeSpeed = planeSpeed*-1;
    }

    if (plane_debugEnabled) {
      println("plane created");
    }
  }

  Plane() {
    // blank constructor for testing
    planePos = new Point(width/2, height/2);
  }

  void display() {
    update();
    println(planePos.x, planePos.y);
    tint(planeC);
    image( planeImg, planePos.x-imgSize/2, planePos.y-imgSize/2, imgSize, imgSize ); // draw the plane
  }

  void update() {
    planePos.x += planeSpeed;
  }

  boolean isOnScreen() { // check if the missile is on the screen
    if (planePos.x < width && planePos.x > -2) {
      return true;
    } else return false;
  }
}
