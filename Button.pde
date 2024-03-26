// Nathan Dejesus - Buttons for the game

boolean mouseClicked = false;

class rButton {

    String text;
    int x, y, w, h;
    levelHandler levelHandler;

    rButton(String text, int x, int y, int w, int h, levelHandler levelHandler) {
        this.text = text;
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.levelHandler = levelHandler;
    }

    void display() {}

    void update() {}

    boolean mouseWithin() {
        return mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
    }

    String getText() {
        return text;
    }


}


class menuButton extends rButton {

    menuButton(String text, int x, int y, levelHandler levelHandler) {
        super(text, x, y, 200, 100, levelHandler);
    }

    void display() {
        stroke(255);
        textFont(mainFont, 36);
        noFill();  
        textAlign(CENTER, CENTER);
        text(text, x, y-5, w, h);
        rect(x, y, w, h);
    }

    void update() {
        if (mouseWithin() && mouseClicked) {
            System.out.println(text);
            if (false && text.equals("Start")) {
                // levelHandler.setLevel(1);
            } else if (text.equals("Quit")) {
                levelHandler.quit();
            } else if (text.equals("Difficulty")) {
                levelHandler.changeDifficulty();
            }
            mouseClicked = false;
        } 
    }

   

    
  


}

class dialogueButton extends rButton {

    dialogueButton(String text, int x, int y, levelHandler levelHandler) {
        super(text, x, y, 200, 100, levelHandler);
    }

    void display() {
        System.out.println(text);
    }

}
