// Nathan Dejesus - Menu Handling

class Menu {

    portraitBox Gastor, Solara, unknown;
    dialogueBox dialogueBox;
    dialogueMenu dialogueMenu;

    Menu() {
        Gastor = new portraitBox(-500,0,"Gastor");
        Solara = new portraitBox(width+500,0,"Solara");
        unknown = new portraitBox(width+500,0,"unknown");
        dialogueBox = new dialogueBox(width/2-140,-500);
        dialogueMenu = new dialogueMenu(width/2-350,height/2+60);
    }

    void display() {
        Gastor.display();
        Solara.display();
        unknown.display();
        dialogueBox.display();
        dialogueMenu.display();
    }

    void update() {
        Gastor.update();
        Solara.update();
        unknown.update();
        dialogueBox.update();
        dialogueMenu.update();
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

    void fadeDialogueBoxIn() {
        if (!dialogueBox.inFrame()) {
            dialogueBox.fadeIn();
        }
    }

    void fadeDialogueBoxOut() {
        if (!dialogueBox.outFrame()) {
            dialogueBox.fadeOut();
        }
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
        image(healthbar, healthbarX, healthbarY, healthbar.width * health/maxHealth, healthbar.height);

        // health in percentage
        textSize(13); textFont(mainFont); textAlign(CENTER, CENTER);
        if (health < 10) fill(255,0,0); else fill(255);
        int percent = (int) ((float) health/maxHealth * 100);
        text(percent + "%", healthcaseX + 79, healthbarY - 15);

        popMatrix();
    }

    void update() {
        if (health <= 0) {
            isDead = true;
            soundHandler.playSound("playerDeath");
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

}


class portraitBox {

    PImage portrait;
    int x, y;
    int IN_FRAME_XL = 0, IN_FRAME_XR = width-300, OUT_FRAME_XL = -500, OUT_FRAME_XR = width+500;
    int fadeSpeed = 15;

    portraitBox(int x, int y, String portrait) {
        this.x = x;
        this.y = y;
        this.portrait = loadImage("img/" + portrait + ".png");
        this.portrait.resize(this.portrait.width/2, this.portrait.height/2);
    }

    void display() {
        pushMatrix();
        rotateX(-cam.getRotX());
        rotateY(-cam.getRotY());
        rotateZ(-cam.getRotZ());
        translate(0,0,-100);
        image(portrait, x, y);
        popMatrix();
    }

    void update() {
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

}
