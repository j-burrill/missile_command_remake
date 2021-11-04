// Justin Burrill
// Nov 02 2021
//f sdafsdasad

int floorH = 20;
ArrayList<Missile> missiles = new ArrayList<Missile>(); // list of all my missiles
ArrayList<Fireball> fireballs = new ArrayList<Fireball>(); // list of all my fireballs
ArrayList<Cannon> cannons = new ArrayList<Cannon>(); // list of all my fireballs
int enemyTimer = 0;
boolean menuOpen = true;
int score, hscore;

void setup() {
  size(800, 800);
  for (int i = 0; i<3; i++) {
    cannons.add( new Cannon( i ) ); // make my cannons
  }
}

void draw() {
  background(0);
  stroke(125, 83, 54);
  strokeWeight(0);
  fill(125, 83, 54);

  rect(0, height-floorH, width, floorH); // rectangle for the ground

  drawMoutain(width/2-60, height-floorH); // draw my mountains that shoot the missiles
  drawMoutain(0, height-floorH);
  drawMoutain(width-120, height-floorH);

  for (int i = 0; i<missiles.size(); i++) { // do the following for each missile
    Missile m = missiles.get(i);
    if ( m.endX < width) {


      m.checkTimer(); // move missile when it's timer runs out
      m.display(); // display on each flame
    }
    //println("drawing line: starting x: " + a.startX + " starting y: "+ a.startY + " ending x: " + a.endX + " ending y: "+ a.endY);
  }
  for (int i = 0; i<fireballs.size(); i++) { // do the following for each fb in my list
    Fireball f = fireballs.get(i);
    f.display();
  }

  for (int i = 0; i<cannons.size(); i++) { // do the following for each fb in my list
    Cannon c = cannons.get(i);
    c.display();
  }


  if ( millis() > enemyTimer && !menuOpen ) { // spawn enemies every x seconds if menu is closed
    //println("enemytimer ran out");
    newEnemy();
    enemyTimer = millis() + 1500;
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
    String menutxt = "Click to start...";
    String scoretxt = "Score: " + score;
    String hscoretxt = "Highscore: " + hscore;

    text(scoretxt, width/2-textWidth(scoretxt)/2, height/2-35);
    text(hscoretxt, width/2-textWidth(hscoretxt)/2, height/2);
    text(menutxt, width/2-textWidth(menutxt)/2, height/2+35);
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
  missiles.add( new Missile( x, y, fx, fy, p) ); // make a new missile in my array
}

void newFireball( int x, int y, int size ) {
  //println("fireball made");
  fireballs.add( new Fireball( x, y, size ) ); // make a new object for each fireball and and to array
}

void newEnemy() {
  int borderOffset = 80; // no missiles right on the edge of the screen
  int x = int(random(borderOffset, width-borderOffset)); // pick random start pos from the top of the screen
  int targetX = int(random(borderOffset, width-borderOffset)); // pick a random point on the ground to target

  newMissile( x, 0, targetX, height, false ); // enemies are just missiles but a bit different
}

void drawMoutain(int leftX, int bottomY) { // this generates the little pyramids the cannons sit on
  int levelH = 15;
  int levels = 4;
  int startW = 120;
  int wDifference = startW/levels; // change these to change mountain dimensions
  for (int i = levels; i>0; i--) {
    rect(leftX+(wDifference/2*i), bottomY-(levelH*i), startW-wDifference*i, levelH);
  }
}
