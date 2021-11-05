/*
  this class manages the circles (fireballs) that appear when missiles explode
 */

class Fireball {
  Point pos;
  int maxSize; // size the ball hits at it's largest
  int fbLifetime;
  int size; // current size
  color fbColour = color(255, 122, 51);
  int time, time2, timeDelta, timeDelta2;

  Fireball(int ix, int iy, int isize) {
    pos = new Point( ix, iy );

    maxSize = isize;
    fbLifetime = maxSize/40; // fireball lifetime is proportionate to its size

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


    if ( size > 0 ) { // stop drawing the ball when the size hits 0
      fill(fbColour);
      stroke(fbColour);
      ellipse( pos.x, pos.y, size, size ); //
    }
  }

  void kill() {
    pos.x = width+200; // shove it offscreen so it doesn't affect the game
  }
}
