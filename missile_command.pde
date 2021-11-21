/*
Justin Burrill
 Nov 02 2021
 Missile command for the Atari recreation
 
 to do:
 make the tracer stay after the line splits currently the splitpos follows the tail pos offscreen
 find better system for cannon controls
 make levels and proper system
 make colours change with waves/levels
 */

ArrayList<Missile> missiles = new ArrayList<Missile>(); // list of all my missiles
ArrayList<Fireball> fireballs = new ArrayList<Fireball>(); // list of all my fireballs
ArrayList<Cannon> cannons = new ArrayList<Cannon>(); // list of all my fireballs
ArrayList<Tracer> tracers = new ArrayList<Tracer>(); // list of all my tracers
ArrayList<Reticle> reticles = new ArrayList<Reticle>(); // list of all my reticles

JSONObject cfg; // some settings are written in a json file

boolean game_debugEnabled;

int floorHeight, cannonCount;
int enemyTimer = 0;
boolean menuOpen = true;
int score, hscore;

color dirtColour, backgroundColour;
color black = color(0);
color white = color(255);
color red = color(255, 0, 0);
color pink = color(255, 0, 242);
color blue = color(0, 0, 255);
color green = color(0, 255, 0);
color cyan = color(0, 255, 247);
color yellow = color(255, 251, 0);
color[] colourArray = { black, white, yellow, pink, red, cyan, green, blue };

boolean cannon_debugEnabled;

//int menuUpdateDelay = cfg.getInt("menu_textUpdateDelay");
int menuUpdateDelay;
int currentMenuUpdateDelay = menuUpdateDelay;
int menuIndex = 0;
String menuText2;


void setup() {
  cfg = loadJSONObject("cfg.json"); // get settings from the json file
  floorHeight = cfg.getInt("level_floorHeight");
  cannonCount = cfg.getInt("cannon_cannonCount");
  backgroundColour = color(0); // (0)
  dirtColour = color(125, 83, 54); // (color(125, 83, 54)
  game_debugEnabled = cfg.getBoolean("debug_game");
  menuUpdateDelay = cfg.getInt("menu_textUpdateDelay");
  cannon_debugEnabled = cfg.getBoolean("debug_cannon");

  size(800, 800);

  for (int i = 0; i < cannonCount; i++) {
    //println("new cannon made");
    cannons.add(new Cannon(i)); // make my cannons
  }
  if (cannonCount > 10 || cannonCount < 1) {
    println("cannon count out of bounds");
  }
}

String menuTxt2() { // this handles the fun little animation on the main menu
  String[] periodArray = {".  ", ".. ", "..."};
  currentMenuUpdateDelay--;

  if (currentMenuUpdateDelay <= 0) {
    menuText2 = periodArray[menuIndex];
    menuIndex = (menuIndex != periodArray.length - 1) ? menuIndex + 1 : 0;
    currentMenuUpdateDelay = menuUpdateDelay;
  }

  return menuText2;
}

void resetScreen() {
  missiles.clear(); //clear everything off screen
  fireballs.clear();
  tracers.clear();
}

void newMissile(Point start, Point finish, boolean player, Missile parent) {
  Missile m = new Missile(start, finish, player, parent);
  missiles.add(m); // makea new missile in my array
  spawnTracer(m, player); // new tracer with the missile as its parent
  if (player) {
    newReticle(m);
  } // only the player's missiles get reticles
}

void spawnEnemyMissile(Point spawn, Point finish, Missile parent) {
  //enemies are just missiles but a bit different
  // println("new missile finish.x: " + finish.x + " finish.y: " + finish.y);
  newMissile(spawn, finish, false, parent);
}

void newReticle(Missile m) {
  // if (game_debugEnabled) {
  //println("new reticle created");
  //}
  Reticle r = new Reticle(mouseX, mouseY, m); // make a new reticle where the mouse is and tie it to the missile
  reticles.add(r); // add it to the array
}

void newFireball(int x, int y, int size) {
  //println("fireball made");
  fireballs.add(new Fireball(x, y, size)); // make a new object for each fireball and and to array
}

void spawnTracer(Missile m, boolean player) {
  Tracer t = new Tracer(m, player);
  tracers.add(t);
}

void drawCentreLine() { // used for making sure my cannons are in the right spots and stuff
  stroke(255);
  strokeWeight(2);
  line(width / 2, 0, width / 2, height);
}

int nextIndex(int in) {
  int out = in != colourArray.length - 1 ? in + 1 : 0;
  return out;
}

color getColour(int index) {
  return colourArray[index];
}

void mousePressed() {
  if (menuOpen) { // when reseting game:
    menuOpen = false; // close menu
    score = 0; // reset score
    int enemyStartingSpawnDelay = cfg.getInt("missile_enemyStartingSpawnDelay");
    enemyTimer = millis() + enemyStartingSpawnDelay;// delay before starting
    resetScreen();
    for (int i = 0; i < cannons.size(); i++) { // reset ammo
      Cannon c = cannons.get(i);
      c.reset();
    }
  }
}

void keyPressed() { // checkwhat button is pressed
  findKey(key); // in cannon
}

void findKey(int key) {
  if (cannon_debugEnabled) {
    println(key);
  }
  int cannon = 0;
  if (key == 'a' || key == 49) {
    cannon = 0;
  }
  if (key == 's' || key == 50) {
    cannon = 1;
  }
  if (key == 'd' || key == 51) {
    cannon = 2;
  }
  if (key == 'f' || key == 52) {
    cannon = 3;
  }
  if (key == 'g' || key == 53) {
    cannon = 4;
  }
  if (key == 'h' || key == 54) {
    cannon = 5;
  }
  if (key == 'j' || key == 55) {
    cannon = 6;
  }
  if (key == 'k' || key == 56) {
    cannon = 7;
  }
  if (key == 'l' || key == 57) {
    cannon = 8;
  }
  if (key == ';' || key == 48) {
    cannon = 9;
  }

  if (cannon <=  cannons.size()) {
    cannons.get(cannon).fireCannon();
  }
}
