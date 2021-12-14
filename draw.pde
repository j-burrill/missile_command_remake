/*
 I put the draw function in here so it's easier to find stuff
 */

void draw() {
  background( backgroundColour );
  stroke(125, 83, 54);
  strokeWeight(0);
  fill(dirtColour);

  rect(0, height-floorHeight, width, floorHeight); // rectangle for the ground

  for (int i = 0; i<tracers.size(); i++) { // display all my tracers each frame
    Tracer t = tracers.get(i);
    t.display();
  }

  for (int i = 0; i<cannons.size(); i++) { // display all my cannons each frame
    Cannon c = cannons.get(i);
    c.display();
  }

  for (int i = 0; i<planes.size(); i++) { // display all my planes each frame
    Plane p = planes.get(i);
    if (p.isOnScreen()) {
      p.display();
    }
  }

  for (int i = 0; i<fireballs.size(); i++) { // display all my fireballs each frame
    Fireball f = fireballs.get(i);
    f.display();
  }

  for (int i = 0; i<missiles.size(); i++) { // do the following for each missile
    Missile m = missiles.get(i);
    if ( m.isOnScreen() ) { // don't draw if it's outside of the screen, this is important because i kill the missiles by putting them outside
      m.checkUpdateTimer(); // move missile when its timer runs out
      m.display(); // display on each frame
    }
    //println("drawing line: starting x: " + a.startX + " starting y: "+ a.startY + " ending x: " + a.endX + " ending y: "+ a.endY);
  }

  for (int i = 0; i<reticles.size(); i++) { // display all my reticles each frame
    //if (game_debugEnabled) {
    //  println("reticles.size(): "+reticles.size());
    //}
    Reticle r = reticles.get(i);
    r.display();
  }

  for (int i = 0; i<texts.size(); i++) { // display all my tracers each frame
    Score_text t = texts.get(i);
    if (t.isOnScreen()) {
      t.display();
    }
  }

  // only spawn enemies if it is enabled in the json
  boolean spawnEnemiesEnabled = cfg.getBoolean("game_spawnEnemies");
  boolean spawnPlanesEnabled = cfg.getBoolean("game_spawnPlanes");

  //println( "enemyPlaneTimer:", enemyPlaneTimer, " millis():", millis() );

  if ( spawnEnemiesEnabled && millis() > enemyMissileTimer && !menuOpen ) { // spawn enemies every x milliseconds if menu is closed
    //println("enemytimer ran out");
    int borderOffset = 80; // no missiles right on the edge of the screen
    // get random spawn and finish points for the missile
    int targetX = int(random(borderOffset, width-borderOffset)); // pick a random point on the ground to target
    Point spawn = new Point( int(random(0, width)), 0);
    Point finish = new Point( targetX, height );
    spawnEnemyMissile( spawn, finish, null );
    int enemySpawnDelay = cfg.getInt("missile_enemySpawnDelay");
    // reset the spawn delay, only spawn missile every x milliseconds
    enemyMissileTimer = millis() + enemySpawnDelay; //1800
  }

  if ( spawnPlanesEnabled && millis() > enemyPlaneTimer && !menuOpen ) {

    int planeSize = cfg.getInt("plane_imgSize");
    int forceSpawn = cfg.getInt("plane_forceSpawn");
    boolean rightSideSpawn = false;
    // get random y pos
    int spawnY = getYpos();
    // spawn plane off the screen
    int spawnX = -(planeSize);
    // either 1 or -1
    int random = -1 + int(random(2)) * 2;
    // this is for debugging making the image flip
    if (forceSpawn == 1) {
      random=1;
    } else if (forceSpawn == 2) {
      random=-1;
    }
    if (random == -1) {
      rightSideSpawn = true;
      spawnX = -spawnX+width;
    }

    int bombX = int(random(300, width-300));
    Point spawnPoint = new Point(spawnX, spawnY);
    spawnPlane(spawnPoint, bombX, rightSideSpawn);
    int planeSpawnDelay = cfg.getInt("plane_enemySpawnDelay");

    enemyPlaneTimer = millis() + planeSpawnDelay; //1800
  }

  String scoretxt = "Score: " + displayScore;

  if ( menuOpen ) {
    if ( actualScore>highscore ) { //update highscore if you beat it
      newHighScore();
    }
    fill(255);
    textSize(30);


    // draw all the text on my menu
    String hscoretxt = "Highscore: " + highscore;
    String tutorialtxt = "Use number keys or home row keys to fire your missiles";
    String menutxt = "Press enter to start" + menuTxt2();
    String multiplayerInstructiontxt = "Press space to toggle multiplayer";
    String multiplayerEnabledtxt = "Multiplayer enabled: " + multiplayerEnabled;

    text(scoretxt, centreText(scoretxt), height/2-60);
    text(hscoretxt, centreText(hscoretxt), height/2-30);
    text(tutorialtxt, centreText(tutorialtxt), height/2+0);
    text(multiplayerInstructiontxt, centreText(multiplayerInstructiontxt), height/2+30);
    text(menutxt, centreText(menutxt), height/2+60);
    textSize(20);
    text(multiplayerEnabledtxt, 5, 22);
  } else if (!menuOpen) {
    textSize(25);
    fill(255);
    text(scoretxt, 5, 30);
  }
}

int centreText( String txt ) {
  //this centers the score to the middle of the screen constantly by getting its width

  return int(width/2-textWidth(txt)/2);
}

void newHighScore() {
  highscore=actualScore; // set the highscore to your new score

  
  // array of all my high scores already in the file
  String[] scores = loadStrings("highscores.txt");
  // new printwriter object
  PrintWriter output;
  output = createWriter("highscores.txt");

  // write each line in the file back into it, because it gets cleared when i make the printwriter
  for (int i = 0; i<scores.length; i++) {
    output.println(scores[i]);
  }
  
  // add new highscore to the file
  output.println(highscore);

  
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
  println("writing to highscores file");
}
