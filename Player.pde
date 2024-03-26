// Nathan Dejesus - Player Class

class Player {

    int x, y;
    int health;
    Direction direction;
    Animate animate;
    boolean hidden;

    public Player() {
        x = width / 2;
        y = height / 2;
        health = 100;
        direction = Direction.CENTER;
        animate = new Animate();
        hidden = true;
    }

    void update() {



    }

    void hide() {
        hidden = true;
    }

    void show() {
        x = width / 2;
        y = height / 2;
        hidden = false;
    }

    

}

class Animate {}

enum Direction {
        UP, DOWN, LEFT, RIGHT, CENTER
    }
