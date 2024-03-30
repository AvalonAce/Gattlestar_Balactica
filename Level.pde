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
    currentLevel = levels[2];
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

boolean tanim = false;
class mainMenu extends Level {

  rButton startButton, quitButton, difficultyButton;
  levelHandler levelHandler;
  soundHandler soundHandler;
  float tHeight = height/4.0;


  mainMenu(levelHandler levelHandler, soundHandler soundHandler) {
    this.levelHandler = levelHandler;
    this.soundHandler = soundHandler;
    // Main Menu Buttons ---------------------
    startButton = new menuButton("Start", width/2 - 300, height/2 + 50, levelHandler, "", "menu_button_UH.png");
    quitButton = new menuButton("Quit",width/2 + 100, height/2 + 50, levelHandler, "", "menu_button_UH.png");
    difficultyButton = new menuButton( "Difficulty",width/2 - 100, height/2 + 250, levelHandler, "", "menu_button_UH.png");

  }

  void display() {
    background(0);
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
    fill(255);
    textFont(titleFont,148);
    textAlign(CENTER);
    camera(cameraX, cameraY, cameraZ, centerX, centerY, centerZ, 0, 1, 0);

    

    // Animate Title
    if (tanim && startTime + 4000 > millis()) {
      // Move Title downward
      tHeight += 2;
      if (tHeight > height/2 - 50) {
        tHeight = height/2 - 50;
      }
      
    } else if (tanim && startTime + 4000 < millis()) {
      tanim = false;
      startTime = 0;
      graphicsHandler.setStarFlag(false);
      graphicsHandler.setTitleFlag(false);
      levelHandler.setLevel(2);
      startTime = millis();
      graphicsHandler.moveStarsBack();
    }

    // Based on difficulty, change add title animation
    switch (difficulty) {
      case 1:
        text("Gattlestar\nBalactica", width/2, tHeight);
        break;
      case 2:
        text("Gattlestar", width/2, tHeight);
        fill(1, 206, 178);
        text("Balactica", width/2 + (random(-2,2)), tHeight + 171 + (random(-2,2)));
        break;
      case 3:
        fill(1, 206, 178);
        text("Gattlestar\nBalactica", width/2 + (random(-5,5)), tHeight + (random(-5,5)));
        break;
      default:
        text("Gattlestar\nBalactica", width/2,tHeight);
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

 

}

class mapLevel extends Level {}

class gameLevel1 extends Level {

    // Menu menu;
    levelEngine levelEngine;
    boolean introFlag = true, exitFlag = false;

    gameLevel1() {
      // menu = new Menu();
      levelEngine = new levelEngine();
    }

    void display() {
      background(0);
      
      levelEngine.setCurrentLevel(1);
      levelEngine.update();
      levelEngine.displayLevelBar();

      introFlag = false;
      if (introFlag) intro();
      else if (exitFlag) outro();
      else {
        // Graphics
        graphicsHandler.setFastStarAcc();

        // Level Start
        levelEngine.resume();

        // Fade out Menu
        dialogueHandler.display();
        dialogueHandler.update();
        dialogueHandler.menu().fadeGastorOut();
        dialogueHandler.menu().fadeDialogueBoxLOut();

        // Player
        player.display();
        player.update();
        
        
      }
      
    
    }

    void update() {

      
    }

    void intro() {
      graphicsHandler.setStarFlag(true);
      startTime = 0;
      player.reset();
      levelEngine.reset();

      // Several Seconds in
      if (currentSecond() > startTime + 5) {
        // Player 
        player.display();
        player.update();
        player.disableFire();

        // Menu
        dialogueHandler.setCutscene(true);
        dialogueHandler.display();
        dialogueHandler.update();
        dialogueHandler.menu().fadeGastorIn();
        dialogueHandler.menu().fadeDialogueBoxLIn();
        if (dialogueHandler.isInChoice()) dialogueHandler.menu().fadeDialogueMenuIn();

        if (dialogueHandler.isInCutscene()) return;
        else {
          player.enableFire();
          introFlag = false;
          }
        
      }
      // Start
      else if (currentSecond() > startTime) {
        player.display();
        player.update();
        player.drawTutorialMovement();
        levelEngine.pause();
      }
      
    }

    void outro() {
      
    }


}

class gameLevel2 extends Level {}

class gameLevel3 extends Level {}

class gameLevel4 extends Level {}
