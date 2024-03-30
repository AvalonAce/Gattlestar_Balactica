// Nathan Dejesus - Player Class

class Player {

    int x, y;
    Health health;
    int currentLazer;
    Ship ship;
    boolean hidden, damaged, dead, disabledFire;
    Lazer[] lazers = new Lazer[8];

    public Player() {
        x = width / 2;
        y = height / 2;
        health = new Health(100);
        ship = new Ship();
        currentLazer = 0;
        hidden = true;
        damaged = false;
        disabledFire = false;
    }

    void display() {
        if (false) return;

        // Lazer display
        checkfire();
        for (int i = 0; i < lazers.length; i++) { // Reset lazers
            if (lazers[i] != null && !lazers[i].isActive()) lazers[i] = null;
        }
        for (int i = 0; i < lazers.length; i++) { // Display lazers
            if (lazers[i] != null && lazers[i].isActive()) lazers[i].update();
            if (lazers[i] != null && lazers[i].isActive()) lazers[i].display();
        }

         // Ship display
        ship.activatePlayerCamera();
        moveShip();
        ship.display(x,y, damaged);
        
        // Health display
        health.display();
        
    }

    void update() {
        // Health update
        health.update();
        
    }
    
    void checkfire() {
        if (disabledFire) return;
        // Fire lazer on mouse click
        // Delay fire rate using frameCount
        if (input.fire) {
            if (frameCount % 10 != 0) return; 
            lazers[currentLazer] = new Lazer(x, y, mouseX+(int)map(mouseX, 0, width, -20, 20), mouseY+(int)map(mouseY, 0, height, -20, 20));
            soundHandler.playSound("shoot");
            currentLazer++;
            if (currentLazer > 7) currentLazer = 0;
        }


    }
    
    void disableFire() {
        disabledFire = true;
    }

    void enableFire() {
        disabledFire = false;
    }

    void moveShip() {
        if (input.isGoingUp()) y -= 15;
        if (input.isGoingDown()) y += 15;
        if (input.isGoingLeft()) x -= 15;
        if (input.isGoingRight()) x += 15;
        // Boundary check
        if (x < 25) x = 25;
        if (x > width - 25) x = width - 25;
        if (y < 25) y = 25;
        if (y > height - 25) y = height - 25;
    }

    void hide() {
        hidden = true;
    }

    void hideHealth() {
        health.hide();
    }

    void unhideHealth() {
        health.unhide();
    }

    void show() {
        x = width / 2;
        y = height / 2;
        hidden = false;
    }

    int getX() {
        return x;
    }

    int getY() {
        return y;
    }

    void reset() {
        health.reset();
    }
    

}

class Ship {



    Ship() {



    }

    void display(int x, int y, boolean damaged) {
        if (damaged) stroke(255,0,0);
        else stroke(255);

        // Draw ship 
        strokeWeight(2); rectMode(CENTER); 
        drawWings(x,y);
        drawBody(x,y);
        drawEngines(x,y);
        activatePlayerCamera();
        
    }

    void update() {}

    void activatePlayerCamera() {
        cam.flyingFlag(true);
    }

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
        fill(1, 206, 178); 
        pushMatrix();
        translate(x,y,5);
        box(20,10,10);
        translate(-35, 0, -15);
        stroke(1, 206, 178);
        sphere(8);
        translate(70,0, 0);
        sphere(8);
        popMatrix();
        stroke(255);
    }

    void drawWings(int x, int y) {
        fill(1, 206, 178);
        beginShape(); // Left Wing
        vertex(x-27, y, -30);
        vertex(x-65, y, -30);
        vertex(x-27, y, -50);
        endShape();
        beginShape(); // Right Wing
        vertex(x+27, y, -30);
        vertex(x+65, y, -30);
        vertex(x+27, y, -50);
        endShape();
        beginShape(); // Vertical Wing
        vertex(x, y-12, -10);
        vertex(x, y-35, -10);
        vertex(x, y-12, -30);
        endShape();
    }
}

class Lazer {

    int x, y;
    int xTarget, yTarget;
    int speed, length;
    boolean active = false;

    Lazer(int x, int y, int xTarget, int yTarget) {
        this.x = x;
        this.y = y;
        this.xTarget = xTarget;
        this.yTarget = yTarget;
        speed = 10;
        length = 10;
        active = true;
    }

    Lazer() {
        active = false;
    }

    void display() {
        if (!active) return;
        stroke(255,0,0);
        strokeWeight(2);
        // Draw line in direction of mouse of length 10
        line(x, y, x + (xTarget - x) / speed, y + (yTarget - y) / speed);
    }

    void update() {
        if (!active) return;
        if (dist(x, y, xTarget, yTarget) < length+10) active = false;
        x += (xTarget - x) / speed;
        y += (yTarget - y) / speed;
    }

    boolean isActive() {
        return active;
    }



}

class Input {

    // Handle input for player
    // WASD - Movement, Mouse1 - Fire

    boolean up, down, left, right, fire;
    boolean wasGoingUp, wasGoingLeft, moving;

    Input() {
        up = false; down = false; left = false; right = false; fire = false;
        wasGoingUp = false; wasGoingLeft = false; 
    }

    void update() {
        directionCheck();
        
    }

    void kPressed(char key) {
        if (dialogueHandler.isInCutscene() && !dialogueHandler.isInChoice() && key == ' ' ) {
            System.out.println("Next statement");
            soundHandler.playSound("continueClick");
            dialogueHandler.nextStatement();
        }
        moving = true;
        if (key == 'w') {
            up = true;
            wasGoingUp = true;
        }
        if (key == 's') {
            down = true;
            wasGoingUp = false;
        }
        if (key == 'a') {
            left = true;
            wasGoingLeft = true;
        }
        if (key == 'd') {
            right = true;
            wasGoingLeft = false;
        }
    }

    void kReleased(char key) {
        moving = false;
        if (key == 'w') up = false;
        if (key == 's') down = false;
        if (key == 'a') left = false;
        if (key == 'd') right = false;
        
    }

    void directionCheck() {
        // No up or down at the same time
        if (wasGoingUp && up && down && moving) up = true;
        else if (!wasGoingUp && up && down && moving) down = true;
        // No left or right at the same time
        if (wasGoingLeft && left && right && moving) left = true;
        else if (!wasGoingLeft && left && right && moving) right = true;
    }

    void mPressed() {
        if (dialogueHandler.isInCutscene() && !dialogueHandler.isInChoice()) {
            // System.out.println("Next statement");
            soundHandler.playSound("continueClick");
            dialogueHandler.nextStatement();
        }
        fire = true;
    }

    void mReleased() {
        fire = false;
    }

    boolean isGoingUp() {
        return up;
    }

    boolean isGoingDown() {
        return down;
    }

    boolean isGoingLeft() {
        return left;
    }

    boolean isGoingRight() {
        return right;
    }




}
