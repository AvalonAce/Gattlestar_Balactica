// Nathan Dejesus - Menu Handling

class Menu {

    portraitBox Gastor, Solara, unknown;
    dialogueBox dialogueBoxL, dialogueBoxR;
    dialogueMenu dialogueMenu;

    Menu() {
        Gastor = new portraitBox(-500,0,"Gastor");
        Solara = new portraitBox(width+500,0,"Solara");
        unknown = new portraitBox(width+500,0,"unknown");
        dialogueBoxL = new dialogueBox(width/2-140,-500,false);
        dialogueBoxR = new dialogueBox(width/2-350,-500,true);
        dialogueMenu = new dialogueMenu(width/2-310,height+500);
    }

    void display() {
        Gastor.display();
        Solara.display();
        unknown.display();
        dialogueBoxL.display();
        dialogueBoxR.display();
        dialogueMenu.display();
    }

    void update() {
        Gastor.update();
        Solara.update();
        unknown.update();
        dialogueBoxL.update();
        dialogueBoxR.update();
        dialogueMenu.update();
    }

    void setContentOfSpeakerBox(String speaker, String statement) {
        if (speaker.equals("Gastor")) {
            dialogueBoxL.setSpeaker(speaker);
           dialogueBoxL.setContent(statement);
        }
        else if (speaker.equals("Solara")) {
            dialogueBoxR.setSpeaker(speaker);
            dialogueBoxR.setContent(statement);
        }
        else {
            dialogueBoxL.setSpeaker("Unknown");
            dialogueBoxL.setContent(statement);
        }
    }

    void setContentOfDialogueMenu(String[] options) {
        dialogueMenu.setContent(options[0], options[1], options[2]);
    }

    boolean optionChosen() {
        return dialogueMenu.isChosen();
    }

    int getChoice() {
        return dialogueMenu.getChoice();
    }

    void fadeGastorIn() {
        if (!Gastor.inFrameLeft()) {
            Gastor.fadeRight();
        }
    }

    void fadeGastorOut() {
        if (!Gastor.outFrameLeft()) {
            Gastor.fadeLeft();
        }
    }

    void hideGastor() {
        Gastor.hide();
    }

    void revealGastor() {
        Gastor.unhide();
    }

    void fadeSolaraIn() {
        if (!Solara.inFrameRight()) {
            Solara.fadeLeft();
        }
    }

    void fadeSolaraOut() {
        if (!Solara.outFrameRight()) {
            Solara.fadeRight();
        }
    }

    void hideSolara() {
        Solara.hide();
    }

    void revealSolara() {
        Solara.unhide();
    }

    void fadeUnknownIn() {
        if (!unknown.inFrameRight()) {
            unknown.fadeLeft();
        }
    }

    void fadeUnknownOut() {
        if (!unknown.outFrameRight()) {
            unknown.fadeRight();
        }
    }

    void hideUnknown() {
        unknown.hide();
    }

    void revealUnknown() {
        unknown.unhide();
    }

    void fadeDialogueBoxLIn() {
        if (!dialogueBoxL.inFrame()) {
            dialogueBoxL.fadeIn();
        }
    }

    void fadeDialogueBoxLOut() {
        if (!dialogueBoxL.outFrame()) {
            dialogueBoxL.fadeOut();
        }
    }

    void fadeDialogueBoxRIn() {
        if (!dialogueBoxR.inFrame()) {
            dialogueBoxR.fadeIn();
        }
    }

    void fadeDialogueBoxROut() {
        if (!dialogueBoxR.outFrame()) {
            dialogueBoxR.fadeOut();
        }
    }

    void fadeDialogueMenuIn() {
        if (!dialogueMenu.inFrame()) {
            dialogueMenu.fadeIn();
        }
    }

    void fadeDialogueMenuOut() {
        if (!dialogueMenu.outFrame()) {
            dialogueMenu.fadeOut();
        }
    }

    void hideDialogueBoxL() {
        dialogueBoxL.hide();
    }

    void revealDialogueBoxL() {
        dialogueBoxL.unhide();
    }

    void hideDialogueBoxR() {
        dialogueBoxR.hide();
    }

    void revealDialogueBoxR() {
        dialogueBoxR.unhide();
    }
     

}

class Health { 

    int health, maxHealth;
    int healthbarX, healthbarY, healthcaseX, healthcaseY;
    boolean isDead = false, hide = false;
    PImage healthcase, healthbar;

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

    void display() {
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
        if (health < 10) fill(255,0,0); 
        else if (health < 50) fill(255,255,0);
        else fill(255);
        int percent = (int) ((float) health/maxHealth * 100);
        text(percent + "%", healthcaseX + 79, healthbarY - 15);

        popMatrix();
    }

    void update() {
        if (health <= 0) {
            isDead = true;
        }
    }

    void takeDamage(int amount) {
        health = health - amount < 0 ? 0 : health - amount;
    }

    void reset() {
        health = maxHealth;
    }

    boolean isDead() {
        return isDead;
    }

    void hide() {
        hide = true;
    }

    void unhide() {
        hide = false;
    }

    int getHealth() {
        return health;
    }

}


class portraitBox {

    PImage portrait;
    int x, y;
    int IN_FRAME_XL = 0, IN_FRAME_XR = width-300, OUT_FRAME_XL = -500, OUT_FRAME_XR = width+500;
    int fadeSpeed = 15;
    boolean hide = false;

    portraitBox(int x, int y, String portrait) {
        this.x = x;
        this.y = y;
        this.portrait = loadImage("img/" + portrait + ".png");
        this.portrait.resize(this.portrait.width/2, this.portrait.height/2);
    }

    void display() {
        if (hide) return;
        pushMatrix();
        rotateX(-cam.getRotX());
        rotateY(-cam.getRotY());
        rotateZ(-cam.getRotZ());
        translate(0,0,-180);
        image(portrait, x, y);
        popMatrix();
    }

    void update() {
        if (hide) return;
    }

    void set(int x, int y) {
        this.x = x;
        this.y = y;
    }

    void fadeRight() {
        x += fadeSpeed;

    }

    void fadeLeft() {
        x -= fadeSpeed;
    }

    boolean inFrameLeft() {
        if (x >= IN_FRAME_XL) {
            return true;
        } else {
            return false;
        }
    }

    boolean inFrameRight() {
        if (x <= IN_FRAME_XR) {
            return true;
        } else {
            return false;
        }
    }

    boolean outFrameLeft() {
        if (x <= OUT_FRAME_XL) {
            return true;
        } else {
            return false;
        }
    }

    boolean outFrameRight() {
        if (x >= OUT_FRAME_XR) {
            return true;
        } else {
            return false;
        }
    }

    void hide() {
        hide = true;
    }

    void unhide() {
        hide = false;
    }

}

class levelBar { // level bar stored in level engine in Enemy file -- Graphics handled here

    PImage levelCase, fullLevelBar, levelBar;
    int x, y;
    boolean hide = false;

    levelBar(int x, int y) {
        this.x = x;
        this.y = y;
        levelCase = loadImage("img/level_case.png");
        fullLevelBar = loadImage("img/levelbar.png");
        levelBar = fullLevelBar.get(0,0,0, fullLevelBar.height);
        levelCase.resize(levelCase.width/3, levelCase.height/3);
        fullLevelBar.resize(fullLevelBar.width/3, fullLevelBar.height/3);
    }

    void display() {
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

    void update() {
        if (hide) return;
    }

    void setProgress(int progress, int maxProgress) {
        // Set levelbar by cropping the levelbar image to progress
        levelBar = fullLevelBar.get(0,0,fullLevelBar.width * progress/maxProgress, fullLevelBar.height);
    }

    void hide() {
        hide = true;
    }

    void unhide() {
        hide = false;
    }

}
