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
    
    
  }

  void setLevel(int newLevel) { // Setter
    currentLevel = levels[newLevel];
  }

  void restartSound() { // Restarts Sound
    restarted = false;
  }

  Level[] getLevels() { // Getter
    return levels;
  }

  int getPreviousLevel() { // Getter
    return previousLevel;
  }

  void setPreviousLevel(int newPreviousLevel) { // Setter
    previousLevel = newPreviousLevel;
  }

  void quit() { // Quits
    currentLevel.quit();
  }

  levelEngine getLevelEngine() { // Getter
    return currentLevel.getLevelEngine();
  }

  void gameOver() { // Game Over
    if (!restarted) {
      soundHandler.playSound("gameOver");
      soundHandler.playMusic("pause");
      restarted = true;
    }
    setLevel(8);
  }

  void newMainMenu() { // New Main Menu
    levels[0] = new mainMenu(this, soundHandler);
  }

}

class Level { // Level Class

  void display() {} // Display Function

  void update() {} // Update Function

  rButton getButton(String buttonName) { // Get Button Function
    return null;
  }

   void quit() { // Quit Function
    exit();
  }

  void reset() {} // Reset Function

  levelEngine getLevelEngine() { // Get Level Engine Function
    return null;
  }

  void trueExit() {} // True Exit Function
 
}

boolean tanim = false;
class mainMenu extends Level { // Main Menu Class

  // Main Menu Variables
  rButton startButton, quitButton, difficultyButton;
  levelHandler levelHandler;
  soundHandler soundHandler;
  float tHeight = height/4.0;


  mainMenu(levelHandler levelHandler, soundHandler soundHandler) { // Main Menu Constructor
    this.levelHandler = levelHandler;
    this.soundHandler = soundHandler;
    // Main Menu Buttons ---------------------
    startButton = new menuButton("Start", width/2 - 300, height/2 + 50, levelHandler, "", "menu_button_UH.png");
    quitButton = new menuButton("Quit",width/2 + 100, height/2 + 50, levelHandler, "", "menu_button_UH.png");
    difficultyButton = new menuButton( "Difficulty",width/2 - 100, height/2 + 250, levelHandler, "", "menu_button_UH.png");

  }

  void display() { // Display Function
    background(0);
    displayTitle();
    startButton.display();
    quitButton.display();
    difficultyButton.display();
  }

  void update() { // Update Function
    levelHandler.setPreviousLevel(0);
    startButton.update();
    quitButton.update();
    difficultyButton.update();
    soundHandler.playMusic("intro");
  }

  void displayTitle() { // Display Title Function
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
      
    } else if (tanim && startTime + 4000 < millis()) { // Reset Title
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

  rButton getButton(String buttonName) { // Get Button Function 
    if (buttonName == "Start") {
      return startButton;
    } else if (buttonName == "Quit") {
      return quitButton;
    } else if (buttonName == "Difficulty" || buttonName == "Easy" || buttonName == "Medium" || buttonName == "Hard") {
      return difficultyButton;
    }
    return null;
  }

  void reset() {  // Reset Function
    tHeight = height/4.0;
    newButtons();
    tanim = false;
  }

  void newButtons() { // New Buttons Function
    startButton = new menuButton("Start", width/2 - 300, height/2 + 50, levelHandler, "", "menu_button_UH.png");
    quitButton = new menuButton("Quit",width/2 + 100, height/2 + 50, levelHandler, "", "menu_button_UH.png");
    difficultyButton = new menuButton( "Difficulty",width/2 - 100, height/2 + 250, levelHandler, "", "menu_button_UH.png");
  
  }

 

}

class gameLevel1 extends Level { // Game Level 1 Class
  
    // Game Level 1 Variables
    levelEngine levelEngine;
    boolean introFlag = true, exitFlag = false, trueExitFlag = false;

    gameLevel1() { // Game Level 1 Constructor
      levelEngine = new levelEngine();
    } 

    void display() { // Display Function
      background(0);
      levelEngine.setCurrentLevel(1);
      levelEngine.unhideLevelBar();
      levelEngine.displayLevelBar();


      if (introFlag) intro(); // Intro
      else if (exitFlag) outro(); // Outro
      else { // Level 1
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
          dialogueHandler.nextTrack();
        }
        
        
      }
      
    
    }

    void update() { // Update Function
      levelHandler.setPreviousLevel(2);
    }

    void intro() { // Intro Function
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

    void outro() { // Outro Function
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
            dialogueHandler.nextTrack();
            levelHandler.getLevels()[2].reset();
            levelHandler.setLevel(3);
            player.resetShipToCenter();
            player.enableFire();
          }
        }


        
      }
      
    }


    levelEngine getLevelEngine() { // Get Level Engine Function
      return levelEngine;
    }

    void reset() { // Reset Function
      introFlag = true;
      exitFlag = false;
      trueExitFlag = false;
      levelEngine.reset();
    }

    void trueExit() { // True Exit Function
      trueExitFlag = true;
    }


}

class gameLevel2 extends Level { // Game Level 2 Class

  // Game Level 2 Variables
  levelEngine levelEngine;
  boolean introFlag = true, exitFlag = false, trueExitFlag = false;

  gameLevel2() { // Game Level 2 Constructor
      levelEngine = new levelEngine();
  }

  void display() { // Display Function
    background(0);
    levelEngine.setCurrentLevel(2);
    levelEngine.unhideLevelBar();
    levelEngine.displayLevelBar();

    if (introFlag) intro(); // Intro
    else if (exitFlag) outro(); // Outro
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
        dialogueHandler.nextTrack();
        exitFlag = true;
      }


    }

    
  }

  void update() { // Update Function
    levelHandler.setPreviousLevel(4);
  } 

  void intro() { // Intro Function
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
  

  void outro() { // Outro Function
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
            player.animateForwardDrive(4);
            cameraZ -= 20;
          }

          // Final Exit
          if (trueExitFlag) {
            cameraZ = (height/2.0) / tan(PI*30.0 / 180.0); // Reset Camera
            exitFlag = false;
            introFlag = true;
            startTime = currentSecond();
            dialogueHandler.nextTrack();
            levelHandler.getLevels()[4].reset();
            levelHandler.setLevel(5);
            player.resetShipToCenter();
            player.enableFire();
          }
        }
      }
  }


  levelEngine getLevelEngine() { // Get Level Engine Function
      return levelEngine;
  }

  void reset() { // Reset Function
    introFlag = true;
    exitFlag = false;
    levelEngine.reset();
  }

  void trueExit() { // True Exit Function
      trueExitFlag = true;
  }

}

class gameLevel3 extends Level { // Game Level 3 Class

  // Game Level 3 Variables
  Planet planet;
  levelEngine levelEngine;
  boolean introFlag = true, exitFlag = false, trueExitFlag = false, extraChoice = false;

  gameLevel3() { // Game Level 3 Constructor
      levelEngine = new levelEngine();
      planet = new Planet(width/2, height/2,-6000,500);
  }

  void display() { // Display Function
    background(0);
    levelEngine.setCurrentLevel(3);
    levelEngine.displayLevelBar();
    
    // Planet
    if (!planet.isHidden()) { 
      planet.drawPlanet();
      planet.update();
    }

    if (introFlag) intro(); // Intro
    else if (exitFlag) outro(); // Outro
    else { // Level 3
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
        dialogueHandler.nextTrack();
        exitFlag = true;
      }

    }
  }

  void update() { // Update Function
    levelHandler.setPreviousLevel(6);
  }

  void intro() { // Intro Function
    graphicsHandler.setStarFlag(true);
    graphicsHandler.setTitleFlag(false);
    graphicsHandler.setSlowStarAcc();
    player.reset();
    player.display();
    player.update();
    levelEngine.reset();
    levelEngine.pause();

    if (currentSecond() > startTime + 2) { // Several Seconds in
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

          dialogueHandler.menu().fadeGastorIn();
          dialogueHandler.menu().fadeDialogueBoxLIn();
          if (dialogueHandler.isInChoice()) dialogueHandler.menu().fadeDialogueMenuIn();

        } 
        else {
          player.enableFire();
          startTime = currentSecond();
          levelEngine.reset();
          levelEngine.resume();
          introFlag = false;
        }


      }
      



  }

  void outro() { // Outro Function
      // Player
      player.display();
      player.update();
      planet.shiftToPlayer();
      
      // LevelEngine
      levelEngine.update();
      levelEngine.pause();
      // Graphics
      graphicsHandler.setSlowStarAcc();

      // Cutscene
      if (currentSecond() > startTime + 5) { // Several Seconds in
        player.disableFire();
        soundHandler.playMusic("outro");

        // Menu
        dialogueHandler.setCutscene(true);
        dialogueHandler.display();
        dialogueHandler.update();

        if (dialogueHandler.getCurrentTrackStatementIndex() == 22) { // Extra Choice
          extraChoice = true;
          if (dialogueHandler.getCurrentSpeaker().equals("Gastor")) {
            dialogueHandler.setCurrentTrackStatementIndex(41);
          } else if (dialogueHandler.getCurrentSpeaker().equals("Solara")) {
            dialogueHandler.setCurrentTrackStatementIndex(55);
          } 
        }

        if (dialogueHandler.getCurrentTrackStatementIndex() == 40 || dialogueHandler.getCurrentTrackStatementIndex() == 54) { // Extra Choice
          dialogueHandler.setCutscene(false);
        }

        // Cutscene
        if (dialogueHandler.isInCutscene()) {
          levelEngine.hideLevelBar();
          player.hideHealth();

          if (extraChoice) { // Extra Choice
            planet.hidePlanet();
            dialogueHandler.menu().fadeDialogueBoxLOut();
            dialogueHandler.menu().fadeSolaraOut();
            dialogueHandler.menu().fadeGastorOut();
            dialogueHandler.menu().fadeDialogueBoxROut();
            dialogueHandler.menu().fadeDialogueBoxCIn();
            dialogueHandler.menu().setContentOfCenterBox(dialogueHandler.getCurrentStatement());
            return;
          }
          

          if (dialogueHandler.getCurrentSpeaker().equals("Gastor")){
            dialogueHandler.menu().fadeGastorIn();
            dialogueHandler.menu().fadeDialogueBoxLIn();
            dialogueHandler.menu().fadeDialogueBoxROut();
            dialogueHandler.menu().fadeSolaraOut();
          }
          else if (dialogueHandler.getCurrentSpeaker().equals("Solara")) {
            dialogueHandler.menu().fadeGastorOut();
            dialogueHandler.menu().fadeDialogueBoxLOut();
            dialogueHandler.menu().fadeSolaraIn();
            dialogueHandler.menu().fadeDialogueBoxRIn();
            dialogueHandler.menu().fadeUnknownOut();
          }
          else if (dialogueHandler.getCurrentSpeaker().equals("???")) {
            dialogueHandler.menu().fadeGastorOut();
            dialogueHandler.menu().fadeDialogueBoxLOut();
            dialogueHandler.menu().fadeUnknownIn();
            dialogueHandler.menu().fadeDialogueBoxRIn();
          }
          else {
            if (dialogueHandler.isInChoice()) {
            dialogueHandler.menu().fadeDialogueMenuIn();
            dialogueHandler.menu().fadeGastorIn();
            dialogueHandler.menu().fadeSolaraIn();
            dialogueHandler.menu().fadeDialogueBoxLOut();
            dialogueHandler.menu().fadeDialogueBoxROut();
            } else {              
              dialogueHandler.menu().fadeDialogueMenuOut();
              

            }
 
          }
          

        }
        else {

          // Menu
          planet.hidePlanet();
          dialogueHandler.menu().fadeDialogueBoxROut();
          dialogueHandler.menu().fadeUnknownOut();
          dialogueHandler.menu().fadeSolaraOut();
          dialogueHandler.menu().fadeGastorOut();
          dialogueHandler.menu().fadeDialogueBoxLOut();
          dialogueHandler.menu().fadeDialogueBoxCOut();


          // After all dialogue hidden, transition
          if (dialogueHandler.menu().allBoxesHidden()){
            graphicsHandler.setStarFlag(false);
            graphicsHandler.setTitleFlag(true);
            graphicsHandler.setSuperFastStarAcc();
            // Speed up transition
            player.animateForwardDrive(6);
            cameraZ -= 20;
          }

          // Final Exit
          if (trueExitFlag) {
            cameraZ = (height/2.0) / tan(PI*30.0 / 180.0); // Reset Camera
            exitFlag = false;
            introFlag = true;
            startTime = currentSecond();
            dialogueHandler.nextTrack();
            levelHandler.getLevels()[6].reset();
            levelHandler.setLevel(7);
            levelEngine.unhideLevelBar();
            player.unhideHealth();
            player.resetShipToCenter();
            player.enableFire();
            planet.showPlanet();
          }
        }
      }

  }

  levelEngine getLevelEngine() { // Get Level Engine Function
      return levelEngine;
  }

  void reset() { // Reset Function
    introFlag = true;
    exitFlag = false;
    extraChoice = false;
    levelEngine.reset();
  }

  void trueExit() { // True Exit Function
      trueExitFlag = true;
  }
 
  boolean getExtraChoice() { // Get Extra Choice Function
    return extraChoice;
  }


  
}


class transition extends Level {  // Transition Class

    // Transition Variables
    String type, title, level;
    SoundFile transitionSound;
    boolean played = false;

    transition(String type) { // Transition Constructor
      this.type = type;
      title = ""; level = "";
      transitionSound = soundHandler.getFile("transition");
    }



    void display() { // Display Function
      background(0);
      graphicsHandler.setStarFlag(false);

      if (startTime + 8 < currentSecond()) { // Transition Level
        levelDecide();
      }
      else if (startTime + 6 < currentSecond()) {}  // Nothing
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
      else if (startTime < currentSecond()) { // Start Transition
        soundHandler.playMusic("pause");
      }
      
    }

    void update() { // Update Function
      player.deactivatePlayerCamera();
    }

    private void transitionTitle() { // Transition Title Function
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

    private void levelDecide() { // Level Decide Function
      if (type == "Asteroid") {
        dialogueHandler.resetToTrack(0);
        levelHandler.setLevel(2);
        played = false;
      }
      else if (type == "Monster") {
        dialogueHandler.resetToTrack(2);
        levelHandler.setLevel(4);
        played = false;
      }
      else if (type == "Ship") {
        dialogueHandler.resetToTrack(4);
        levelHandler.setLevel(6);
        played = false;
      }
      else if (type == "End") {
        played = false;
        // graphicsHandler.setStarFlag(true);
        // graphicsHandler.setTitleFlag(false);
        // graphicsHandler.setSlowStarAcc();
        // dialogueHandler.resetAllTracks();
        // dialogueHandler.reset();
        // levelHandler.getLevels()[0].reset();
        // levelHandler.setLevel(0);
        exit();
      }
      startTime = currentSecond();
    }

}

class deathScreen extends Level { // Death Screen Class

    // Death Screen Variables
    rButton restartButton, quitButton;
    levelHandler levelHandler;
    
    deathScreen(levelHandler levelHandler) { // Death Screen Constructor
      restartButton = new deathScreenButton("Restart", width/2 - 300, height/2 + 50, levelHandler, "", "menu_button_UH.png");
      quitButton = new deathScreenButton("Quit",width/2 + 100, height/2 + 50, levelHandler, "", "menu_button_UH.png");
    }

    void display() { // Display Function
      background(0);
      titleDisplay();
      restartButton.display();
      quitButton.display();
    }

    void update() { // Update Function
      // Graphics
      graphicsHandler.setStarFlag(false);
      player.deactivatePlayerCamera();
      restartButton.update();
      quitButton.update();
    }

    private void titleDisplay() { // Title Display Function
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
