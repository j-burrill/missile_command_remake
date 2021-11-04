color lineC = color(255);
int lineW = 2;

ArrayList<Line> lines = new ArrayList<Line>(); // list of all my lines


void setup() {
  size(800,800);
}

void draw() {
  background(0);
  for (int i = 0; i<lines.size(); i++) { // do the following for each line
    Line a = lines.get(i);
    a.display();
    println("drawing line: starting x: " + a.startX + " starting y: "+ a.startY + " ending x: " + a.endX + " ending y: "+ a.endY);
  }
  
  stroke(0);
  
  fill(125, 83, 54);
  int floorH = 70;
  rect(0, height-floorH, width, floorH); // rectangle for the ground
}

void keyPressed() { // check what button is pressed
  if (key == 'a' || key == '1') {
    println("a pressed");
    drawLine(0,0);
  }
  if (key == 's' || key == '2') {
    
  }
  if (key == 'd' || key == '3') {
    
  }
}

void drawLine(int x,int y) {
  //println("new line made with starting x: " + x + " and y: "+ y);
  lines.add(new Line(x,y));
}

class Line {
  int startX,startY,endX,endY;
  
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
