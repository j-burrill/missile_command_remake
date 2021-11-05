/*
  this class controls the missiles and calculates their path when you fire them
 
 */

class Missile {
  Point path_start; // create all my points
  Point path_finish;
  Point missile_start;
  Point missile_end;
  Point killpos; // this is for the tracer, so it knows where to stay

  int timer = 0;
  color lineColour = color(255);
  int lineWidth = 2;

  float missileIncrementLength = 8; // how much it moves
  float missileLength = 15; // size of missile
  int missileMoveDelay = 16; // how often it moves
  int splitTimer;

  boolean playerMissile;

  Missile( int ix, int iy, int ifx, int ify, boolean pMissile ) {
    path_start = new Point( ix, iy );
    path_finish = new Point( ifx, ify );
    missile_start = new Point( path_start.x, path_start.y );
    missile_end = new Point( path_start.x, path_start.y ); // this avoids NPE
    playerMissile = pMissile;
    killpos = missile_start;

    if (!playerMissile) { // missiles from the enemy look and move differently, i set these values here
      missileIncrementLength = 2;
      missileLength = 20;
      missileMoveDelay = 25;
      lineColour = color(255, 168, 158);
      missileLength = 5;
    }
  }


  void display() { // draw my missiles
    stroke(lineColour);
    strokeWeight(lineWidth);
    line(missile_start.x, missile_start.y, missile_end.x, missile_end.y);

    checkDestination(); // also check to see if it's reached it destination every frame

    if ( !playerMissile ) { // if it's an enemy missile, check for collision with fireballs. player missiles aren't affected by the fireballs
      checkSplitMissile(); // chance to split missile each frame

      for (int i = 0; i<fireballs.size(); i++) { // check collision with each fireball on the screen
        Fireball f = fireballs.get(i);
        checkCollision(f);
      }
    }
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

    missile_end.x = missile_start.x + deltaX_missile_inc;
    missile_end.y = missile_start.y + deltaY_missile_inc;

    missile_start.x = missile_end.x - deltaX_missile;
    missile_start.y = missile_end.y - deltaY_missile;
    
    if ( missile_start.x < width ) {
      killpos = missile_start;
    }
    //println();
    //println("starting.x: " + starting.x + " startingY: " + startingY + " final_pos.x: " + final_pos.x + " path_finish.y: " + path_finish.y);
    //println("missile_start.x: " + missile_start.x + " missile_start.y: " + missile_start.y + " missile_end.x: " + missile_end.x + " missile_end.y: " + missile_end.y);
    //println("deltaX_total: " + deltaX_total + " deltaY_total: " + deltaY_total + " hypotenuse_total: " + hypotenuse_total + " hypotenuse_missile_inc: " + hypotenuse_missile_inc );
  }

  void checkDestination() {
    if (playerMissile) {
      if ( path_start.y < path_finish.y && missile_end.y > path_finish.y ) {
        finishPlayerMissile();
      }
      if ( path_start.y > path_finish.y && missile_end.y < path_finish.y ) {
        finishPlayerMissile();
      }
    } else if ( missile_end.y>height-floorH ) {
      finishEnemyMissile();
    }
  }

  void finishPlayerMissile() {
    //println("your missile has reached its target");
    newFireball( int(missile_end.x), int(missile_end.y), 100 ); // draw fireball at the end of the line
    killMissile();
  }

  void finishEnemyMissile() {
    //println("enemy missile has detonated, you lose");
    newFireball( int(missile_end.x), int(missile_end.y), 50 ); // draw fireball at the end of the line
    killMissile();
    menuOpen = true;
  }

  void checkCollision( Fireball f ) {
    // check to see if enemy missile should be destroyed by my fireball
    if ( isCollide( f ) && !menuOpen ) { // if they collide and the menu is closed ( you don't get points if you already died ), then
      score += 100; // add to score when destroying enemy missile
      newFireball( int(missile_end.x), int(missile_end.y), 70 ); // little fireball after you destroy a missile

      killMissile();
    }

    //println("totalDelta: " + totalDelta + " fireball size: " + f.size);
  }


  boolean isCollide( Fireball f ) {
    float xDelta = f.pos.x - missile_end.x;
    float yDelta = f.pos.y - missile_end.y;
    float hyp = sqrt( sq(xDelta) + sq(yDelta) );

    if ( f.size/2 > hyp ) { // if missile enters fireball, kill it
      //println("missile killed by fireball");

      return true;
    } else return false;
  }

  void killMissile() { // if it's off the screen it doesn't get drawn, so this gets rid of it
    missile_start.x = width+100;
    missile_end.x = width+100;
  }

  void checkSplitMissile() {

    if ( millis() > splitTimer ) { // split enemies every x milliseconds

      int chance = int(random(-10, 1000-missile_end.y));
      if ( chance < 0 ) {
        splitMissile();
      }
      splitTimer = millis()+800;
      //println(chance);
    }
  }

  void splitMissile() {
    Point target = new Point( missile_end.x, missile_end.y );
    spawnEnemyMissile( target );
    spawnEnemyMissile( target );
    killMissile();
  }
}
