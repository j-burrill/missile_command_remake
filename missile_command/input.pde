

void keyPressed() {
  if (menuOpen) {
    if (key == TAB) {// control to switch default and custom cfg
      switchcfg();
    } else if (key == ' ' && !userTyping) { //spacebar to start
      startGame();
    }
  }

  if ( cfgs[cfgIndex] != "multiplayer" && !menuOpen ) { // check what cannon to fire
    findKey(key);
  }

  if (cfgs[cfgIndex] == "multiplayer" && !menuOpen) {
    if (keyCode == SHIFT) {
      redplayer.fire();
    }
    if (keyCode == CONTROL) {
      blueplayer.fire();
    }

    if (key == 'a') {
      redplayer.leftHeld = true;
    }
    if (key == 'd') {
      redplayer.rightHeld = true;
    }
    if (key == 'w') {
      redplayer.upHeld = true;
    }
    if (key == 's') {
      redplayer.downHeld = true;
    }

    if (keyCode == LEFT) {
      blueplayer.leftHeld = true;
    }
    if (keyCode == RIGHT) {
      blueplayer.rightHeld = true;
    }
    if (keyCode == UP) {
      blueplayer.upHeld = true;
    }
    if (keyCode == DOWN) {
      blueplayer.downHeld = true;
    }
  }
  if (userTyping) {
    // code reused from my license plate generator
    int mainLength = typedText.length();
    if (key == BACKSPACE) {
      if (mainLength > 0) {
        String newText = typedText.substring(0, mainLength-1);// remove the last letter when backspace is pressed
        typedText = newText;
        mainLength--;
      }
    }
    if (key != CODED && key != BACKSPACE && key != ENTER) {
      // type a character if it isn't backspace/enter
      typedText += key;
    }
    if (key == ENTER && hsIndex < 3) {
      // submit when enter is pressed
      HighScores currentHS = highScoresObjs.get(hsIndex);
      currentHS.saveScore(typedText.toUpperCase());
      userTyping = false;
    }
  }
}


void keyReleased() {
  if (cfgs[cfgIndex] == "multiplayer" && !menuOpen) {
    if (key == 'a') {
      redplayer.leftHeld = false;
    }
    if (key == 'd') {
      redplayer.rightHeld = false;
    }
    if (key == 'w') {
      redplayer.upHeld = false;
    }
    if (key == 's') {
      redplayer.downHeld = false;
    }

    if (keyCode == LEFT) {
      blueplayer.leftHeld = false;
    }
    if (keyCode == RIGHT) {
      blueplayer.rightHeld = false;
    }
    if (keyCode == UP) {
      blueplayer.upHeld = false;
    }
    if (keyCode == DOWN) {
      blueplayer.downHeld = false;
    }
  }
}

void switchcfg() {

  if (cfgIndex+1 == cfgs.length ) {
    cfgIndex = 0;
  } else {
    cfgIndex++;
  }
  if (hsIndex+1 == highScoresObjs.size()) {
    hsIndex = 0;
  } else {
    hsIndex++;
  }

  setup();
}

void findKey(int key) {
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
    cannons.get(cannonPicked).fireCannon(mouseX, mouseY);
  }
}

int getYpos() {
  int top = 100;
  int bottom = height - (floorHeight + 400);
  return int(random(top, bottom));
}
