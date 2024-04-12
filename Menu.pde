// Nathan Dejesus - Menu Handling

class Menu { // Menu Class -- Dialogue Box Handler Essesntially

    // Boxes
    portraitBox Gastor, Solara, unknown;
    dialogueBox dialogueBoxL, dialogueBoxR, dialogueBoxC;
    dialogueMenu dialogueMenu;

    Menu() { // Cons
        Gastor = new portraitBox(-500,0,"Gastor");
        Solara = new portraitBox(width+500,0,"Solara");
        unknown = new portraitBox(width+500,0,"unknown");
        dialogueBoxL = new dialogueBox(width/2-140,-500,false);
        dialogueBoxR = new dialogueBox(width/2-350,-500,true);
        dialogueBoxC = new dialogueBox(width/2-240,-500);
        dialogueMenu = new dialogueMenu(width/2-310,height+500);
    }

    void display() { // Display all 
        Gastor.display();
        Solara.display();
        unknown.display();
        dialogueBoxL.display();
        dialogueBoxR.display();
        dialogueBoxC.display();
        dialogueMenu.display();
    }

    void update() { // Update
        Gastor.update();
        Solara.update();
        unknown.update();
        dialogueBoxL.update();
        dialogueBoxR.update();
        dialogueBoxC.update();
        dialogueMenu.update();
    }

    void setContentOfSpeakerBox(String speaker, String statement) { // Set Speaker Content
        if (speaker.equals("Gastor")) {
            dialogueBoxL.setSpeaker(speaker);
           dialogueBoxL.setContent(statement);
        }
        else if (speaker.equals("Solara")) {
            dialogueBoxR.setSpeaker(speaker);
            dialogueBoxR.setContent(statement);
        }
        else if (speaker.equals("You") || speaker.equals("")) {
            dialogueBoxC.setSpeaker("");
            dialogueBoxC.setContent(statement);
        }
        else {
            dialogueBoxR.setSpeaker("???");
            dialogueBoxR.setContent(statement);
        }
    }

    void setContentOfCenterBox(String statement) { // Set Center Box
        dialogueBoxC.setSpeaker("");
        dialogueBoxC.setContent(statement);
    }

    void setContentOfDialogueMenu(String[] options) { // Set Dialogue Menu Content
        dialogueMenu.setContent(options[0], options[1], options[2]);
    }

    boolean optionChosen() { // Option Chosen?
        return dialogueMenu.isChosen();
    }

    int getChoice() { // Getter
        return dialogueMenu.getChoice();
    }

    void fadeGastorIn() { // Fade 
        if (!Gastor.inFrameLeft()) {
            Gastor.fadeRight();
        }
    }

    void fadeGastorOut() {// Fade 
        if (!Gastor.outFrameLeft()) {
            Gastor.fadeLeft();
        }
    }

    void hideGastor() {// Fade 
        Gastor.hide();
    }

    void revealGastor() {// Fade 
        Gastor.unhide();
    }

    void fadeSolaraIn() {// Fade 
        if (!Solara.inFrameRight()) {
            Solara.fadeLeft();
        }
    }

    void fadeSolaraOut() {// Fade 
        if (!Solara.outFrameRight()) {
            Solara.fadeRight();
        }
    }

    void hideSolara() {// Fade 
        Solara.hide();
    }

    void revealSolara() {// Fade 
        Solara.unhide();
    }

    void fadeUnknownIn() {// Fade 
        if (!unknown.inFrameRight()) {
            unknown.fadeLeft();
        }
    }

    void fadeUnknownOut() {// Fade 
        if (!unknown.outFrameRight()) {
            unknown.fadeRight();
        }
    }

    void hideUnknown() {// Fade 
        unknown.hide();
    }

    void revealUnknown() {// Fade 
        unknown.unhide();
    }

    void fadeDialogueBoxLIn() {// Fade 
        if (!dialogueBoxL.inFrame()) {
            dialogueBoxL.fadeIn();
        }
    }

    void fadeDialogueBoxLOut() {// Fade 
        if (!dialogueBoxL.outFrame()) {
            dialogueBoxL.fadeOut();
        }
    }

    void fadeDialogueBoxRIn() {// Fade 
        if (!dialogueBoxR.inFrame()) {
            dialogueBoxR.fadeIn();
        }
    }

    void fadeDialogueBoxROut() {// Fade 
        if (!dialogueBoxR.outFrame()) {
            dialogueBoxR.fadeOut();
        }
    }

    void fadeDialogueBoxCIn() {// Fade 
        if (!dialogueBoxC.inFrame()) {
            dialogueBoxC.fadeIn();
        }
    }

    void fadeDialogueBoxCOut() {// Fade 
        if (!dialogueBoxC.outFrame()) {
            dialogueBoxC.fadeOut();
        }
    }

    void fadeDialogueMenuIn() {// Fade 
        if (!dialogueMenu.inFrame()) {
            dialogueMenu.fadeIn();
        }
    }

    void fadeDialogueMenuOut() {// Fade 
        if (!dialogueMenu.outFrame()) {
            dialogueMenu.fadeOut();
        }
    }

    void hideDialogueBoxL() {// Fade 
        dialogueBoxL.hide();
    }

    void revealDialogueBoxL() {// Fade 
        dialogueBoxL.unhide();
    }

    void hideDialogueBoxR() {// Fade 
        dialogueBoxR.hide();
    }

    void revealDialogueBoxR() {// Fade 
        dialogueBoxR.unhide();
    }

    boolean allBoxesHidden() {// Fade 
        return Gastor.outFrameLeft() && Solara.outFrameRight() && unknown.outFrameRight() && dialogueBoxL.outFrame() && dialogueBoxR.outFrame() && dialogueBoxC.outFrame() && dialogueMenu.outFrame();
    }
     

}

// Health Class -- Includes Bar
class Health { 

    // Vars
    int health, maxHealth;
    int healthbarX, healthbarY, healthcaseX, healthcaseY;
    boolean isDead = false, hide = false;
    PImage healthcase, healthbar;

    // Cons
    Health(int maxHealth) {
        this.maxHealth = maxHealth;
        health = maxHealth;
        healthcase = loadImage("img/health_case.png");
        healthbar = loadImage("img/healthbar.png");
        healthcase.resize(healthcase.width/3, healthcase.height/3);
        healthbar.resize(healthbar.width/3, healthbar.height/3);
        healthcaseX = -75;
        healthcaseY = height - healthcase.height + 75;
        healthbarX = healthbar.width/2-79;
        healthbarY = height - healthbar.height + 34;
    }

    void display() { // Display
        if (hide) return;
        pushMatrix();

        // Rotate the healthbar and healthcase opposite of camera rotation to keep them facing the camera
        rotateX(-cam.getRotX()); rotateY(-cam.getRotY()); rotateZ(-cam.getRotZ());
        translate(0,0,-200);
        image(healthcase, healthcaseX, healthcaseY);
        translate(0,0,5);
        PImage temp = healthbar.get(0,0,healthbar.width * health/maxHealth, healthbar.height);
        image(temp, healthbarX, healthbarY);

        // health in percentage
        textSize(13); textFont(mainFont); textAlign(CENTER, CENTER);
        if (health < 30) fill(255,0,0); 
        else if (health < 50) fill(255,255,0);
        else fill(255);
        int percent = (int) ((float) health/maxHealth * 100);
        text(percent + "%", healthcaseX + 79, healthbarY - 15);

        popMatrix();
    }

    void update() { // Update
        if (health <= 0) {
            isDead = true;
        }
    }

    void takeDamage(int amount) { // Take Damage
        health = health - amount < 0 ? 0 : health - amount;
    }

    void reset() { // Reset
        health = maxHealth;
        isDead = false;
    }

    boolean isDead() { // Is Dead
        return isDead;
    }

    void hide() { // Hide
        hide = true;
    }

    void unhide() { // Reveal
        hide = false;
    }

    int getHealth() { // Get Current Health
        return health;
    }

}

// Portrait Box Class -- 3 -> Gastor, Solara, Unknown
class portraitBox {

    // Vars
    PImage portrait;
    int x, y;
    int IN_FRAME_XL = 0, IN_FRAME_XR = width-300, OUT_FRAME_XL = -500, OUT_FRAME_XR = width+500;
    int fadeSpeed = 15;
    boolean hide = false;

    // Cons
    portraitBox(int x, int y, String portrait) {
        this.x = x;
        this.y = y;
        this.portrait = loadImage("img/" + portrait + ".png");
        this.portrait.resize(this.portrait.width/2, this.portrait.height/2);
    }

    void display() { // Display
        if (hide) return;
        pushMatrix();
        rotateX(-cam.getRotX());
        rotateY(-cam.getRotY());
        rotateZ(-cam.getRotZ());
        translate(0,0,-180);
        image(portrait, x, y);
        popMatrix();
    }

    void update() { // UPdate
        if (hide) return;
    }

    void set(int x, int y) { // set x and y
        this.x = x;
        this.y = y;
    }

    void fadeRight() {// Fade 
        x += fadeSpeed;

    }

    void fadeLeft() {// Fade 
        x -= fadeSpeed;
    }

    boolean inFrameLeft() {// Fade 
        if (x >= IN_FRAME_XL) {
            return true;
        } else {
            return false;
        }
    }

    boolean inFrameRight() {// Fade 
        if (x <= IN_FRAME_XR) {
            return true;
        } else {
            return false;
        }
    }

    boolean outFrameLeft() {// Fade 
        if (x <= OUT_FRAME_XL) {
            return true;
        } else {
            return false;
        }
    }

    boolean outFrameRight() {// Fade 
        if (x >= OUT_FRAME_XR) {
            return true;
        } else {
            return false;
        }
    }

    void hide() { // Hide
        hide = true;
    }

    void unhide() { // hide
        hide = false;
    }

}

class levelBar { // level bar stored in level engine in Enemy file -- Graphics handled here

    // Vars
    PImage levelCase, fullLevelBar, levelBar;
    int x, y;
    boolean hide = false;

    // Const
    levelBar(int x, int y) {
        this.x = x;
        this.y = y;
        levelCase = loadImage("img/level_case.png");
        fullLevelBar = loadImage("img/levelbar.png");
        levelBar = fullLevelBar.get(0,0,0, fullLevelBar.height);
        levelCase.resize(levelCase.width/3, levelCase.height/3);
        fullLevelBar.resize(fullLevelBar.width/3, fullLevelBar.height/3);
    }

    void display() { // Display Bar
        if (hide) return;
        
        pushMatrix();
        rotateX(-cam.getRotX());
        rotateY(-cam.getRotY());
        rotateZ(-cam.getRotZ());
        translate(0,0,-100);
        image(levelCase, x, y);
        translate(0,0,5);
        image(levelBar, x + 5, y + 8);
        popMatrix();
    }

    void update() { // UPdate
        if (hide) return;
    }

    void setProgress(int progress, int maxProgress) {
        // Set levelbar by cropping the levelbar image to progress
        levelBar = fullLevelBar.get(0,0,fullLevelBar.width * progress/maxProgress, fullLevelBar.height);
    }

    void hide() { // hide
        hide = true;
    }

    void unhide() { // reveal
        hide = false;
    }

    void reset() { // reset level bar
        levelBar = fullLevelBar.get(0,0,0, fullLevelBar.height);
    }

}
