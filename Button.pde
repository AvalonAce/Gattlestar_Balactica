// Nathan Dejesus - Buttons for the game

boolean mouseClicked = false; // Mouse click global var

class rButton { // Abstract regular button

    // Button Vars
    String text;
    int x, y, z, w, h;
    boolean disabled = false, animating = false;
    levelHandler levelHandler;
    PImage img, uh_img;

    // Constructor
    rButton(String text, int x, int y, int w, int h, levelHandler levelHandler, String img, String uh_img) {
        this.text = text;
        this.x = x;
        this.y = y;
        this.z = 0;
        this.w = w;
        this.h = h;
        this.levelHandler = levelHandler;
        if (img != null) this.img = loadImage("img/" + img + ".png");
        if (uh_img != null) this.uh_img = loadImage("img/" + uh_img);
    }

    void display() {} // Empty Display 

    void update() {} // Empty Update

    void fadeBack() { // Fade Back animation
        // Keep translating button along z-axis until gone
        pushMatrix();
        translate(0, 0, z);
        if (z > -7000) z-=100;
        else {
            popMatrix();
            animating = false;
            disable();
        }
        
    }

    boolean mouseWithin() { // Mouse within button function
        return mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
    }

    String getText() { // Getter
        return text;
    }

    void setText(String text) { // Setter
        this.text = text;
    }

    void disable() { // Button Disable
        disabled = true;
    }

    void enable() { // Button Enable
        disabled = false;
    }

    void reset() { // Reset Button from fadeback
        disabled = false;
        animating = false;
        z = 0 ;
    }


}

// Menu button extention of button
class menuButton extends rButton {

    // Constructor
    menuButton(String text, int x, int y, levelHandler levelHandler, String img, String uh_img) {
        super(text, x, y, 200, 100, levelHandler, img, uh_img);
    }

    void display() { // Display function -- called when displaying

        // Animation
        if (animating) fadeBack();

        if (disabled) {

            return;
        }
        
        stroke(255);
        fill(255);
        strokeWeight(2);
        textAlign(CENTER, CENTER);

        // Hover effect
        pushMatrix();
        if (mouseWithin()) {
            textFont(mainFont, 38);
            translate(x, y, 0);
            image(uh_img, 0, 0, w+10, h+10);
            translate(0, 0, 5);
            text(text, 0,-5, w, h);
        } else {
            textFont(mainFont, 36);
            translate(x, y, 0);
            image(uh_img, 0, 0, w, h);
            translate(0, 0, 5);
            text(text, 0, -5, w, h);
        }
        popMatrix();

        if (animating) popMatrix();

    }

    void update() { // Update Function -- called when updating
        if (!disabled && mouseWithin() && mouseClicked) { // On click
            System.out.println(text);
            if (text.equals("Start")) { // Start Game
                soundHandler.playSound("menuClick");
                
                // Start animation
                startTime = millis();

                // Begin animation
                levelHandler.getLevels()[0].getButton("Start").animating = true;
                levelHandler.getLevels()[0].getButton("Quit").animating = true;
                levelHandler.getLevels()[0].getButton("Difficulty").animating = true;
                tanim = true;
                graphicsHandler.setStarFlag(false);
                graphicsHandler.setTitleFlag(true);

                // Auto difficulty if not set
                if (difficulty == 0) levelHandler.changeDifficulty();

            } else if (text.equals("Quit")) { // Quit Game
                exit();
            } else if (text.equals("Difficulty") || text.equals("Easy") || text.equals("Medium") || text.equals("Hard")){ // Change Difficulty
                soundHandler.playSound("menuClick");
                levelHandler.changeDifficulty();
            }



            mouseClicked = false;
        } 
    }
}

// Dead screen button extention
class deathScreenButton extends rButton {

    // Constructor
    deathScreenButton(String text, int x, int y, levelHandler levelHandler, String img, String uh_img) {
        super(text, x, y, 200, 100, levelHandler, img, uh_img);
    }

    void display() { // Display Function -- On dead screen button display
        
        stroke(255);
        fill(255);
        textAlign(CENTER, CENTER);
        strokeWeight(2);

        // Hover effect
        pushMatrix();
        if (mouseWithin()) {
            textFont(mainFont, 38);
            image(uh_img, x, y, w+10, h+10);
            translate(0, 0, 5);
            text(text, x+100, y+50, w, h);
        } else {
            textFont(mainFont, 36);
            image(uh_img, x, y, w, h);
            translate(0, 0, 5);
            text(text, x+100, y+45, w, h);
        }
        popMatrix();


    }

     void update() { // Update Function -- On dead screen button update 
        if (!disabled && mouseWithin() && mouseClicked) { // On click
            System.out.println(text);
            
            if (text.equals("Quit")) { // Quit
                exit();
            } else if (text.equals("Restart")) { // Restart
                soundHandler.playSound("menuClick");
                player.resetShipToCenter();

                // Reset to level
                int level = levelHandler.getPreviousLevel();
                levelHandler.getLevels()[level].reset();
                levelHandler.setLevel(level);
                levelHandler.getLevels()[level].getLevelEngine().resetLevelBar();
                levelHandler.getLevels()[level].getLevelEngine().displayLevelBar();
                levelHandler.restartSound();
                startTime = currentSecond();

                // Reset Dialogue
                switch (level) {
                    case 2:
                        dialogueHandler.resetToTrack(0);
                        break;
                    case 4:
                        dialogueHandler.resetToTrack(2);
                        break;
                    case 6:
                        dialogueHandler.resetToTrack(4);
                        break;
                    default:
                        dialogueHandler.reset();
                        break;
                }

                
            }


            mouseClicked = false;
        } 
    }

}
