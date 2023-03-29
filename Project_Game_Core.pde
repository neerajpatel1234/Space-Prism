// ENUMS ---------------
State currentStatus;
enum State {
  IDLE, ACCELERATE, CRASH,
}

Level currentLevel;
enum Level {
  EASY, MEDIUM
}

// CONSTANTS ---------------
PImage background1, background2, background3;

PImage smlPlanet, medPlanet, bigPlanet;

PImage finishLine;

PImage[] idle = new PImage[10];
PImage[] accelerate = new PImage[8];
PImage[] crash = new PImage[8];

// IMAGES ---------------
int smlPlanetSize = 52;
int medPlanetSize = 72;
int bigPlanetSize = 110;

int rocketSize = 32;

// VARIABLES -----------------------------
int cameraX = 0;
int animFrame = 0;

float playerX = width/2;
float playerY = height*0.9;

int time = 0;
int totalGameTime = 0;

boolean gameWon = false;

// SETUP -----------------------------------------------------------------------------
void setup() {
  size (600, 600);
  currentStatus = State.IDLE;
  currentLevel = Level.EASY;
  resetPlayer();

  // Load Backgrounds ----------
  background1 = loadImage("Assets/background1.png");
  background2 = loadImage("Assets/background2.png");
  background3 = loadImage("Assets/background3.png");

  // Load Idle image ----------
  PImage idleSheet = loadImage("Assets/rocket_idle.png");
  for (int i = 0; i < idle.length; i++) {
    idle[i] = idleSheet.get(i*rocketSize, 0, rocketSize, rocketSize);
  }
  
  // Load Acceleration image ----------
  PImage accelerateSheet = loadImage("Assets/rocket_accelerate.png");
  for (int i = 0; i < accelerate.length; i++) {
    accelerate[i] = accelerateSheet.get(i*rocketSize, 0, rocketSize, rocketSize);
  }

  // Load Crash image ----------
  PImage crashSheet = loadImage("Assets/rocket_crash.png");
  for (int i = 0; i < crash.length; i++) {
    crash[i] = crashSheet.get(i*rocketSize, 0, rocketSize, rocketSize);
  }
  
  // Load Finish Line ----------
  finishLine = loadImage("Assets/finish_line.png");
  
  // Load Planets ----------
  smlPlanet = loadImage("Assets/sml_Planet.png");
  medPlanet = loadImage("Assets/med_Planet.png");
  bigPlanet = loadImage("Assets/big_Planet.png");
  
}

// DRAW -----------------------------------------------------------------------------
void draw() {  
  imageMode(CORNER);
  
  // ---------- FRAME RATE ----------
  if (currentStatus == State.IDLE){ animFrame = (frameCount/3)%10; }
  else{ animFrame = (frameCount/3)%8;}
  
  // ---------- GAME BOUNDARIES ----------
  // bottom ----
  if (playerY >= height - rocketSize){
    playerY = height - rocketSize;
  }
  
  // right ----
  if (playerX >= width - rocketSize){
    playerX = width - rocketSize;
  }
  
  // left ----
  if (playerX <= 0){
    playerX = 0;
  }

  // ---------- STATE READ ----------
    if (currentStatus == State.IDLE) {
      drawParallax(cameraX);
      drawCharacter(animFrame, idle);
    }
    
    if (currentStatus == State.ACCELERATE) {
      drawParallax(cameraX);
      drawCharacter(animFrame, accelerate);
    }
  
    if (currentStatus == State.CRASH) {
      drawParallax(cameraX);
      drawCharacter(animFrame, crash);
      lossGameSequance();
    }
  
  // ---------- CAMERA MOVEMENT ----------
    if (keyCode == RIGHT && currentStatus == State.ACCELERATE) {
      cameraX++;
    }
    
    else if (keyCode == LEFT && currentStatus == State.ACCELERATE) {
      cameraX--;
    }
    
  // ---------- SET LEVEL ----------
    if (currentLevel == Level.EASY){
      drawLevelEasy();     
    }
  
    if (currentLevel == Level.MEDIUM){
      drawLevelMedium();     
    }
    
    
  // ---------- WON GAME ----------
  if (playerY <= 10){
    wonGameSequance();
    gameWon = true;
  }
    
  // ---------- TIME ----------
  if (gameWon != true){
    time++ ;
    text("T: " + time/100, width*0.9, height*0.95);
  }
  
  // ---------- TESTING ----------
  //println("X: " + mouseX +"   ;   " + "Y: " + mouseY);
}

// METHODS -----------------------------------------------------------------------------

// RESET FOR NEXT LEVEL ---------------
void resetForLevel(){
  resetTime();
  resetPlayer();
  gameWon = false;
  currentStatus = State.IDLE;
  
}

// CAMERA SHIFT ---------------
  int world2ScreenX(int x, int y, int z) { 
    return (x - cameraX) / z; 
  }

// DRAW BACKGROUND --------------- 
void drawParallax(int cameraX) {

  // blue backgorund ----------
  image(background1, world2ScreenX(background1.width*((cameraX/background1.width)-1), 0, 3), 0);
  image(background1, world2ScreenX(background1.width*(cameraX/background1.width), 0, 3), 0);
  image(background1, world2ScreenX(background1.width*((cameraX/background1.width)+1), 0, 3), 0);

  // stars1 background
  image(background2, world2ScreenX(background2.width*((cameraX/background2.width)-1), 0, 2), 0);
  image(background2, world2ScreenX(background2.width*(cameraX/background2.width), 0, 2), 0);
  image(background2, world2ScreenX(background2.width*((cameraX/background2.width)+1), 0, 2), 0);
  
  // stars2 background
  image(background3, world2ScreenX(background3.width*((cameraX/background3.width)-1), 0, 1), 0);
  image(background3, world2ScreenX(background3.width*(cameraX/background3.width), 0, 1), 0);
  image(background3, world2ScreenX(background3.width*((cameraX/background3.width)+1), 0, 1), 0);
  
  // draw finish line 
  image(finishLine, 0 , -10);

}

// DRAW CHARACTER ---------------
void drawCharacter(int animFrame, PImage [] currentState) {
    image(currentState[animFrame], playerX, playerY);
}

// LOSS GAME SEQUANCE ---------------
void lossGameSequance(){
    currentStatus = State.CRASH;
    for(int j = 0 ; j > 8; j++){
      for(int i = 0 ; i > 8; i++){
        image(crash[i], playerX, playerY);
      }
    }
    resetTime();
    resetPlayer();
    println("! CRASHED !, player reset.");
}


// WON GAME SEQUANCE ---------------
void wonGameSequance(){
    float finishedTime = time/100;
    totalGameTime += finishedTime;
    text("GAME COMPLETE IN: " + finishedTime + " SECONDS", width*0.4, height*0.9);
    playerY = 10;
    delay(100);
    // next level ---------------
    if (currentLevel == Level.EASY){
      if (finishedTime <= 10){
        println("COMPLETE, Starting next level.");
        resetForLevel();
        currentLevel = Level.MEDIUM;      
      }
      else{
        println("Finished, however your too slow.");
        resetForLevel();
        currentLevel = Level.EASY;    
      }
    }
    else if (currentLevel == Level.MEDIUM){
      if (finishedTime <= 10){
        text("GAME COMPLETE IN: " + totalGameTime + " SECONDS", width*0.4, height*0.9);
        gameWon = true;
      }
      else{
        println("Finished, however your too slow.");
        resetForLevel();
        currentLevel = Level.MEDIUM;    
      }
  }
}

// RESET PLAYER ---------------
void resetPlayer(){
  playerX = width/2;
  playerY = height*0.9;
}

// RESET TIME ---------------
void resetTime(){
  time = 0; 
}

// KEY PRESSED ---------------
void keyPressed() {
  
  // ---------- Direction Movement ----------
  if (keyCode == UP ) {
    currentStatus = State.ACCELERATE;
    playerY = playerY - 4;
  }
  if(keyCode == DOWN){
    currentStatus = State.ACCELERATE;
    playerY = playerY + 4;
  }
  if (keyCode == LEFT) {
    currentStatus = State.ACCELERATE;
    playerX = playerX - 4;
  }
  if (keyCode == RIGHT ) {
    currentStatus = State.ACCELERATE;
    playerX = playerX + 4;
  }
  
  // ---------- Level Selection ----------
  if(keyCode == '1' ){
    resetForLevel();
    currentLevel = Level.EASY;
  }
  if(keyCode == '2' ){
    resetForLevel();
    currentLevel = Level.MEDIUM;
  }  
  
}

// KEY RELEASED ---------------
void keyReleased() { currentStatus = State.IDLE; }

// DRAW LEVELS -----------------------------------------------------------------------------

// DRAW EASY LEVEL ---------------------------------------
void drawLevelEasy(){
  imageMode(CENTER);
  /// big planets -----
  image(bigPlanet, 10, 100);
  image(bigPlanet, 123, 367);
  image(bigPlanet, 475, 50);
  image(bigPlanet, 300, 250);
  image(bigPlanet, 523, 444);
  
  // Collision Detection -----
  if ( (playerX >= (10 - bigPlanetSize/2 - rocketSize*0.6)) && (playerX <= (10 + bigPlanetSize/2 - rocketSize*0.4 )) && 
       (playerY >= (100 - bigPlanetSize/2 - rocketSize*0.6)) && (playerY <= (100 + bigPlanetSize/2 - rocketSize*0.4)) ) {
       currentStatus = State.CRASH;  
  }
  
  if ( (playerX >= (123 - bigPlanetSize/2 - rocketSize*0.6)) && (playerX <= (123 + bigPlanetSize/2 - rocketSize*0.4 )) && 
       (playerY >= (367 - bigPlanetSize/2 - rocketSize*0.6)) && (playerY <= (367 + bigPlanetSize/2 - rocketSize*0.4)) ) {
       currentStatus = State.CRASH;  
  }
  
  if ( (playerX >= (475 - bigPlanetSize/2 - rocketSize*0.6)) && (playerX <= (475 + bigPlanetSize/2 - rocketSize*0.4 )) && 
       (playerY >= (50 - bigPlanetSize/2 - rocketSize*0.6)) && (playerY <= (50 + bigPlanetSize/2 - rocketSize*0.4)) ) {
       currentStatus = State.CRASH;  
  }
  
  if ( (playerX >= (300 - bigPlanetSize/2 - rocketSize*0.6)) && (playerX <= (300 + bigPlanetSize/2 - rocketSize*0.4 )) && 
       (playerY >= (250 - bigPlanetSize/2 - rocketSize*0.6)) && (playerY <= (250 + bigPlanetSize/2 - rocketSize*0.4)) ) {
       currentStatus = State.CRASH;  
  }
    
  if ( (playerX >= (523 - bigPlanetSize/2 - rocketSize*0.6)) && (playerX <= (523 + bigPlanetSize/2 - rocketSize*0.4 )) && 
       (playerY >= (444 - bigPlanetSize/2 - rocketSize*0.6)) && (playerY <= (444 + bigPlanetSize/2 - rocketSize*0.4)) ) {
       currentStatus = State.CRASH;  
  }
}

// DRAW MEDIUM LEVEL ---------------------------------------
void drawLevelMedium(){
  imageMode(CENTER);
  // big planets -----
  image(bigPlanet, 100, 555);
  image(bigPlanet, 600, 120);
  image(bigPlanet, 300, 400);
  image(bigPlanet, 134, 300);
  image(bigPlanet, 325, 127);
  image(bigPlanet, 567, 555);
    
  // collision detection ----  
  if ( (playerX >= (100 - bigPlanetSize/2 - rocketSize*0.6)) && (playerX <= (100 + bigPlanetSize/2 - rocketSize*0.4 )) && 
       (playerY >= (555 - bigPlanetSize/2 - rocketSize*0.6)) && (playerY <= (555 + bigPlanetSize/2 - rocketSize*0.4)) ) {
       currentStatus = State.CRASH;  
  }  
  if ( (playerX >= (600 - bigPlanetSize/2 - rocketSize*0.6)) && (playerX <= (600 + bigPlanetSize/2 - rocketSize*0.4 )) && 
       (playerY >= (120 - bigPlanetSize/2 - rocketSize*0.6)) && (playerY <= (120 + bigPlanetSize/2 - rocketSize*0.4)) ) {
       currentStatus = State.CRASH;  
  }  
  if ( (playerX >= (300 - bigPlanetSize/2 - rocketSize*0.6)) && (playerX <= (300 + bigPlanetSize/2 - rocketSize*0.4 )) && 
       (playerY >= (400 - bigPlanetSize/2 - rocketSize*0.6)) && (playerY <= (400 + bigPlanetSize/2 - rocketSize*0.4)) ) {
       currentStatus = State.CRASH;  
  }  
  if ( (playerX >= (134 - bigPlanetSize/2 - rocketSize*0.6)) && (playerX <= (134 + bigPlanetSize/2 - rocketSize*0.4 )) && 
       (playerY >= (300 - bigPlanetSize/2 - rocketSize*0.6)) && (playerY <= (300 + bigPlanetSize/2 - rocketSize*0.4)) ) {
       currentStatus = State.CRASH;  
  }    
  if ( (playerX >= (325 - bigPlanetSize/2 - rocketSize*0.6)) && (playerX <= (325 + bigPlanetSize/2 - rocketSize*0.4 )) && 
       (playerY >= (127 - bigPlanetSize/2 - rocketSize*0.6)) && (playerY <= (127 + bigPlanetSize/2 - rocketSize*0.4)) ) {
       currentStatus = State.CRASH;  
  }  
  if ( (playerX >= (567 - bigPlanetSize/2 - rocketSize*0.6)) && (playerX <= (567 + bigPlanetSize/2 - rocketSize*0.4 )) && 
       (playerY >= (555 - bigPlanetSize/2 - rocketSize*0.6)) && (playerY <= (555 + bigPlanetSize/2 - rocketSize*0.4)) ) {
       currentStatus = State.CRASH;  
  }

  
  // med planets -----
  image(medPlanet, 450, 75);
  image(medPlanet, 468, 275);
  image(medPlanet, 84, 134);
  image(medPlanet, 24, 433);
    
  // collision detection
  if ( (playerX >= (450 - medPlanetSize/2 - rocketSize*0.6)) && (playerX <= (450 + medPlanetSize/2 - rocketSize*0.4 )) && 
       (playerY >= (75 - medPlanetSize/2 - rocketSize*0.6)) && (playerY <= (75 + medPlanetSize/2 - rocketSize*0.4)) ) {
       currentStatus = State.CRASH;  
  }
  if ( (playerX >= (468 - medPlanetSize/2 - rocketSize*0.6)) && (playerX <= (468 + medPlanetSize/2 - rocketSize*0.4 )) && 
       (playerY >= (275 - medPlanetSize/2 - rocketSize*0.6)) && (playerY <= (275 + medPlanetSize/2 - rocketSize*0.4)) ) {
       currentStatus = State.CRASH;  
  }
  if ( (playerX >= (84 - medPlanetSize/2 - rocketSize*0.6)) && (playerX <= (84 + medPlanetSize/2 - rocketSize*0.4 )) && 
       (playerY >= (134 - medPlanetSize/2 - rocketSize*0.6)) && (playerY <= (134 + medPlanetSize/2 - rocketSize*0.4)) ) {
       currentStatus = State.CRASH;  
  }
  if ( (playerX >= (24 - medPlanetSize/2 - rocketSize*0.6)) && (playerX <= (24 + medPlanetSize/2 - rocketSize*0.4 )) && 
       (playerY >= (433 - medPlanetSize/2 - rocketSize*0.6)) && (playerY <= (433 + medPlanetSize/2 - rocketSize*0.4)) ) {
       currentStatus = State.CRASH;  
  }
  
  // sml planets -----
  image(smlPlanet, 348 , 285);
  image(smlPlanet, 430 , 567);
  image(smlPlanet, 0 , 212);
  image(smlPlanet, 222 , 73);
  
  // collision detection
  if ( (playerX >= (348 - smlPlanetSize/2 - rocketSize*0.6)) && (playerX <= (348 + smlPlanetSize/2 - rocketSize*0.4 )) && 
       (playerY >= (285 - smlPlanetSize/2 - rocketSize*0.6)) && (playerY <= (285 + smlPlanetSize/2 - rocketSize*0.4)) ) {
       currentStatus = State.CRASH;  
  }
  if ( (playerX >= (430 - smlPlanetSize/2 - rocketSize*0.6)) && (playerX <= (430 + smlPlanetSize/2 - rocketSize*0.4 )) && 
       (playerY >= (567 - smlPlanetSize/2 - rocketSize*0.6)) && (playerY <= (567 + smlPlanetSize/2 - rocketSize*0.4)) ) {
       currentStatus = State.CRASH;  
  }
  if ( (playerX >= (0 - smlPlanetSize/2 - rocketSize*0.6)) && (playerX <= (0 + smlPlanetSize/2 - rocketSize*0.4 )) && 
       (playerY >= (212 - smlPlanetSize/2 - rocketSize*0.6)) && (playerY <= (212 + smlPlanetSize/2 - rocketSize*0.4)) ) {
       currentStatus = State.CRASH;  
  }
  if ( (playerX >= (222 - smlPlanetSize/2 - rocketSize*0.6)) && (playerX <= (222 + smlPlanetSize/2 - rocketSize*0.4 )) && 
       (playerY >= (73 - smlPlanetSize/2 - rocketSize*0.6)) && (playerY <= (73 + smlPlanetSize/2 - rocketSize*0.4)) ) {
       currentStatus = State.CRASH;  
  }

}
