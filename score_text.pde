/*
 This is for the green/red text that appears in the top left corner
 */


void addScore( int amount ) {
  actualScore += amount;
  newScoreText( amount );
}

void newScoreText( int amount ) {
  Score_text t = new Score_text( amount );
  texts.add(t);
}

class Score_text {
  boolean text_debugEnabled = cfg.getBoolean("debug_text");


  int num; // the change in score
  color textColour = color(0, 255, 0); // default colour

  Point textPos;

  int startY = 60, startX = 5;
  int targetY = 30;
  int moveDelay = 1200; // how long the text stays, in milliseconds
  int moveTimer;
  int yMoveAmount = 1; // how much the text moves per frame


  Score_text( int amt ) {
    if (text_debugEnabled) {
      println("new score made");
    }
    num = amt;
    // set move timer to a point in the future ahead of millis()
    moveTimer = millis() + moveDelay;

    textPos = new Point( startX, startY );
    if (num < 0) {
      // make it red if it is a negative number
      textColour = color(255, 0, 0);
    }
  }

  void display() {
    update();
    fill(textColour);
    text(nfp(num, 0), textPos.x, textPos.y);

    if (text_debugEnabled) {
      println("displayScore:", displayScore, " actualScore:", actualScore);
    }
  }

  void update() {
    if (text_debugEnabled) {
      println("text x:", textPos.x, " y:", textPos.y);
    }
    if ( checkTimer() ) {
      if (text_debugEnabled) {
        println("adjusting pos of text");
      }
      textPos.y -= yMoveAmount;
    }
    if ( checkDestination() ) {
      killText();
      displayScore += num;

      if (text_debugEnabled) {
        println("text reached destination");
      }
    }
  }

  boolean checkTimer() {
    // if millis() catches up to my variable, return true
    if ( moveTimer < millis() ) {
      return true;
    } else return false;
  }

  boolean checkDestination() {
    int dist = 5; // pixels away from the text level that it disappears from
    if (text_debugEnabled) {

      println("textPos.y", textPos.y, " targetY", targetY);
    }
    if ( textPos.y-dist <= targetY ) {
      return true;
    } else return false;
  }

  boolean isOnScreen() { // check if the plane is on the screen
    // it spawns offscreen so i need to check where it starts
    if ( textPos.x < width+2 && textPos.x > -2 ) {

      return true;
    } else {
      return false;
    }
  }

  void killText() {
    textPos.x = width+100;
  }
}
