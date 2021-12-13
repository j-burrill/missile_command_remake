/*
  this class controls the missiles and calculates their path when you fire them
 
 */

class Missile {
  Point path_start; // create all my points
  Point path_finish;
  Point missile_tail;
  Point missile_nose;
  Point killPos;
  Missile parentMissile; // enemy missiles that are spawned from a split are given a parent missile so I can make the tracer from the original missile stay and get destr

  int timer = 0;
  color lineColour = color(255);
  int lineWidth = 2;

  float missileIncrementLength = 15; // how much it moves
  float missileLength = 8; // size of missile
  int missileMoveDelay = 16; // how often it moves
  int splitTimer;

  boolean playerMissile;
  boolean missile_debugEnabled = cfg.getBoolean("debug_missile");



  Missile( Point ipath_start, Point ipath_finish, boolean pMissile, Missile parent ) {
    path_start = ipath_start;
    path_finish = ipath_finish;
    if (missile_debugEnabled) {
      println("path_start.x updated");
    }
    missile_tail = new Point( path_start.x, path_start.y );
    missile_nose = new Point( path_start.x, path_start.y ); // this avoids NPE
    playerMissile = pMissile;

    if (!playerMissile) { // missiles from the enemy look and move differently, i set these values here
      missileIncrementLength = cfg.getInt("missile_enemy_jump");
      missileLength = cfg.getInt("missile_enemy_size");
      missileMoveDelay = cfg.getInt("missile_enemy_delay");
      lineColour = color(255, 168, 158);
      parentMissile = parent;
    }
  }

  //  Missile( Point ipath_start, Point ipath_finish, boolean pMissile ) { // make missiles without a parent // unused

  //      this( ipath_start, ipath_finish, pMissile, null );
  //  }

  void display() { // draw my missiles
    checkDestination(); // also check to see if it's reached it destination every frame

    stroke(lineColour);
    strokeWeight(lineWidth);
    line(missile_tail.x, missile_tail.y, missile_nose.x, missile_nose.y); // draw the missile


    if ( !playerMissile ) { // if it's an enemy missile, check for collision with fireballs. player missiles aren't affected by the fireballs
      boolean missileSplitEnabled = cfg.getBoolean("missile_splitEnabled");
      boolean missileCollideEnabled = cfg.getBoolean("missile_collideEnabled");

      if ( missileSplitEnabled ) {
        int missileSplitCutoff = cfg.getInt("missile_splitMissileCutoff"); // missiles won't split past a certain height above the floor
        if ( missile_nose.y < height - floorHeight - missileSplitCutoff) {
          checkSplitMissile(); // chance to split missile each frame
        }
      }

      if ( missileCollideEnabled ) {
        for (int i = 0; i<fireballs.size(); i++) { // check collision with each fireball on the screen
          Fireball f = fireballs.get(i);
          checkCollision(f);
        }
      }
    }
  }

  void checkSplitMissile() {

    int splitDelay = 1000;
    if ( millis() > splitTimer ) { // check to split enemies every x milliseconds

      splitTimer += splitDelay; // reset split timer

      int chance = cfg.getInt("missile_splitMissileChance"); // get chance to split from cfg
      int result = int(random(-10, chance)); // random chance to split the missile

      //if (missile_debugEnabled) {
      //println(result);
      //}

      if (result < 0) {
        result=1;
        splitMissile();
        killMissile();
      }
    }
  }

  void splitMissile() {
    int splitCount = cfg.getInt("missile_splitMissileCount");
    for (int i=0; i<splitCount; i++) { // spawn x missiles
      spawnSplitMissile();
    }
  }

  void spawnSplitMissile() {
    int newFinishX = int(getNewMissileTarget());
    Point finish = new Point( newFinishX, height );
    spawnEnemyMissile( killPos, finish, this );
  }

  float getNewMissileTarget() {
    float oldFinishX = path_finish.x;
    float heightRemaining = height - missile_nose.y;
    float newFinishXOffset = heightRemaining/4;
    float newFinishX = random( -newFinishXOffset, newFinishXOffset ) + oldFinishX;
    return newFinishX;
  }

  void checkUpdateTimer() {
    if ( millis()>timer ) { // move missile every x milliseconds
      update();
      timer = millis() + missileMoveDelay;

      //
    }
  }

  void update() {
    // this math finds the next position for my line
    float deltaX_total = path_finish.x - path_start.x;
    float deltaY_total = path_finish.y - path_start.y;
    float hyp_total = sqrt( sq(deltaX_total) + sq(deltaY_total) ); // pythagoras
    float hyp_missile_inc = missileLength + missileIncrementLength;
    float deltaX_missile_inc = hyp_missile_inc * ( deltaX_total / hyp_total );
    float deltaY_missile_inc = hyp_missile_inc * ( deltaY_total / hyp_total );

    float deltaX_missile = missileLength * ( deltaX_total / hyp_total );
    float deltaY_missile = missileLength * ( deltaY_total / hyp_total );

    missile_nose.x = missile_tail.x + deltaX_missile_inc; // update the pos of the missile
    missile_nose.y = missile_tail.y + deltaY_missile_inc;

    missile_tail.x = missile_nose.x - deltaX_missile;
    missile_tail.y = missile_nose.y - deltaY_missile;

    if ( isOnScreen() ) {
      killPos = missile_nose;
      if ( missile_debugEnabled ) {
        println("updating killPos.x to: " + killPos.x);
      }
    }
    if ( parentMissile != null && missile_debugEnabled ) {
      println("missile startx, starty: ", path_start.x, path_start.y);
    }
  }

  void checkDestination() {
    if (playerMissile) {
      if ( path_start.y <= path_finish.y && missile_nose.y >= path_finish.y // check if the missile has passed the target destination
        || path_start.y >= path_finish.y && missile_nose.y <= path_finish.y
        || path_start.x >= path_finish.x && missile_nose.x <= path_finish.x
        || path_start.x <= path_finish.x && missile_nose.x >= path_finish.x) {

        finishPlayerMissile();
      }
    } else if ( missile_nose.y > height-floorHeight ) {
      finishEnemyMissile();
    }
  }

  void finishPlayerMissile() {
    //println("your missile has reached its target");
    newFireball( int(missile_nose.x), int(missile_nose.y), 100 ); // draw fireball at the end of the line
    killMissile();
  }

  void finishEnemyMissile() {
    //println("enemy missile has detonated, you lose");
    newFireball( int(missile_nose.x), int(missile_nose.y), 50 ); // draw fireball at the end of the line
    killMissile();
    menuOpen = true;
  }

  void checkCollision( Fireball f ) {
    // check to see if enemy missile should be destroyed by my fireball
    if ( isCollide( f ) ) { // if they collide, kill the missile and give score and stuff
      int fireballSize = cfg.getInt("missile_enemy_fireBallSize");

      int scoreForDestroying = cfg.getInt("missile_enemy_scoreForDestroying");
      addScore(scoreForDestroying);

      newFireball( int(missile_nose.x), int(missile_nose.y), fireballSize ); // little fireball after you destroy a missile

      killMissile();
    }

    //println("totalDelta: " + totalDelta + " fireball size: " + f.size);
  }


  boolean isCollide( Fireball f ) {
    float xDelta = f.pos.x - missile_nose.x;
    float yDelta = f.pos.y - missile_nose.y;
    float hyp = sqrt( sq(xDelta) + sq(yDelta) );
    if ( f.size/2 > hyp ) { // if missile enters fireball, kill it
      //println("missile killed by fireball");
      return true;
    } else return false;
  }

  void killMissile() { // if it's off the screen it doesn't get drawn, so this gets rid of it
    missile_tail.x = width+100;
    missile_nose.x = width+100;
  }

  boolean isOnScreen() { // check if the missile is on the screen
    if (missile_nose.x < width && missile_nose.x > -2
      && missile_nose.y < height && missile_nose.y > -2) {
      return true;
    } else return false;
  }
}
