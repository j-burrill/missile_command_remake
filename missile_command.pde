
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
    l.display();
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

void drawLine( int x, int y, int endX, int endY) {
  //println("new line made with starting x: " + x + " and y: "+ y);
  lines.add( new Line( x, y ) ); // make a new line in my array
  drawFireball( endX, endY );
}

void drawFireball(int x, int y) {
  // fireball made
  fireballs.add( new Fireball( x, y ) );
}

class Line {
  int startX, startY, finalX, finalY; 
  int baseX, baseY, endX, endY;
  int timer;
  color lineC = color(255);
  int lineW = 2;

  Line( int ix, int iy ) {
    baseX=ix;
    baseY=iy;
    endX=mouseX;
    endY=mouseY;
  }

  void display() {
    //println("drawing line: starting x: " + startX + " starting y: "+ startY + " ending x: " + endX + " ending y: "+ endY);
    /*
    
     first, I get the length of my line
     
     
     */
    int xDelta = finalX-baseX;
    int yDelta = finalY-baseY;
    float lineLength = sqrt( sq(xDelta) + sq(yDelta) );
    timer = millis() + 100;

    stroke(lineC);
    strokeWeight(lineW);
    line(baseX, baseY, endX, endY);
  }

  //void timer() {

  //}
}

class Fireball {
  int fbX, fbY;
  int fbLifetime = 4; // adjust how long the fireball stays for


  int fbMaxSize = 200;
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
    if ( timeDelta >= 0 ) { fbSize = fbMaxSize - ( timeDelta / ( fbLifetime*1000 / fbMaxSize ) ); }
    if ( timeDelta <= 0 ) { fbSize = fbMaxSize/2 + ( timeDelta2 / ( fbLifetime*2000 / fbMaxSize ) ); }

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
  int x = 60+( ( cannonNum-1 ) * 340 );
  if ( mouseY < height-100 && cannonAmmoCounts[cannonNum-1] > 0 ) { // if your mouse is in the playing area, and you have ammo
    drawLine( x, height-115, mouseX, mouseY );
  }
  cannonAmmoCounts[cannonNum-1]--; // lose one ammo for shooting
}
