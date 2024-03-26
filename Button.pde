// Nathan Dejesus - Buttons for the game

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

    boolean mouseWithin(int mouseX, int mouseY) {
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
        textSize(32);
        noFill();  
        textAlign(CENTER, CENTER);
        text(text, x, y-5, w, h);
        rect(x, y, w, h);
    }

    void update() {
        if (mouseWithin(mouseX, mouseY) && mousePressed) {
            System.out.println(text);
            if (text.equals("Start")) {
                // levelHandler.setLevel(1);
            } else if (text.equals("Quit")) {
                levelHandler.quit();
            } else if (text.equals("Difficulty")) {
                levelHandler.changeDifficulty();
            }
             
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
