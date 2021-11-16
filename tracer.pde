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
    update();
    
    if ( !missile.isSplit && end.x < width || missile.isSplit && missile.childCount > 0 ) {
      stroke(tracerColour);
      strokeWeight(2);
      line( start.x, start.y, end.x, end.y );
    }
  }

  void update() {
    start = missile.path_start;
    end = ( playerTracer ) ? missile.missile_tail : missile.splitPos; // take different variable if it's a player or enemy missile
    //println(end.x);
  }
}
