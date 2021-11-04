class Missile {
  float startingX, startingY, finalX, finalY;
  float startX, startY, endX, endY;
  int timer = 0;
  color lineC = color(255);
  int lineW = 2;

  float missileIncrementLength = 8; // how much it moves
  float missileLength = 15; // size of missile
  int missileMoveDelay = 16; // how often it moves

  boolean playerMissile;

  Missile( int ix, int iy, int ifx, int ify, boolean pMissile ) {
    startingX=ix;
    startingY=iy;
    finalX=ifx;
    finalY=ify;
    startX=startingX;
    startY=startingY;
    playerMissile = pMissile;

    if (!playerMissile) { // missiles from the enemy look and move differently
      missileIncrementLength = 2;
      missileLength = 20;
      missileMoveDelay = 20;
      lineC = color(255, 168, 158);
      missileLength = 8;
    }
  }


  void display() { // draw my missiles
    stroke(lineC);
    strokeWeight(lineW);
    line(startX, startY, endX, endY);
    checkDestination(); // also check to see if it's reached it destination every frame
    if ( !playerMissile ) { // if it's an enemy missile, check for collision with fireballs. player missiles aren't affected by the fireballs
      checkFB();
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
    float deltaX_total = finalX - startingX;
    float deltaY_total = finalY - startingY;
    float hypotenuse_total = sqrt( sq(deltaX_total) + sq(deltaY_total) ); // pythagoras
    float hypotenuse_missile_inc = missileLength + missileIncrementLength;
    float deltaX_missile_inc = hypotenuse_missile_inc * ( deltaX_total / hypotenuse_total );
    float deltaY_missile_inc = hypotenuse_missile_inc * ( deltaY_total / hypotenuse_total );

    float deltaX_missile = missileLength * ( deltaX_total / hypotenuse_total );
    float deltaY_missile = missileLength * ( deltaY_total / hypotenuse_total );

    endX = startX + deltaX_missile_inc;
    endY = startY + deltaY_missile_inc;

    startX = endX - deltaX_missile;
    startY = endY - deltaY_missile;

    //println();
    //println("startingX: " + startingX + " startingY: " + startingY + " finalX: " + finalX + " finalY: " + finalY);
    //println("startX: " + startX + " startY: " + startY + " endX: " + endX + " endY: " + endY);
    //println("deltaX_total: " + deltaX_total + " deltaY_total: " + deltaY_total + " hypotenuse_total: " + hypotenuse_total + " hypotenuse_missile_inc: " + hypotenuse_missile_inc );
  }

  void checkDestination() {
    if ( endY<finalY&&playerMissile ) { // if player missiles
      //println("your missile has reached its target");
      newFireball( int(endX), int(endY), 100 ); // draw fireball at the end of the line
      killMissile();
    } else if (endY>height-floorH && !playerMissile) {
      //println("enemy missile has detonated, you lose");
      newFireball( int(endX), int(endY), 50 ); // draw fireball at the end of the line
      killMissile();
      menuOpen = true;
    }
  }

  void checkFB() {
    for (int i = 0; i<fireballs.size(); i++) { // do the following for each fb in my list
      // check to see if enemy missile should be destroyed by my fireball
      Fireball f = fireballs.get(i);
      float xDelta = f.x - endX;
      float yDelta = f.y - endY;
      float totalDelta = sqrt( sq(xDelta) + sq(yDelta) );
      //println("totalDelta: " + totalDelta + " fireball size: " + f.size);
      if ( f.size/2 > totalDelta ) { // if missile enters fireball, kill it
        //println("missile killed by fireball");
        newFireball( int(endX), int(endY), 50 ); // little fireball after you destroy a missile
        killMissile();
         
        if ( !menuOpen ) {
          score += 100; // add to score when destroying enemy missile
        }
      }
    }
  }

  void killMissile() { // if it's off the screen it doesn't get drawn, so this gets rid of it
    startX = width+100;
    endX = width+100;
  }
}
