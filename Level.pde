// Nathan Dejesus - Level Changing Handler

class levelHandler {
  
  Player player;
  Level currentLevel;
  levelEngine levelEngine;
  Level[] levels = new Level[9];
  boolean restarted = false;
  int previousLevel = 0;
  
  levelHandler(Player player, soundHandler soundHandler, graphicsHandler graphicsHandler) {
    this.player = player;
    // Level Setup
    levels[0] = new mainMenu(this, soundHandler);
    levels[1] = new transition("Asteroid");
    levels[2] = new gameLevel1();
    levels[3] = new transition("Monster");
    levels[4] = new gameLevel2();
    levels[5] = new transition("Ship");
    levels[6] = new gameLevel3();
    levels[7] = new transition("End");
    levels[8] = new deathScreen(this);
    currentLevel = levels[3];
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

  void restartSound() {
    restarted = false;
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
    if (!restarted) {
      soundHandler.playSound("gameOver");
      restarted = true;
    }
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

  void trueExit() {}

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
      graphicsHandler.setStarFlag(false);
      graphicsHandler.setTitleFlag(false);
      levelHandler.setLevel(1);
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
    boolean introFlag = true, exitFlag = false, trueExitFlag = false;

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
      graphicsHandler.setTitleFlag(false);
      graphicsHandler.setSlowStarAcc();
      player.reset();
      player.display();
      player.update();
      levelEngine.reset();
      levelEngine.pause();


      // Several Seconds in
      if (currentSecond() > startTime + 5) {
        // Player 
        player.disableFire();

        // Menu
        dialogueHandler.setCutscene(true);
        dialogueHandler.display();
        dialogueHandler.update();
        dialogueHandler.menu().revealGastor();
        dialogueHandler.menu().revealDialogueBoxL();
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
            dialogueHandler.menu().fadeUnknownIn();
            dialogueHandler.menu().fadeDialogueBoxRIn();
          }
          if (dialogueHandler.isInChoice()) dialogueHandler.menu().fadeDialogueMenuIn();

        }
        else {

          // Menu
          dialogueHandler.menu().fadeDialogueBoxROut();
          dialogueHandler.menu().fadeUnknownOut();
          dialogueHandler.menu().fadeGastorOut();
          dialogueHandler.menu().fadeDialogueBoxLOut();


          // After all dialogue hidden, transition
          if (dialogueHandler.menu().allBoxesHidden()) {
            graphicsHandler.setStarFlag(false);
            graphicsHandler.setTitleFlag(true);
            graphicsHandler.setSuperFastStarAcc();
            // Speed up transition
            player.animateForwardDrive(2);
            cameraZ -= 20;
          }

          // Final Exit
          if (trueExitFlag) {
            cameraZ = (height/2.0) / tan(PI*30.0 / 180.0); // Reset Camera
            exitFlag = false;
            introFlag = true;
            startTime = currentSecond();
            levelHandler.getLevels()[2].reset();
            levelHandler.setLevel(3);
            player.resetShipToCenter();
            player.enableFire();
          }
        }


        
      }
      
    }


    levelEngine getLevelEngine() {
      return levelEngine;
    }

    void reset() {
      introFlag = true;
      exitFlag = false;
      trueExitFlag = false;
      levelEngine.reset();
    }

    void trueExit() {
      trueExitFlag = true;
    }


}

class gameLevel2 extends Level {

  levelEngine levelEngine;
  boolean introFlag = true, exitFlag = false, trueExitFlag = false;

  gameLevel2() {
      levelEngine = new levelEngine();
  }

  void display() {
    background(0);
    levelEngine.setCurrentLevel(2);
    levelEngine.unhideLevelBar();
    levelEngine.displayLevelBar();

    if (introFlag) intro();
    else if (exitFlag) outro();
    else { // Level 2
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
      dialogueHandler.menu().fadeUnknownOut();
      dialogueHandler.menu().fadeDialogueBoxROut();

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
    levelHandler.setPreviousLevel(4);
  }

  void intro() {
      graphicsHandler.setStarFlag(true);
      graphicsHandler.setTitleFlag(false);
      graphicsHandler.setSlowStarAcc();
      player.reset();
      player.display();
      player.update();
      levelEngine.reset();
      levelEngine.pause();

    if (currentSecond() > startTime + 2) {
      player.disableFire();

      // Menu
      dialogueHandler.setCutscene(true);
      dialogueHandler.display();
      dialogueHandler.update();
      dialogueHandler.menu().revealGastor();
      dialogueHandler.menu().revealUnknown();
      dialogueHandler.menu().revealDialogueBoxL();
      dialogueHandler.menu().revealDialogueBoxR();

        if (dialogueHandler.isInCutscene()) {

          if (dialogueHandler.getCurrentSpeaker().equals("Gastor")){
            dialogueHandler.menu().fadeGastorIn();
            dialogueHandler.menu().fadeDialogueBoxLIn();
          }
          else {
            dialogueHandler.menu().fadeGastorOut();
            dialogueHandler.menu().fadeDialogueBoxLOut();
            dialogueHandler.menu().fadeUnknownIn();
            dialogueHandler.menu().fadeDialogueBoxRIn();
          }
          if (dialogueHandler.isInChoice()) dialogueHandler.menu().fadeDialogueMenuIn();

        } else  {
          player.enableFire();
          startTime = currentSecond();
          levelEngine.reset();
          levelEngine.resume();
          introFlag = false;
        
        }


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
            dialogueHandler.menu().fadeUnknownIn();
            dialogueHandler.menu().fadeDialogueBoxRIn();
          }
          if (dialogueHandler.isInChoice()) dialogueHandler.menu().fadeDialogueMenuIn();

        }
        else {

          // Menu
          dialogueHandler.menu().fadeDialogueBoxROut();
          dialogueHandler.menu().fadeUnknownOut();
          dialogueHandler.menu().fadeGastorOut();
          dialogueHandler.menu().fadeDialogueBoxLOut();


          // After all dialogue hidden, transition
          if (dialogueHandler.menu().allBoxesHidden()) {
            graphicsHandler.setStarFlag(false);
            graphicsHandler.setTitleFlag(true);
            graphicsHandler.setSuperFastStarAcc();
            // Speed up transition
            player.animateForwardDrive(2);
            cameraZ -= 20;
          }

          // Final Exit
          if (trueExitFlag) {
            cameraZ = (height/2.0) / tan(PI*30.0 / 180.0); // Reset Camera
            exitFlag = false;
            introFlag = true;
            startTime = currentSecond();
            levelHandler.getLevels()[4].reset();
            levelHandler.setLevel(5);
            player.resetShipToCenter();
            player.enableFire();
          }
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

class gameLevel3 extends Level {}

class gameLevel4 extends Level {}


class transition extends Level {

    String type, title, level;
    SoundFile transitionSound;
    boolean played = false;

    transition(String type) {
      this.type = type;
      title = ""; level = "";
      transitionSound = soundHandler.getFile("transition");
    }



    void display() {
      background(0);
      graphicsHandler.setStarFlag(false);

      if (startTime + 8 < currentSecond()) {
        levelDecide();
      }
      else if (startTime + 6 < currentSecond()) {}
      else if (startTime + 3 < currentSecond()) {
        // Transition Word Display
        transitionTitle();
        switch (difficulty) {
          case 1:
            fill(255);
            text(level, width/2, height/2 - 100);
            text(title, width/2, height/2 + 50);
            break;
          case 2:
            fill(255);
            text(level, width/2, height/2 - 100);
            fill(1, 206, 178);
            text(title, width/2 + (random(-2,2)), height/2 + (random(-2,2)) + 50); 
            break;
          case 3:
            fill(1, 206, 178);
            text(level, width/2 + (random(-5,5)), height/2 + (random(-5,5)) - 100);
            text(title, width/2 + (random(-5,5)), height/2 + (random(-5,5)) + 50);
            break;
          default:
            fill(255);
            text(level, width/2, height/2 - 100);
            text(title, width/2, height/2 + 50);
            break;
        }

      }
      else if (startTime + 1 < currentSecond()) {
        // Play Transition Sound
        if (!played) {
          transitionSound.play();
          played = true;
        }
      }
      else if (startTime < currentSecond()) {
        
      }
      
    }

    void update() {
      player.deactivatePlayerCamera();
    }

    private void transitionTitle() {
      textFont(titleFont); textAlign(CENTER, CENTER);
      switch (type) {
        case "Asteroid":
          level = "ASTEROID";
          title = "FIELDS";
          break;
        case "Monster":
          level = "BOOTES";
          title = "MONSTRA";
          break;
        case "Ship":
          level = "THE VEIL";
          title = "FLEET";
          break;
        case "End":
          level = "GATTLESTAR";
          title = "BALACTICA";
          break;
        default:
          level = "ASTEROID";
          title = "FIELDS";
          break;
      }

    }

    private void levelDecide() {
      if (type == "Asteroid") levelHandler.setLevel(2);
      else if (type == "Monster") levelHandler.setLevel(4);
      else if (type == "Ship") levelHandler.setLevel(6);
      else if (type == "End") {
        played = false;
        levelHandler.setLevel(0);
        dialogueHandler.reset();
      }
      startTime = currentSecond();
    }

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
      player.deactivatePlayerCamera();
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
