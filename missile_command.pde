color lineC = color(255);
int lineW = 2;
int cannon1Ammo = 10, cannon2Ammo = 10, cannon3Ammo = 10;

ArrayList<Line> lines = new ArrayList<Line>(); // list of all my lines


void setup() {
  size(800, 800);
}

void draw() {
  background(0);
  for (int i = 0; i<lines.size(); i++) { // do the following for each line
    Line a = lines.get(i);
    a.display();
    //println("drawing line: starting x: " + a.startX + " starting y: "+ a.startY + " ending x: " + a.endX + " ending y: "+ a.endY);
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

void drawLine(int x, int y) {
  //println("new line made with starting x: " + x + " and y: "+ y);
  lines.add(new Line(x, y));
}

class Line {
  int startX, startY, endX, endY;

  Line(int ix, int iy) {
    startX=ix;
    startY=iy;
    endX=mouseX;
    endY=mouseY;
  }

  void display() {
    //println("drawing line: starting x: " + startX + " starting y: "+ startY + " ending x: " + endX + " ending y: "+ endY);
    stroke(lineC);
    strokeWeight(lineW);
    line(startX, startY, endX, endY);
  }
}

class Fireball {
//  int startX, startY, endX, endY;

//  Line(int ix, int iy) {
//    startX=ix;
//    startY=iy;
//    endX=mouseX;
//    endY=mouseY;
//  }

//  void display() {
//    //println("drawing line: starting x: " + startX + " starting y: "+ startY + " ending x: " + endX + " ending y: "+ endY);
//    stroke(lineC);
//    strokeWeight(lineW);
//    line(startX, startY, endX, endY);
//  }
//}

//void drawMoutain(int leftX, int bottomY) { // this generates the little pyramids the cannons sit on
//  int levelH = 15;
//  int levels = 4;
//  int startW = 120;
//  int wDifference = startW/levels; // change these to change mountain dimensions
//  for (int i = levels; i>0; i--) {
//    rect(leftX+(wDifference/2*i), bottomY-(levelH*i), startW-wDifference*i, levelH);
//  }
}

void fireCannon(int cannonNum) { // draws line from specified cannon to mouse coordinates
  int x = 60+((cannonNum-1)*340);
  drawLine(x, height-115);  
}
