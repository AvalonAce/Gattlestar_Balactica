// Nathan Dejesus - Level Changing Handler

class levelHandler {
  
  Player player;
  Level currentLevel;
  levelEngine levelEngine;
  Level[] levels = new Level[9];
  int previousLevel = 0;
  
  levelHandler(Player player, soundHandler soundHandler, graphicsHandler graphicsHandler) {
    this.player = player;
    // Level Setup
    levels[0] = new mainMenu(this, soundHandler);
    levels[1] = new transition();
    levels[2] = new gameLevel1();
    levels[3] = new transition();
    levels[4] = new gameLevel2();
    levels[5] = new transition();
    levels[6] = new gameLevel3();
    levels[7] = new transition();
    levels[8] = new deathScreen(this);
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

  int getPreviousLevel() {
    return previousLevel;
  }

  void setPreviousLevel(int newPreviousLevel) {
    previousLevel = newPreviousLevel;
  }

  void quit() {
    currentLevel.quit();
  }

  levelEngine getLevelEngine() {
    return currentLevel.getLevelEngine();
  }

  void gameOver() {
    setLevel(8);
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

  void reset() {}

  levelEngine getLevelEngine() {
    return null;
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
    levelHandler.setPreviousLevel(0);
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
      startTime = currentSecond();
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

  void reset() {
    tHeight = height/4.0;
    getButton("Start").reset();
    getButton("Quit").reset();
    getButton("Difficulty").reset();
    tanim = false;
  }

 

}

class gameLevel1 extends Level {

    levelEngine levelEngine;
    boolean introFlag = true, exitFlag = false;

    gameLevel1() {
      levelEngine = new levelEngine();
    }

    void display() {
      background(0);
      levelEngine.setCurrentLevel(1);
      levelEngine.unhideLevelBar();
      levelEngine.displayLevelBar();


      if (introFlag) intro();
      else if (exitFlag) outro();
      else {
        // Graphics
        graphicsHandler.setFastStarAcc();

        // Level Start
        levelEngine.resume();
        levelEngine.update();

        // Fade out Menu
        dialogueHandler.display();
        dialogueHandler.update();
        dialogueHandler.menu().fadeGastorOut();
        dialogueHandler.menu().fadeDialogueBoxLOut();

        // Player Update
        player.display();
        player.update();

        // Level End
        if (levelEngine.levelOver()) {
          System.out.println("Level Over");
          levelEngine.pause();
          startTime = currentSecond();
          exitFlag = true;
        }
        
        
      }
      
    
    }

    void update() {
      levelHandler.setPreviousLevel(2);
    }

    void intro() {
      graphicsHandler.setStarFlag(true);
      player.reset();
      levelEngine.reset();
      levelEngine.pause();
      
      // System.out.println("Start Time: " + startTime);
      // System.out.println("Current Time: " + currentSecond());

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

        // Leave Cutscene
        if (dialogueHandler.isInCutscene()) return;
        else {
          player.enableFire();
          startTime = currentSecond();
          levelEngine.reset();
          levelEngine.resume();
          introFlag = false;
          }
        
      }
      // Start
      else if (currentSecond() > startTime) {
        player.display();
        player.update();
        player.drawTutorialMovement();
        
      }
      
    }

    void outro() {
      // Player
      player.display();
      player.update();
      
      // LevelEngine
      levelEngine.update();
      // Graphics
      graphicsHandler.setSlowStarAcc();

      // Cutscene
      if (currentSecond() > startTime + 5) {
        player.disableFire();

        // Menu
        dialogueHandler.setCutscene(true);
        dialogueHandler.display();
        dialogueHandler.update();

        // Cutscene
        if (dialogueHandler.isInCutscene()) {

          if (dialogueHandler.getCurrentSpeaker().equals("Gastor")){
            dialogueHandler.menu().fadeGastorIn();
            dialogueHandler.menu().fadeDialogueBoxLIn();
          }
          else {
            dialogueHandler.menu().fadeGastorOut();
            dialogueHandler.menu().fadeDialogueBoxLOut();
            // dialogueHandler.menu().hideGastor();
            // dialogueHandler.menu().hideDialogueBoxL();
            dialogueHandler.menu().fadeUnknownIn();
            dialogueHandler.menu().fadeDialogueBoxRIn();
          }
          if (dialogueHandler.isInChoice()) dialogueHandler.menu().fadeDialogueMenuIn();

        }
        else {
          levelEngine.reset();
          // levelEngine.resume();

          // Menu
          dialogueHandler.menu().fadeDialogueBoxROut();
          dialogueHandler.menu().fadeUnknownOut();
          dialogueHandler.menu().fadeGastorOut();
          dialogueHandler.menu().fadeDialogueBoxLOut();
          // dialogueHandler.menu().revealGastor();
          // dialogueHandler.menu().revealDialogueBoxL();

          // startTime = currentSecond();
          // exitFlag = false;
          // introFlag = true;

          // levelHandler.getLevels()[0].reset();
          // levelHandler.setLevel(0);
        }


        
      }
      
    }


    levelEngine getLevelEngine() {
      return levelEngine;
    }

    void reset() {
      introFlag = true;
      exitFlag = false;
      levelEngine.reset();
    }


}

class gameLevel2 extends Level {

  levelEngine levelEngine;
  boolean introFlag = true, exitFlag = false;

  gameLevel1() {
      levelEngine = new levelEngine();
  }

  void display() {

    
  }

  void update() {
    levelHandler.setPreviousLevel(4);
  }

  void intro() {

  }

  void outro() {

  }


  levelEngine getLevelEngine() {
      return levelEngine;
    }

    void reset() {
      introFlag = true;
      exitFlag = false;
      levelEngine.reset();
    }

}

class gameLevel3 extends Level {}

class gameLevel4 extends Level {}


class transition extends Level {


    transition() {}

    void display() {
      background(0);
    }

    void update() {}

}

class deathScreen extends Level {

    rButton restartButton, quitButton;
    levelHandler levelHandler;
    
    deathScreen(levelHandler levelHandler) {
      restartButton = new deathScreenButton("Restart", width/2 - 300, height/2 + 50, levelHandler, "", "menu_button_UH.png");
      quitButton = new deathScreenButton("Quit",width/2 + 100, height/2 + 50, levelHandler, "", "menu_button_UH.png");
    }

    void display() {
      background(0);
      titleDisplay();
      restartButton.display();
      quitButton.display();
    }

    void update() {
      // Graphics
      graphicsHandler.setStarFlag(false);
      restartButton.update();
      quitButton.update();
    }

    private void titleDisplay() {
      pushMatrix();
      fill(255);
      textFont(titleFont,148);
      textAlign(CENTER, CENTER);


      // Based on difficulty, change animation
      switch (difficulty) {
        case 1:
          fill(255);
          text("YOU DIED", width/2, height/2 - 150);
          break;
        case 2:
          fill(255);
          text("YOU", width/2 - 100, height/2 - 150);
          fill(1, 206, 178);
          text("DIED", width/2 + 75 + (random(-2,2)), height/2 + (random(-2,2)) - 150); 
          break;
        case 3:
          fill(1, 206, 178);
          text("YOU DIED", width/2 + (random(-5,5)), height/2 + (random(-5,5)) - 150);
          break;
        default:
          fill(255);
          text("YOU DIED", width/2, height/2 - 50);
          break;

      }

      popMatrix();
    }



}
