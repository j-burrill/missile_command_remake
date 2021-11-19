/*
 this controls the lines that follow the missiles
 */

class Tracer {
  Point start;
  Point end;
  Missile missile;
  boolean playerTracer;
  color tracerColour = color( 161, 20, 10 ); // red for enemy

  boolean tracer_debugEnabled = cfg.getBoolean("debug_tracer");


  Tracer( Missile im, boolean iplayer ) {
    missile = im;
    playerTracer = iplayer;

    if (playerTracer) {
      tracerColour = color( 6, 42, 161 ); // blue for player
    }
  }

  void display() {
    update();
    if ( end.x < width && end.x > 0 && start.x < width && start.x > 0 ) {
      stroke(tracerColour);
      strokeWeight(2);
      line( start.x, start.y, end.x, end.y );
    }
  }

  void update() {
    start = missile.path_start;
    end = missile.missile_tail;
    if ( tracer_debugEnabled ) {
      println("tracer end.x: " + end.x);
    }
  }
}
