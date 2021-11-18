/*
  this class controls the missiles and calculates their path when you fire them
 
 */

class Missile {
  Point path_start; // create all my points
  Point path_finish;
  Point missile_tail;
  Point missile_nose;
  Point splitPos; // this is for the tracer, so it knows where to stay after missile split // useless?
  Missile parentMissile; // enemy missiles that are spawned from a split are given a parent missile so I can make the tracer from the original missile stay and get destr

  int timer = 0;
  color lineColour = color(255);
  int lineWidth = 2;

  float missileIncrementLength = 15; // how much it moves
  float missileLength = 8; // size of missile
  int missileMoveDelay = 16; // how often it moves
  int splitTimer;
  int childCount = 0;

  boolean playerMissile;
  boolean isSplit = false;
  boolean missile_debugEnabled = cfg.getBoolean("missile_debug");



  Missile( Point ipath_start, Point ipath_finish, boolean pMissile, Missile parent ) {
    path_start = ipath_start;
    path_finish = ipath_finish;
    missile_tail = new Point( path_start.x, path_start.y );
    missile_nose = new Point( path_start.x, path_start.y ); // this avoids NPE
    playerMissile = pMissile;

    if (!playerMissile) { // missiles from the enemy look and move differently, i set these values here
      missileIncrementLength = cfg.getInt("missile_enemy_jump");
      missileLength = cfg.getInt("missile_enemy_size");
      missileMoveDelay = cfg.getInt("missile_enemy_delay");
      lineColour = color(255, 168, 158);
      splitPos = missile_tail;
      parentMissile = parent;
    }
  }

  //  Missile( Point ipath_start, Point ipath_finish, boolean pMissile ) { // make missiles without a parent // unused

  //      this( ipath_start, ipath_finish, pMissile, null );
  //  }
  
  void display() { // draw my missiles

    if (isSplit) {
      if (missile_debugEnabled) {
        println("missile childCount: " + childCount);
      }
    };

    stroke(lineColour);
    strokeWeight(lineWidth);
    line(missile_tail.x, missile_tail.y, missile_nose.x, missile_nose.y); // draw the missile itself

    checkDestination(); // also check to see if it's reached it destination every frame

    if ( !playerMissile ) { // if it's an enemy missile, check for collision with fireballs. player missiles aren't affected by the fireballs
      final int missileSplitCutoff = 150; // missiles won't split past a certain height
      if ( missile_nose.y < height - floorHeight - missileSplitCutoff) {
        checkSplitMissile(); // chance to split missile each frame
      }
      for (int i = 0; i<fireballs.size(); i++) { // check collision with each fireball on the screen
        Fireball f = fireballs.get(i);
        checkCollision(f);
      }
    }
  }

    void checkSplitMissile() {
    if ( millis() > splitTimer ) { // split enemies every x milliseconds
      int chance = cfg.getInt("missile_splitMissileChance"); // lower number means more likely to split, default = 1000
      int result = int(random(-10, chance - missile_nose.y/3));
      splitTimer = millis()+800;

      //if (missileDebug) {
      //  println("missile split chance result: " + result);
      //}

      if ( result < 0 ) {
        int splitMissileCount = cfg.getInt("missile_splitMissileCount"); // how many missiles it splits into
        childCount = splitMissileCount;
        splitMissile( splitMissileCount );
        result = 1;
      }
      //println(chance);
    }
  }

  void splitMissile( int count ) {
    isSplit = true;
    keepTracerPos();
    for ( int i = 0; i < count; i++ ) {
      int finishx = 0;

      while ( finishx <= 0 || finishx > width ) { // recalculate if the target is out of bounds
        finishx = newMissileTarget();
      }

      Point spawn = new Point( missile_nose.x, missile_nose.y );
      Point finish = new Point( finishx, height );
      spawnEnemyMissile( spawn, finish, this );
    }

    killMissile();
    //println(splitPos.x, splitPos.y);
  }

  void checkTimer() {
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

      score += 100;
      newFireball( int(missile_nose.x), int(missile_nose.y), 70 ); // little fireball after you destroy a missile

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
    if (parentMissile != null) {
      parentMissile.childCount--;
    }
  }



  void keepTracerPos() {
    if ( !playerMissile && missile_tail.x < width ) {
      splitPos = missile_tail;
    }
  }

  int newMissileTarget() {
    int distFromBottom = height - int(missile_nose.y);
    int newFinishOffset = distFromBottom / 4;
    int finishx = int( missile_nose.x + random( -newFinishOffset, newFinishOffset ) );
    return finishx;
  }
}
