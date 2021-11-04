class Fireball {
  int x, y;
  int maxSize; // size the ball hits at it's largest
  int fbLifetime;
  int size; // current size
  color fbColour = color(255, 122, 51);
  int time, time2, timeDelta, timeDelta2;
  
  Fireball(int ix, int iy, int isize) {
    x = ix;
    y = iy;

    maxSize = isize;
    fbLifetime = maxSize/30;

    // adjust how long the fireball stays for
    time = millis() + fbLifetime*1000;
    time2 = millis() + fbLifetime*2000;
  }


  


  void display() {

    // this controls the balls getting bigger, then growing back smaller
    timeDelta = time - millis();
    timeDelta2 = time2 - millis();
    if ( timeDelta >= 0 ) {
      size = maxSize - ( timeDelta / ( fbLifetime*1000 / maxSize ) ); // make ball bigger while it's on the first timer
    }
    if ( timeDelta <= 0 ) {
      size = maxSize/2 + ( timeDelta2 / ( fbLifetime*2000 / maxSize ) ); // make ball smaller while it's on the second timer
    }

    fill(fbColour);
    stroke(fbColour);
    if ( size > 0 ) { // stop drawing the ball when the size hits 0
      ellipse(x, y, size, size); //
    }
  }

  void kill() {
    x = width+100; // shove it offscreen so it doesn't affect the game
  }
}
