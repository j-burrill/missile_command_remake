
int cannon1Ammo = 10, cannon2Ammo = 10, cannon3Ammo = 10;
int[] cannonAmmoCounts = { 10, 10, 10};

ArrayList<Line> lines = new ArrayList<Line>(); // list of all my lines
ArrayList<Fireball> fireballs = new ArrayList<Fireball>(); // list of all my fireballs


void setup() {
  size(800, 800);
}

void draw() {
  background(0);
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

  stroke(125, 83, 54);
  strokeWeight(0);
  fill(125, 83, 54);
  int floorH = 70;
  rect(0, height-floorH, width, floorH); // rectangle for the ground

  drawMoutain(width/2-60, height-floorH); // draw my mountains
  drawMoutain(0, height-floorH);
  drawMoutain(width-120, height-floorH);
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

void drawLine( int x, int y ) {
  //println("new line made with starting x: " + x + " and y: "+ y);
  lines.add( new Line( x, y ) ); // make a new line in my array
  
}

void drawFireball( int x, int y ) {
  println("fireball made");
  fireballs.add( new Fireball( x, y ) );
}

class Line {
  float startingX, startingY, finalX, finalY;
  float startX, startY, endX, endY;
  int timer = 0;
  color lineC = color(255);
  int lineW = 2;

  float missileIncrementLength = 5;
  float missileLength = 20;
  int missileMoveDelay = 20;

  Line( int ix, int iy ) {
    startingX=ix;
    startingY=iy;
    finalX=mouseX;
    finalY=mouseY;
    startX=startingX;
    startY=startingY;


  }
  
  
  void display() {
      stroke(lineC);
      strokeWeight(lineW);
      line(startX, startY, endX, endY);
      checkDestination();
      checkTimer();
    
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
    if ( endY<finalY ) {
      println("missile has reached mark");
      drawFireball( int(endX), int(endY) ); // draw fireball at the end of the line
      startX = width+100; // get rid of line when it hits its destination
      endX = width+100; // get rid of line when it hits its destination
      
    }
  }
}

class Fireball {
  int fbX, fbY;
  int fbLifetime = 4; // adjust how long the fireball stays for

  int fbMaxSize = 100;
  int fbSize;

  color fbColour = color(255);

  Fireball(int ix, int iy) {
    fbX = ix;
    fbY = iy;
  }

  int time = millis() + fbLifetime*1000;
  int time2 = millis() + fbLifetime*2000;
  int timeDelta;
  int timeDelta2;


  void display() {
    timeDelta = time - millis();
    timeDelta2 = time2 - millis();
    if ( timeDelta >= 0 ) {
      fbSize = fbMaxSize - ( timeDelta / ( fbLifetime*1000 / fbMaxSize ) );
    }
    if ( timeDelta <= 0 ) {
      fbSize = fbMaxSize/2 + ( timeDelta2 / ( fbLifetime*2000 / fbMaxSize ) );
    }

    fill(fbColour);
    if ( fbSize > 0 ) {
      ellipse(fbX, fbY, fbSize, fbSize);
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
  if ( mouseY < height-100 && cannonAmmoCounts[cannonNum-1] > 0 ) { // if your mouse is in the playing area, and you have ammo // 
    drawLine( x, height-115 );
  }
  cannonAmmoCounts[cannonNum-1]--; // lose one ammo for shooting
}
