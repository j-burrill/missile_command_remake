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
    update();

    if ( end.x < width ) {
      stroke(tracerColour);
      strokeWeight(2);
      //println("drawing tracer with start.x: " + start.x + " start.y: " + start.y + " end.x: " + end.x + " end.y: " + end.y);
      line( start.x, start.y, end.x, end.y );
    }
  }

  void update() {
    start = missile.path_start;
    end = ( missile.playerMissile ) ? missile.missile_start : missile.splitPos;
    //println(end.x);
  }
}
