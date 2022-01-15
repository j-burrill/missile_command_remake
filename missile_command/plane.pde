/*
 this class is the for planes that fly across the screen and drop a bunch of missiles
 */

class Plane {
  int planeSpeed = cfg.getInt("plane_moveSpeed");
  Point planePos;
  Point planeCentrePos;
  int targetXPos;
  PImage planeImg = loadImage("plane.png");
  int imgSize = cfg.getInt("plane_imgSize");
  color planeC = color(255, 0, 0);
  boolean rightSideSpawn;
  boolean plane_debugEnabled = cfg.getBoolean("debug_plane");
  boolean planeCollideEnabled = cfg.getBoolean("plane_collideEnabled");
  boolean bombed = false;
  boolean bombEnabled = cfg.getBoolean("plane_spawnEnemies");
  int loss = cfg.getInt("plane_lossForEscaping");

  Plane( Point startingPos, int bombX, boolean Rspawn ) {
    planePos = startingPos;
    targetXPos = bombX;
    rightSideSpawn = Rspawn;
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

    if ( planeCollideEnabled ) {
      for (int i=0; i<fireballs.size(); i++) { // check collision with each fireball on the screen
        Fireball f = fireballs.get(i);
        checkCollision(f);
      }
    }

    update();
    if (plane_debugEnabled) {
      //println("plane pos:", planePos.x, planePos.y);
    }

    tint(planeC);
    if (rightSideSpawn) {
      // found this on the processing forums, this will turn the image around if it is going the other way
      pushMatrix();
      translate( planePos.x + planeImg.width, planePos.y );
      scale( -1, 1 );
      image( planeImg, -imgSize/2, -imgSize/2, imgSize, imgSize );
      popMatrix();
    } else {

      image( planeImg, planePos.x-imgSize/2, planePos.y-imgSize/2, imgSize, imgSize ); // draw the plane
    }
  }

  void update() {
    planePos.x += planeSpeed;
    if ( bombEnabled && checkDestination() && !bombed ) { // if bombing is enabled, it is past its destination, and it hasn't already bombed
      bomb();
    }
    if (plane_debugEnabled) {
      //println("planePos.x:", planePos.x, "planeSpeed", planeSpeed);
    }
  }

  void bomb() {
    bombed = true;
    // spawn a bunch of missiles
    Point start = new Point( planePos.x, planePos.y ); // start point at where the plane is
    Point finish;
    // get amount of spawned missiles from the cfg
    int missileCount = cfg.getInt("plane_spawnMissileCount");
    // set the missile finish points to spread out below the plane
    int spaceBetweenMissile = cfg.getInt("plane_spaceBetweenMissile");
    int left = (-missileCount/2)*spaceBetweenMissile;
    for (int i=left; i<=-left; i+=spaceBetweenMissile) {

      finish = new Point( i+planePos.x, height - floorHeight );
      // spawn a new missile with the start at the spawn and the finish at the floor
      newMissile( start, finish, false, null );
    }
  }

  boolean checkDestination() {
    if (rightSideSpawn && planePos.x < targetXPos) {
      return true;
    } else if (!rightSideSpawn && planePos.x > targetXPos) {
      return true;
    } else {
      return false;
    }
  }

  boolean isOnScreen() { // check if the plane is on the screen
    // it spawns offscreen so i need to check where it starts
    if (planePos.x < width+2 && !rightSideSpawn || planePos.x > -2 && rightSideSpawn && planePos.y > 0) {
      if (plane_debugEnabled) {
        //println("plane onscreen");
      }
      return true;
    } else {
      if (plane_debugEnabled) {
        //println("plane offscreen");
      }
      if (planePos.y>0) { // so it only adds score once when it goes offscreen
        killPlane();
        // lose score if you let a plane escape w/out destroying it
        if ( !menuOpen ) {
          // don't lose score for letting planes escape if you've lost already because there isn't really anything you can do about it
          addScore(-loss);
        }
        //println(actualScore);
      }
      return false;
    }
  }

  void killPlane() {
    planePos.y = -imgSize;
  }

  void checkCollision( Fireball f ) {
    // check to see if enemy missile should be destroyed by my fireball
    if ( isCollide( f ) ) { // if they collide, kill the missile and give score and stuff
      int fireballSize = cfg.getInt("plane_fireBallSize");
      int fireballSizeEmpty = cfg.getInt("plane_fireBallSizeEmpty");
      int scoreForDestroying = cfg.getInt("plane_scoreForDestroying");
      int scoreForDestroyingEmpty = cfg.getInt("plane_scoreForDestroyingEmpty");

      // get more score for destroying it before it drops its bombs
      // resulting fireball is also smaller
      if (!bombed) {
        addScore(scoreForDestroying);
        // fireball that spawns after you blow up the plane
        newFireball( int(planePos.x), int(planePos.y), fireballSize ); 
      } else {
        addScore(scoreForDestroyingEmpty);
        newFireball( int(planePos.x), int(planePos.y), fireballSizeEmpty );
      }

      killPlane();
    }

    //println("totalDelta: " + totalDelta + " fireball size: " + f.size);
  }


  boolean isCollide( Fireball f ) {
    float xDelta = f.pos.x - planePos.x;
    float yDelta = f.pos.y - planePos.y;
    float hyp = sqrt( sq(xDelta) + sq(yDelta) );
    int leniency = cfg.getInt("plane_collideLeniency");
    if ( f.size/2 > hyp-leniency ) { // if plane enters fireball, kill it
      return true;
    } else return false;
  }
}
