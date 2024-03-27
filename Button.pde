// Nathan Dejesus - Buttons for the game

boolean mouseClicked = false;

class rButton {

    String text;
    int x, y, z, w, h;
    boolean disabled = false, animating = false;
    levelHandler levelHandler;
    PImage img, uh_img;

    rButton(String text, int x, int y, int w, int h, levelHandler levelHandler, String img, String uh_img) {
        this.text = text;
        this.x = x;
        this.y = y;
        this.z = (int)cameraZ;
        this.w = w;
        this.h = h;
        this.levelHandler = levelHandler;
        if (img != null) this.img = loadImage("img/" + img + ".png");
        if (uh_img != null) this.uh_img = loadImage("img/" + uh_img);
    }

    void display() {}

    void update() {}

    void fadeBack() {
        // Keep translating button along z-axis until gone
        pushMatrix();
        translate(0, 0, z);
        if (z > -7000) z-=100;
        else {
            popMatrix();
            animating = false;
            disable();
        }
        // System.out.println(z);
        
    }

    boolean mouseWithin() {
        return mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
    }

    String getText() {
        return text;
    }

    void setText(String text) {
        this.text = text;
    }

    void disable() {
        disabled = true;
    }

    void enable() {
        disabled = false;
    }


}


class menuButton extends rButton {

    menuButton(String text, int x, int y, levelHandler levelHandler, String img, String uh_img) {
        super(text, x, y, 200, 100, levelHandler, img, uh_img);
    }

    void display() {

        // Animation
        if (animating) fadeBack();

        if (disabled) {

            return;
        }
        
        stroke(255);
        fill(255);
        textAlign(CENTER, CENTER);
        strokeWeight(2);

        // Hover effect
        if (mouseWithin()) {
            textFont(mainFont, 38);
            image(uh_img, x-5, y-5, w+10, h+10);
            text(text, x, y-5, w, h);
        } else {
            textFont(mainFont, 36);
            image(uh_img, x, y, w, h);
            text(text, x, y-5, w, h);
        }

        if (animating) popMatrix();

    }

    void update() {
        if (!disabled && mouseWithin() && mouseClicked) {
            System.out.println(text);
            if (text.equals("Start")) {
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
                

            } else if (text.equals("Quit")) {
                levelHandler.quit();
            } else if (text.equals("Difficulty") || text.equals("Easy") || text.equals("Medium") || text.equals("Hard")){
                soundHandler.playSound("menuClick");
                levelHandler.changeDifficulty();
            }
            mouseClicked = false;
        } 
    }

   

    
  


}

class dialogueButton extends rButton {

    dialogueButton(String text, int x, int y, levelHandler levelHandler, String img, String uh_img) {
        super(text, x, y, 200, 100, levelHandler, img, uh_img);
    }

    void display() {
        System.out.println(text);
    }

}
