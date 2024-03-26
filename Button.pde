// Nathan Dejesus - Buttons for the game

class rButton {

    String text;
    int x, y, w, h;

    rButton(String text, int x, int y, int w, int h) {
        this.text = text;
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
    }

    void display() {}

    boolean mouseWithin(int mouseX, int mouseY) {
        return mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
    }

    String getText() {
        return text;
    }


}


class menuButton extends rButton {

    menuButton(String text, int x, int y) {
        super(text, x, y, 200, 100);
    }

    void display() {
        stroke(255);
        textSize(32);
        noFill();  
        textAlign(CENTER, CENTER);
        text(text, x, y-5, w, h);
        rectMode(CENTER);
        rect(x, y, w, h);
    }


}

class dialogueButton extends rButton {

    dialogueButton(String text, int x, int y) {
        super(text, x, y, 200, 100);
    }

    void display() {
        System.out.println(text);
    }

}
