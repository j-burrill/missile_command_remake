void draw() {
  background( backgroundColour );
  stroke(125, 83, 54);
  strokeWeight(0);
  fill(dirtColour);

  displayScreen();


  rect(0, height-floorHeight, width, floorHeight); // rectangle for the ground

  // only spawn enemies if it is enabled in the json
  boolean spawnEnemiesEnabled = cfg.getBoolean("game_spawnEnemies");
  boolean spawnPlanesEnabled = cfg.getBoolean("game_spawnPlanes");

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

  if ( menuOpen ) {
    drawMenu();
  } else {
    textSize(25);
    fill(255);
    String scoretxt = "Score: " + displayScore;

    text(scoretxt, 5, 30);
  }
}

void displayScreen() {

  for ( Tracer t : tracers ) { // display all my tracers each frame
    t.display();
  }
  for (Cannon c : cannons) { // display all my cannons each frame
    c.display();
  }
  for (Plane p : planes) { // display all my planes each frame
    if (p.isOnScreen()) {
      p.display();
    }
  }
  for (Fireball f : fireballs) { // display all my fireballs each frame
    f.display();
  }
  for (Missile m : missiles) { // do the following for each missile
    if ( m.isOnScreen() ) { // don't draw if it's outside of the screen, this is important because i kill the missiles by putting them outside
      m.checkUpdateTimer(); // move missile when its timer runs out
      m.display(); // display on each frame
    }
    //println("drawing line: starting x: " + a.startX + " starting y: "+ a.startY + " ending x: " + a.endX + " ending y: "+ a.endY);
  }
  for (Reticle r : reticles) { // display all my reticles each frame

    r.display();
  }
  for (Score_text t : texts) { // display all my tracers each frame
    if (t.isOnScreen()) {
      t.display();
    }
  }
}
