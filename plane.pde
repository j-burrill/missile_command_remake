class Plane {
  int planeSpeed;
  Point planePos;
  int targetXPos;
  PImage planeImg = loadImage("plane.png");
  int imgSize = 50;
  color planeC = color(255,0,0);

  Plane( Point startingPos, int bombX, boolean movingLeft ) {
    planePos = startingPos;
    targetXPos = bombX;
    if (movingLeft) {
      // set the speed to move the other way
      planeSpeed = planeSpeed*-1;
    }
  }
  
  Plane() {
    planePos = new Point(width/2, height/2);
    
  }

  void display() {
    print(planePos.x,planePos.y);
    tint(planeC);
    image( planeImg, planePos.x-imgSize/2, planePos.y-imgSize/2, imgSize, imgSize ); // draw the plane
  }

  void update() {
    planePos.x += planeSpeed;
  }
}
