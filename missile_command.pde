/*
  Justin Burrill
 Nov 02 2021
 Missile command for the Atari recreation
 
 to do: make the tracer stay after the line splits
 */


ArrayList<Missile> missiles = new ArrayList<Missile>(); // list of all my missiles
ArrayList<Fireball> fireballs = new ArrayList<Fireball>(); // list of all my fireballs
ArrayList<Cannon> cannons = new ArrayList<Cannon>(); // list of all my fireballs
ArrayList<Tracer> tracers = new ArrayList<Tracer>(); // list of all my tracers

final int floorH = 20;
int enemyTimer = 0;
boolean menuOpen = true;
int score, hscore;
color backgroundColour = color(0);

void setup() {
  size(800, 800);
  for (int i = 0; i<3; i++) {
    cannons.add( new Cannon( i ) ); // make my cannons
  }
}

void draw() {
  background( backgroundColour );
  stroke(125, 83, 54);
  strokeWeight(0);
  fill(125, 83, 54);

  rect(0, height-floorH, width, floorH); // rectangle for the ground

  for (int i = 0; i<tracers.size(); i++) { // display all my fireballs each frame
    Tracer t = tracers.get(i);
    t.display();
  }




  for (int i = 0; i<cannons.size(); i++) { // display all my cannons each frame
    Cannon c = cannons.get(i);
    c.display();
  }

  for (int i = 0; i<fireballs.size(); i++) { // display all my fireballs each frame
    Fireball f = fireballs.get(i);
    f.display();
  }

  for (int i = 0; i<missiles.size(); i++) { // do the following for each missile
    Missile m = missiles.get(i);
    if ( m.missile_end.x < width) { // don't draw if it's outside of the screen, this is important because i kill the missiles by putting them outside


      m.checkTimer(); // move missile when it's timer runs out
      m.display(); // display on each flame
    }
    //println("drawing line: starting x: " + a.startX + " starting y: "+ a.startY + " ending x: " + a.endX + " ending y: "+ a.endY);
  }
  if ( millis() > enemyTimer && !menuOpen ) { // spawn enemies every x milliseconds if menu is closed
    //println("enemytimer ran out");
    Point spawn = new Point( int(random(0, width)), 0);
    spawnEnemyMissile( spawn );
    enemyTimer = millis() + 1800; //1800
  }

  if ( menuOpen ) {
    if ( score>hscore ) { //update highscore if you beat it
      hscore=score;
    }
    fill(255);
    textSize(30);
    /*
      width/2-textWidth(str(score))/2
     this centers the score to the middle of the screen constantly by getting its width
     */
    String scoretxt = "Score: " + score;
    String hscoretxt = "Highscore: " + hscore;
    String tutorialtxt = "Use 1,2,3 or A,S,D to fire your missiles";
    String menutxt = "Click to start...";

    text(scoretxt, width/2-textWidth(scoretxt)/2, height/2-50);
    text(hscoretxt, width/2-textWidth(hscoretxt)/2, height/2-16);
    text(tutorialtxt, width/2-textWidth(tutorialtxt)/2, height/2+16);
    text(menutxt, width/2-textWidth(menutxt)/2, height/2+50);
  }
}

void keyPressed() { // check what button is pressed
  if (key == 'a' || key == '1') { // player uses these keys to fire the cannons
    //println("a pressed");
    cannons.get(0).fireCannon();
  }
  if (key == 's' || key == '2') {
    cannons.get(1).fireCannon();
  }
  if (key == 'd' || key == '3') {
    cannons.get(2).fireCannon();
  }
}

void mousePressed() {
  if ( menuOpen ) { // when reseting game:
    menuOpen = false; // close menu
    score = 0; // reset score
    enemyTimer = millis() + 2000; // delay before starting

    for ( int i = 0; i < cannons.size(); i++ ) { // reset ammo
      Cannon c = cannons.get(i);
      c.reset();
    }
    for ( int i = 0; i < missiles.size(); i++ ) { // kill all the missiles
      Missile l = missiles.get(i);
      l.killMissile();
    }
    for ( int i = 0; i < fireballs.size(); i++ ) { // kill all the fireballs
      Fireball f = fireballs.get(i);
      f.kill();
    }
  }
}

void newMissile( int x, int y, int fx, int fy, boolean p ) {
  //println("new line made with starting x: " + x + " and y: "+ y);
  Missile m = new Missile( x, y, fx, fy, p);
  missiles.add( m ); // make a new missile in my array
  spawnTracer( m, p );
}

void newFireball( int x, int y, int size ) {
  //println("fireball made");
  fireballs.add( new Fireball( x, y, size ) ); // make a new object for each fireball and and to array
}

void spawnEnemyMissile( Point spawn ) {
  int borderOffset = 80; // no missiles right on the edge of the screen
  int targetX = int(random(borderOffset, width-borderOffset)); // pick a random point on the ground to target

  // enemies are just missiles but a bit different
  newMissile( int(spawn.x), int(spawn.y), targetX, height, false );
}

void spawnTracer( Missile m, boolean player ) {
  Tracer t = new Tracer( m, player );
  tracers.add( t );
}
