
int[] cannonAmmoCounts = { 500, 500, 500 };
int floorH = 70;
ArrayList<Line> lines = new ArrayList<Line>(); // list of all my lines
ArrayList<Fireball> fireballs = new ArrayList<Fireball>(); // list of all my fireballs
int enemyTimer = millis() + 2000;
boolean menuOpen = true;
int score;

void setup() {
  size(800, 800);  
}

void draw() {
  background(0);
  stroke(125, 83, 54);
  strokeWeight(0);
  fill(125, 83, 54);
  
  rect(0, height-floorH, width, floorH); // rectangle for the ground

  drawMoutain(width/2-60, height-floorH); // draw my mountains
  drawMoutain(0, height-floorH);
  drawMoutain(width-120, height-floorH);
  
  for (int i = 0; i<lines.size(); i++) { // do the following for each line
    Line l = lines.get(i);
    if ( l.endX < width) {

      
      l.checkTimer();
      l.display();
    }
    //println("drawing line: starting x: " + a.startX + " starting y: "+ a.startY + " ending x: " + a.endX + " ending y: "+ a.endY);
  }
  for (int i = 0; i<fireballs.size(); i++) { // do the following for each fb in my list
    Fireball f = fireballs.get(i);
    f.display();
  }
  
  if ( millis() > enemyTimer && !menuOpen ) {
    //println("enemytimer ran out");
    newEnemy();
    enemyTimer = millis() + 1500;
  }
  
  if ( menuOpen ) {
    fill(255);
    textSize(30);
    text(score, width/2-textWidth(str(score))/2, height/2);
  }
}

void keyPressed() { // check what button is pressed
  if (key == 'a' || key == '1') { // player uses these keys to fire the cannons
    //println("a pressed");
    fireCannon(1);
  }
  if (key == 's' || key == '2') {
    fireCannon(2);
  }
  if (key == 'd' || key == '3') {
    fireCannon(3);
  }
}

void newLine( int x, int y, int fx, int fy, boolean p ) {
  //println("new line made with starting x: " + x + " and y: "+ y);
  lines.add( new Line( x, y, fx, fy, p) ); // make a new line in my array
  
}

void newFireball( int x, int y, int size ) {
  println("fireball made");
  fireballs.add( new Fireball( x, y, size ) );
}

void newEnemy() {
  int borderOffset = 80;
  
  int x = int(random(borderOffset, width-borderOffset));
  int targetX = int(random(borderOffset, width-borderOffset));
  
  newLine( x, 0, targetX, height, false );
}


class Line {
  float startingX, startingY, finalX, finalY;
  float startX, startY, endX, endY;
  int timer = 0;
  color lineC = color(255);
  int lineW = 2;

  float missileIncrementLength = 5;
  float missileLength = 15;
  int missileMoveDelay = 20;
  
  boolean playerMissile;

  Line( int ix, int iy, int ifx, int ify, boolean pMissile ) {
    startingX=ix;
    startingY=iy;
    finalX=ifx;
    finalY=ify;
    startX=startingX;
    startY=startingY;
    playerMissile = pMissile;
    if (!playerMissile) {
      missileIncrementLength = 2;
      missileLength = 20;
      missileMoveDelay = 20;
      lineC = color(235, 164, 143);
      missileLength = 8;
    }
  }
  
  
  void display() {
    stroke(lineC);
    strokeWeight(lineW);
    line(startX, startY, endX, endY);
    checkDestination();
    checkTimer();
    
    if ( !playerMissile ) {
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
    float deltaX_total = finalX - startingX;
    float deltaY_total = finalY - startingY;
    float hypotenuse_total = sqrt( sq(deltaX_total) + sq(deltaY_total) );
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
    if ( endY<finalY&&playerMissile ) {
      //println("missile has reached mark");
      newFireball( int(endX), int(endY), 100 ); // draw fireball at the end of the line
      killMissile();
      if ( !menuOpen ) {
        score += 100;
      }
      

    } else if (endY>height-floorH && !playerMissile) {
      println("enemy missile has detonated, you lose");
      newFireball( int(endX), int(endY), 20 ); // draw fireball at the end of the line
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
        killMissile();
      }
    }
  }
  
  void killMissile() { // if it's off the screen it doesn't get drawn, so this gets rid of it
    startX = width+100;
    endX = width+100;
  }
}

class Fireball {
  int x, y;
  int fbLifetime = 4; // adjust how long the fireball stays for

  int maxSize;
  int size;
  
  color fbColour = color(232, 161, 102);
  
  Fireball(int ix, int iy, int isize) {
    x = ix;
    y = iy;
    maxSize = isize;
  }

  int time = millis() + fbLifetime*1000;
  int time2 = millis() + fbLifetime*2000;
  int timeDelta;
  int timeDelta2;


  void display() {
    timeDelta = time - millis();
    timeDelta2 = time2 - millis();
    if ( timeDelta >= 0 ) {
      size = maxSize - ( timeDelta / ( fbLifetime*1000 / maxSize ) );
    }
    if ( timeDelta <= 0 ) {
      size = maxSize/2 + ( timeDelta2 / ( fbLifetime*2000 / maxSize ) );
    }

    fill(fbColour);
    stroke(fbColour);
    if ( size > 0 ) {
      ellipse(x, y, size, size);
    }
  }
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

void fireCannon(int cannonNum) { // draws line from specified cannon to mouse coordinates
   //println("fired cannon");
  int x = 60+( ( cannonNum-1 ) * 340 );
  if ( mouseY < height-70 && cannonAmmoCounts[cannonNum-1] > 0 && !menuOpen ) { // if your mouse is in the playing area, and you have ammo, and the game is running, fire missile 
    newLine( x, height-115, mouseX, mouseY, true );
  }
  cannonAmmoCounts[cannonNum-1]--; // lose one ammo for shooting
}

void mousePressed() {
  menuOpen = false;
  for ( int i = 0; i < lines.size(); i++ ) {
    Line l = lines.get(i);
    l.killMissile();
  }
}
