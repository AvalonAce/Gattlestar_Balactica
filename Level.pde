// Nathan Dejesus - Level Changing Handler

class levelHandler {
  
  Player player;
  Level currentLevel;
  Level[] levels = new Level[6];
  
  levelHandler(Player player, soundHandler soundHandler, graphicsHandler graphicsHandler) {
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

    // Update Main Menu Difficulty Button to read current difficulty
    switch (difficulty) {
      case 1:
        levels[0].getButton("Hard").setText("Easy");
        break;
      case 2:
        levels[0].getButton("Easy").setText("Medium");
        break;
      case 3:
        levels[0].getButton("Medium").setText("Hard");
        break;
      default:
      break;	
    }
    

    // Display difficulty
    
    
  }

  void setLevel(int newLevel) {
    currentLevel = levels[newLevel];
  }

  Level[] getLevels() {
    return levels;
  }

  void quit() {
    currentLevel.quit();
  }

}

class Level {

  void display() {}

  void update() {}

  rButton getButton(String buttonName) {
    return null;
  }

   void quit() {
    exit();
  }

}

class mainMenu extends Level {

  rButton startButton, quitButton, difficultyButton;
  levelHandler levelHandler;
  soundHandler soundHandler;
  boolean anim_title = false;

  mainMenu(levelHandler levelHandler, soundHandler soundHandler) {
    this.levelHandler = levelHandler;
    this.soundHandler = soundHandler;
    // Main Menu Buttons ---------------------
    startButton = new menuButton("Start", width/2 - 300, height/2 + 50, levelHandler, "", "menu_button_UH.png");
    quitButton = new menuButton("Quit",width/2 + 100, height/2 + 50, levelHandler, "", "menu_button_UH.png");
    difficultyButton = new menuButton( "Difficulty",width/2 - 100, height/2 + 250, levelHandler, "", "menu_button_UH.png");

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
    textFont(titleFont,148);
    textAlign(CENTER);

    // Animate Title
    if (anim_title && startTime + 5000 < millis()) {
      translate(0,-0,1);
    } 

    // Based on difficulty, change add title animation
    switch (difficulty) {
      case 1:
        text("Gattlestar\nBalactica", width/2, height/4);
        break;
      case 2:
        text("Gattlestar", width/2, height/4);
        fill(1, 206, 178);
        text("Balactica", width/2 + (random(-2,2)), height/4 + 171 + (random(-2,2)));
        break;
      case 3:
        fill(1, 206, 178);
        text("Gattlestar\nBalactica", width/2 + (random(-5,5)), height/4 + (random(-5,5)));
        break;
      default:
        text("Gattlestar\nBalactica", width/2,height/4);
        break;
    }

    
  }

  rButton getButton(String buttonName) {
    if (buttonName == "Start") {
      return startButton;
    } else if (buttonName == "Quit") {
      return quitButton;
    } else if (buttonName == "Difficulty" || buttonName == "Easy" || buttonName == "Medium" || buttonName == "Hard") {
      return difficultyButton;
    }
    return null;
  }

  void animateTitle() {
    anim_title = true;
  }



}

class mapLevel extends Level {}

class gameLevel1 extends Level {

    gameLevel1() {
    
    }

    void display() {
      background(0);
      fill(255);
      textFont(titleFont, 48);
      textAlign(CENTER);
      text("Game Level 1", width/2, height/2);
    }

    void update() {
      
    }


}

class gameLevel2 extends Level {}

class gameLevel3 extends Level {}

class gameLevel4 extends Level {}
