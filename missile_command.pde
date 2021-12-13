/*
Justin Burrill
 Nov 02 2021
 Missile command for the Atari recreation
 
 to do:
 *** make the score fade in the colour red or green depending
 
 *** fix missile split
 make the tracer stay after the line splits currently the splitpos follows the tail pos offscreen
 ^^ then make another constructor that allows missiles to have a plane as a parent, basically the same issue as the split missile
 
 
 find better system for cannon controls
 make levels and proper system or make it harder as it goes on
 make colours change with waves/levels
 
 
 fix planes
 fix multiplayer
 */

// lists for each object that needs to be updated each frame
ArrayList<Missile> missiles = new ArrayList<Missile>();
ArrayList<Fireball> fireballs = new ArrayList<Fireball>();
ArrayList<Cannon> cannons = new ArrayList<Cannon>();
ArrayList<Tracer> tracers = new ArrayList<Tracer>();
ArrayList<Reticle> reticles = new ArrayList<Reticle>();
ArrayList<Plane> planes = new ArrayList<Plane>();

// some settings are written in a json file, object is created here
JSONObject cfg;
// create certain variables that need to be accessed globally
boolean game_debugEnabled;
boolean multiplayerEnabled;

int floorHeight, cannonCount;
int enemyMissileTimer = 0, enemyPlaneTimer = 0;
boolean menuOpen = true;
int score, hscore;

color dirtColour, backgroundColour;
color[] colourArray = new color[8];

boolean cannon_debugEnabled;

//int menuUpdateDelay = cfg.getInt("menu_textUpdateDelay");
int menuUpdateDelay;
int currentMenuUpdateDelay = menuUpdateDelay;
int menuIndex = 0;
String menuText2;


void setup() {
  // get settings from the json file
  cfg = loadJSONObject("cfg.json");
  floorHeight = cfg.getInt("game_floorHeight");
  cannonCount = cfg.getInt("cannon_cannonCount");
  game_debugEnabled = cfg.getBoolean("debug_game");
  menuUpdateDelay = cfg.getInt("menu_textUpdateDelay");
  cannon_debugEnabled = cfg.getBoolean("debug_cannon");
  multiplayerEnabled = cfg.getBoolean("game_multiplayerDefault");

  backgroundColour = color(0); // (0)
  dirtColour = color(125, 83, 54); // (color(125, 83, 54)

  // size of the window
  size(800, 800);

  // make my cannons
  for (int i = 0; i < cannonCount; i++) {
    //println("new cannon made");
    cannons.add(new Cannon(i));
  }

  // gives warning if the amount of cannons is too much or too little and isn't won't work with the controls
  if (cannonCount > 10 || cannonCount < 1) {
    println("cannon count out of bounds");
  }
}

String menuTxt2() {
  // this handles the fun little animation on the main menu
  String[] periodArray = {".  ", ".. ", "..."};
  currentMenuUpdateDelay--;
  // goes through the array at the rate specified in the config file
  if (currentMenuUpdateDelay <= 0) {
    menuText2 = periodArray[menuIndex];
    menuIndex = (menuIndex != periodArray.length - 1) ? menuIndex + 1 : 0;
    currentMenuUpdateDelay = menuUpdateDelay;
  }
  return menuText2;
}

void resetScreen() {
  // clear everything off screen
  missiles.clear();
  fireballs.clear();
  tracers.clear();
  planes.clear();
  reticles.clear();
}

void newMissile(Point start, Point finish, boolean player, Missile parent) {
  Missile m = new Missile(start, finish, player, parent);
  missiles.add(m); // make a new missile in my array
  spawnTracer(m, player); // new tracer with the missile as its parent
  if (player) {
    // only the player's missiles get reticles
    newReticle(m);
  }
}

void spawnEnemyMissile(Point spawn, Point finish, Missile parent) {
  // this calls the newMissile() function with parameters for an enemy missile
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
  // create tracer with the missile as its parent
  Tracer t = new Tracer(m, player);
  // and add it to the array
  tracers.add(t);
}

int getYpos() {
  int top = 100;
  int bottom = height - (floorHeight + 400);
  return int(random(top, bottom));
}

void spawnPlane( Point startingPos, int bombX, boolean movingLeft ) {
  Plane p = new Plane( startingPos, bombX, movingLeft );
  planes.add(p);
}

void drawCentreLine() { // used for making sure my cannons are in the right spots and stuff
  // unused
  stroke(255);
  strokeWeight(2);
  line(width / 2, 0, width / 2, height);
}

int nextIndex(int in) {
  // this is for making the fireballs and reticles flash colours
  // return the next one in the array, jump back to the start if you're at the end
  int out = in != colourArray.length - 1 ? in + 1 : 0;
  return out;
}

color getColour(int index) {
  // return the colour in the array
  colourArray[0] = color(0);
  colourArray[1] = color(255);
  colourArray[2] = color(255, 0, 0);
  colourArray[3] = color(255, 0, 242);
  colourArray[4] = color(0, 0, 255);
  colourArray[5] = color(0, 255, 0);
  colourArray[6] = color(0, 255, 247);
  colourArray[7] = color(255, 251, 0);

  return colourArray[index];
}

void startGame() {
  menuOpen = false; // close menu
  score = 0; // reset score
  int enemyStartingSpawnDelay = cfg.getInt("missile_enemyStartingSpawnDelay");
  int enemyPlaneStartingSpawnDelay = cfg.getInt("plane_enemyStartingSpawnDelay");

  enemyMissileTimer = millis() + enemyStartingSpawnDelay;// delay before starting
  enemyPlaneTimer = millis() + enemyPlaneStartingSpawnDelay;
  resetScreen();
  for (int i = 0; i < cannons.size(); i++) { // reset ammo
    Cannon c = cannons.get(i);
    c.reset();
  }
}

void keyPressed() {
  if (menuOpen) {
    if (key == ' ') { //spacebar
      multiplayerEnabled = !multiplayerEnabled;
    } else if (key == ENTER || key == RETURN) { //enter
      startGame();
    }
  }
  if ( !multiplayerEnabled && !menuOpen ) { // check what cannon to fire
    findKey(key);
  }
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

  if (cannonPicked != -1 && cannonPicked <= cannons.size()) {
    cannons.get(cannonPicked).fireCannon();
  }
}

void addScore(int amt) {
  score+=amt;
}
