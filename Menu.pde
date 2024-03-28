// Nathan Dejesus - Menu Handling

class Menu {

    portraitBox Gastor;
    portraitBox Solara;

    Menu() {
        Gastor = new portraitBox(100,-500);
        Solara = new portraitBox(900,-500);
    }

     

}

class dialogueMenu {}

class settingMenu {}

class deathScreen {}

class settingsBox {}

class dialogueBox {}

class portraitBox {

    PImage portrait;
    int x, y;

    portraitBox(int x, int y) {
        this.x = x;
        this.y = y;
    }

    void display() {}

    void update() {}

}
