/*
 this controls the lines that follow the missiles
 */

class Tracer {
  Point start;
  Point end;
  Missile missile;
  boolean playerTracer;
  color tracerColour = color( 161, 20, 10 ); // red for enemy


  Tracer( Missile im, boolean iplayer ) {
    missile = im;
    playerTracer = iplayer;

    if (playerTracer) {
      tracerColour = color( 6, 42, 161 ); // blue for player
    }
  }

  void display() {
    // update each frame
    update();
    // don't draw if it's off-screen
    if ( missile.isOnScreen() ) {
      stroke(tracerColour);
      strokeWeight(2);
      line( start.x, start.y, end.x, end.y );
    }
  }

  void update() {
    // get start and end from the missile
    start = missile.path_start;
    end = missile.missile_tail;

  }
}
