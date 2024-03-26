// Nathan Dejesus - Level Changing Handler

class levelHandler {
  
  Player player;
  Level currentLevel;
  Level[] levels = new Level[6];
  
  levelHandler(Player player, soundHandler soundHandler) {
    this.player = player;
    // Level Setup
    levels[0] = new mainMenu(this, soundHandler);
    levels[1] = new mapLevel();
    levels[2] = new gameLevel1();
    levels[3] = new gameLevel2();
    levels[4] = new gameLevel3();
    levels[5] = new gameLevel4();
    currentLevel = levels[0];
  }

  void display() {
    // Call draw function of current level
    currentLevel.display();
  }

  void update() {
    // Call update function of current level
    currentLevel.update();
  }
  void changeDifficulty() {

    difficulty++;
    if (difficulty > 3) difficulty = 1;

    // Display difficulty
    
    
  }

  void setLevel(int newLevel) {
    currentLevel = levels[newLevel];
  }

  void quit() {
    currentLevel.quit();
  }

}

class Level {

  void display() {}

  void update() {}

   void quit() {
    exit();
  }

}

class mainMenu extends Level {

  rButton startButton, quitButton, difficultyButton;
  levelHandler levelHandler;
  soundHandler soundHandler;

  mainMenu(levelHandler levelHandler, soundHandler soundHandler) {
    this.levelHandler = levelHandler;
    this.soundHandler = soundHandler;
    // Main Menu Buttons ---------------------
    startButton = new menuButton("Start", width/2 - 300, height/2 + 50, levelHandler);
    quitButton = new menuButton("Quit",width/2 + 100, height/2 + 50, levelHandler);
    difficultyButton = new menuButton( "Difficulty",width/2 - 100, height/2 + 250, levelHandler);
  }

  void display() {
    displayTitle();
    startButton.display();
    quitButton.display();
    difficultyButton.display();
  }

  void update() {
    startButton.update();
    quitButton.update();
    difficultyButton.update();
  }

  void displayTitle() {
    background(0);
    fill(255);
    textSize(82);
    textAlign(CENTER);
    text("Gattlestar\nBalactica", width/2, height/4);
  }



}

class mapLevel extends Level {}

class gameLevel1 extends Level {}

class gameLevel2 extends Level {}

class gameLevel3 extends Level {}

class gameLevel4 extends Level {}
