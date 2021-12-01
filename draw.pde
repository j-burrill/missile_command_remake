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
  
  for (int i = 0; i<planes.size(); i++) { // display all my fireballs each frame
    Plane p = planes.get(i);
    //println("drawing plane");
    //p.display();
  }

  for (int i = 0; i<fireballs.size(); i++) { // display all my fireballs each frame
    Fireball f = fireballs.get(i);
    f.display();
  }

  for (int i = 0; i<missiles.size(); i++) { // do the following for each missile
    Missile m = missiles.get(i);
    if ( m.isOnScreen() ) { // don't draw if it's outside of the screen, this is important because i kill the missiles by putting them outside
      m.checkUpdateTimer(); // move missile when it's timer runs out
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
  
  boolean spawnEnemiesEnabled = cfg.getBoolean("game_spawnEnemies");
  
  if ( spawnEnemiesEnabled && millis() > enemyTimer && !menuOpen ) { // spawn enemies every x milliseconds if menu is closed
    //println("enemytimer ran out");
    int borderOffset = 80; // no missiles right on the edge of the screen
    int targetX = int(random(borderOffset, width-borderOffset)); // pick a random point on the ground to target

    Point spawn = new Point( int(random(0, width)), 0);
    Point finish = new Point( targetX, height );
    spawnEnemyMissile( spawn, finish, null );
    int enemySpawnDelay = cfg.getInt("missile_enemySpawnDelay");
    enemyTimer = millis() + enemySpawnDelay; //1800
  }

  if ( menuOpen ) {
    if ( score>hscore ) { //update highscore if you beat it
      hscore=score;
    }
    fill(255);
    textSize(30);
    /*
      width/2-textWidth(str(score))/2
     this centers the score to the middle of the screen constantly by getting its width
     */
    String scoretxt = "Score: " + score;
    String hscoretxt = "Highscore: " + hscore;
    String tutorialtxt = "Use number keys or home row keys to fire your missiles";
    String menutxt = "Click to start"+menuTxt2();


    text(scoretxt, width/2-textWidth(scoretxt)/2, height/2-50);
    text(hscoretxt, width/2-textWidth(hscoretxt)/2, height/2-16);
    text(tutorialtxt, width/2-textWidth(tutorialtxt)/2, height/2+16);
    text(menutxt, width/2-textWidth(menutxt)/2, height/2+50);
  }
}
