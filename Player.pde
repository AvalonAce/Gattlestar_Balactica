// Nathan Dejesus - Player Class

class Player {

    int x, y;
    int health;
    Direction direction;
    Input input;
    Ship ship;
    boolean hidden;

    public Player() {
        x = width / 2;
        y = height / 2;
        health = 100;
        direction = Direction.CENTER;
        ship = new Ship();
        hidden = true;
    }

    void display() {
        ship.display(x,y);

    }

    void update() {



    }
    
    void fire() {


    }

    void resetPlayer() {
        health = 100;
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

class Ship {



    Ship() {



    }

    void display(int x, int y) {
        
        // Draw ship 
        strokeWeight(2); rectMode(CENTER);

        drawBody(x,y);
        drawEngines(x,y);
        drawWings(x,y);

        beginCamera();
        camera();
        translate(0,400,-200);
        // rotateY(PI/16);
        rotateX(-PI/3);
        // rotateZ(-PI/16);
        endCamera();
        
    }

    void update() {}

    void drawBody(int x, int y) {
        noFill();
        beginShape();
        vertex(x-35, y+12, 0); // Back
        vertex(x+35, y+12, 0);
        vertex(x+15, y-12, 0);
        vertex(x-15, y-12, 0);
        vertex(x-35, y+12, 0); // Back
        vertex(x-35, y+12, -100); // Bottom
        vertex(x+35, y+12, -100);
        vertex(x+35, y+12, 0); // Bottom
        vertex(x+15, y-12, 0); // Right
        vertex(x+15, y-12, -40); 
        vertex(x+35, y+12, -100); // Right
        vertex(x-35, y+12, -100); // Left
        vertex(x-15, y-12, -40);
        vertex(x-15, y-12, 0); // Left
        vertex(x-15, y-12, -40); // Top
        vertex(x+15, y-12, -40);
        endShape();
    }

    void drawEngines(int x, int y) {
        fill(255);
        pushMatrix();
        translate(x,y,5);
        box(20,10,10);
        translate(-35, 0, -15);
        sphere(10);
        translate(70,0, 0);
        sphere(10);
        popMatrix();
    }

    void drawWings(int x, int y) {
        beginShape(); // Left Wing

        endShape();
        beginShape(); // Right Wing
        
        endShape();
    }

}

class Input {




}

enum Direction {
        UP, DOWN, LEFT, RIGHT, CENTER
    }

