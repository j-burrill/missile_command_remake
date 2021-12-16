

void keyPressed() {
  if (menuOpen) {
    if (key == SHIFT) { //shift for multiplayer
      //multiplayerEnabled = !multiplayerEnabled;
    } else if (key == TAB) {// control to switch default and custom cfg
      //println("switching cfg");
      switchcfg();
    } else if (key == ' ') { //spacebar to start
    startGame();
  }
}
if ( !multiplayerEnabled && !menuOpen ) { // check what cannon to fire
  findKey(key);
}
//if (userIsTyping) {
//  // code reused from my license plate generator
//  int mainLength = typedText.length();
//  if (key == BACKSPACE) {
//    if (mainLength > 0) {
//      String newText = typedText.substring(0, mainLength-1);// remove the last letter when backspace is pressed
//      typedText = newText;
//      mainLength--;
//    }
//  }
//  if (key != CODED && key != BACKSPACE && key != ENTER) {
//    typedText += key;
//  } // only print if it is a letter/num
//  if (key == ENTER) {
//    // submit when enter is pressed
//    userInitials = typedText;
//    userIsTyping = false;
//  }
//}
}

void switchcfg() {
  defaultcfg = !defaultcfg;
  setup();
  
}

void findKey(int key) {
  if (cannon_debugEnabled) {
    println(key);
  }

  int cannonPicked = 0;
  // check what key is pressed (number keys or home row) and fire according cannon
  // supports up to 10 cannons
  if (key == 'a' || key == 49) {
    cannonPicked = 0;
    
  } else if (key == 's' || key == 50) {
    cannonPicked = 1;
  } else if (key == 'd' || key == 51) {
    cannonPicked = 2;
  } else if (key == 'f' || key == 52) {
    cannonPicked = 3;
  } else if (key == 'g' || key == 53) {
    cannonPicked = 4;
  } else if (key == 'h' || key == 54) {
    cannonPicked = 5;
  } else if (key == 'j' || key == 55) {
    cannonPicked = 6;
  } else if (key == 'k' || key == 56) {
    cannonPicked = 7;
  } else if (key == 'l' || key == 57) {
    cannonPicked = 8;
  } else if (key == ';' || key == 48) {
    cannonPicked = 9;
  } else cannonPicked = -1; // set it to something weird so it doesn't shoot
  if (cannonPicked != -1 && cannonPicked <= cannons.size()-1) {
    cannons.get(cannonPicked).fireCannon();
  }
}
