// Nathan Dejesus - Level Changing Handler

class levelHandler {
  
  Player player;
  Level currentLevel;
  Level[] levels = new Level[6];
  int difficulty = 0;
  
  levelHandler(Player player) {
    this.player = player;
    // Level Setup
    levels[0] = new mainMenu();
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
  }

  void setDifficulty(int difficulty) {
    this.difficulty = difficulty;
  }

  void changeLevel(Level newLevel) {
    currentLevel = newLevel;
  }

  void quit() {
    currentLevel.quit();
  }

}

class Level {

  void display() {}

   void quit() {
    exit();
  }

}

class mainMenu extends Level {

  rButton startButton, quitButton, difficultyButton;

  mainMenu() {
    // Main Menu Buttons ---------------------
    startButton = new menuButton("Start", width/2 - 200, height/2 + 100);
    quitButton = new menuButton("Quit",width/2 + 200, height/2 + 100);
    difficultyButton = new menuButton( "Difficulty",width/2, height/2 + 300);
  }

  void display() {
    displayTitle();
    startButton.display();
    quitButton.display();
    difficultyButton.display();
    
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
