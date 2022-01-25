// everything related to multiplayer

class Xhair {
  int xpos, ypos, imgSize = 30;
  float defaultSpeed = 7;
  float xSpeed, ySpeed;
  boolean leftHeld, rightHeld, upHeld, downHeld;
  color colour;
  String player;
  PImage crossImg = loadImage("crosshair.png");

  Xhair(String p) {
    // set colour and starting position depending
    if (p == "red") {
      colour = color(255, 0, 0);
      player = "red";
      xpos = width / 3;
    } else if (p == "blue") {
      colour = color(0, 0, 255);
      player = "blue";
      xpos = 2*(width / 3);
    }
    ypos = height/2;
  }

  void display() {
    // update pos every frame
    move();
    tint( colour );
    // reused the image for the reticle
    image( crossImg, xpos-imgSize/2, ypos-imgSize/2, imgSize, imgSize );
  }


  void move() {
    // ignore inputs if the menu is open
    if (menuOpen) return;

    xSpeed = 0;
    ySpeed = 0;

    if (leftHeld && !rightHeld && xpos > 0) {
      xSpeed = -defaultSpeed;
    }
    if (!leftHeld && rightHeld && xpos < width) {
      xSpeed = defaultSpeed;
    }
    if (leftHeld && rightHeld || !leftHeld && !rightHeld) {
      xSpeed = 0;
    }

    if (upHeld && !downHeld && ypos > 0) {
      ySpeed = -defaultSpeed;
    }
    if (!upHeld && downHeld && ypos < height) {
      ySpeed = defaultSpeed;
    }
    if (upHeld && downHeld || !upHeld && !downHeld) {
      ySpeed = 0;
    }

    if (ySpeed != 0 && xSpeed != 0) {
      // prevent faster diagonal speed
      ySpeed = ySpeed*.6;
      xSpeed = xSpeed*.6;
    }

    xpos += xSpeed;
    ypos += ySpeed;
  }

  void fire() {
    int cannonPicked = ( player == "red" )? 0 : 1 ;
    cannons.get(cannonPicked).fireCannon(xpos, ypos);
  }
}

void setupMultiplayer() {
  xhairs.clear();
  redplayer = new Xhair("red");
  blueplayer = new Xhair("blue");
  xhairs.add(redplayer);
  xhairs.add(blueplayer);
}
