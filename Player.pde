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
        dead = false;
        disabledFire = false;
    }

    void display() {
        if (dead) return;



        // Lazer display
        checkfire();
        lazerUpdate();

         // Ship display
        ship.activatePlayerCamera();
        moveShip();
        ship.display(x,y, damaged);
        
        // Health display
        health.display();

        
        if (frameCount % 30 == 0) damaged = false;
        
    }

    void update() {
        if (dead) {
            // Game over
            disableFire();
            levelHandler.getLevelEngine().gameOver();
            System.out.println("Player dead");

            return;
        }
        // Health update
        health.update();
        
    }

    void takeDamage(int damage) {
        health.takeDamage(damage);
        damaged = true;
        if (health.getHealth() <= 0) {
            dead = true;
        }
    }
    
    private void checkfire() {
        if (disabledFire) return;
        // Fire lazer on mouse click
        // Delay fire rate using frameCount
        if (input.fire && !damaged) {
            if (frameCount % 10 != 0) return; 
            lazers[currentLazer] = new Lazer(x, y, 0, mouseX, mouseY, -700);
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

    private void lazerUpdate() {

        for (int i = 0; i < lazers.length; i++) { // Reset lazers
            if (lazers[i] != null && !lazers[i].isActive()) lazers[i] = null;
        }
        for (int i = 0; i < lazers.length; i++) { // Display lazers
            if (lazers[i] != null && lazers[i].isActive()) lazers[i].update();
            if (lazers[i] != null && lazers[i].isActive()) lazers[i].display();
        }

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

    void deactivatePlayerCamera() {
        ship.deactivatePlayerCamera();
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

    boolean isTouching(Enemy enemy) {
        return ship.isTouching(enemy);
    }


    void reset() {
        health.reset();
        currentLazer = 0;
        hidden = true;
        damaged = false;
        dead = false;
    }

    void drawTutorialMovement() {
        ship.drawTutorialMovement();
    }

    boolean isDamaged() {
        return damaged;
    }

    Lazer[] getLazers() {
        return lazers;
    }
    

}

class Ship {

    int x, y;
    int hitBoxTop, hitBoxBottom, hitBoxLeft, hitBoxRight;
    int hitBoxBack, hitBoxFront;


    Ship() {}

    void display(int x, int y, boolean damaged) {
        if (damaged) stroke(255,0,0);
        else stroke(255);

        setShipPosition(x, y);
        setHitBox();

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

    void deactivatePlayerCamera() {
        cam.flyingFlag(false);
    }

    private void setShipPosition(int x, int y) {
        this.x = x;
        this.y = y;
    }

    private void setHitBox() {
        hitBoxTop = y - 25;
        hitBoxBottom = y + 15;
        hitBoxLeft = x - 45;
        hitBoxRight = x + 45;
        hitBoxBack = 0;
        hitBoxFront = -100;
        // Debug 
        // stroke(255,0,0); noFill();
        // line(hitBoxLeft, hitBoxTop, hitBoxRight, hitBoxTop);
        // line(hitBoxRight, hitBoxTop, hitBoxRight, hitBoxBottom);
        // line(hitBoxRight, hitBoxBottom, hitBoxLeft, hitBoxBottom);
        // line(hitBoxLeft, hitBoxBottom, hitBoxLeft, hitBoxTop);

        // pushMatrix();
        // translate(0,0,hitBoxFront);
        // line(hitBoxLeft, hitBoxTop, hitBoxRight, hitBoxTop);
        // line(hitBoxRight, hitBoxTop, hitBoxRight, hitBoxBottom);
        // line(hitBoxRight, hitBoxBottom, hitBoxLeft, hitBoxBottom);
        // line(hitBoxLeft, hitBoxBottom, hitBoxLeft, hitBoxTop);
        // popMatrix();
    }

    private void drawBody(int x, int y) {
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

    private void drawEngines(int x, int y) {
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

    private void drawWings(int x, int y) {
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

    void drawTutorialMovement() {
        pushMatrix();
        translate(0,0,-50);
        // Draw W above ship, A left of ship, S below ship, D right of ship with triangles pointing in direction of movement
        // 100 px offset
        fill(255); stroke(255); strokeWeight(1);
        triangle(x, y-125, x-10, y-110, x+10, y-110); // W
        triangle(x-125, y+5, x-110, y-5, x-110, y+15); // A
        triangle(x, y+125, x-10, y+110, x+10, y+110); // S
        triangle(x+125, y+5, x+110, y-5, x+110, y+15); // D


        // WASD text
        textAlign(CENTER, CENTER); textFont(mainFont); textSize(20);
        text("W", x, y-90);
        text("A", x-90, y);
        text("S", x, y+90);
        text("D", x+90, y);

        popMatrix();
    }

    boolean isTouching(Enemy enemy) {
        // Check if player is touching enemy

        // X and Y hitbox check
        if (enemy.getX() + enemy.getRadius() > hitBoxLeft && enemy.getX() - enemy.getRadius() < hitBoxRight) {
            if (enemy.getY() + enemy.getRadius() > hitBoxTop && enemy.getY() - enemy.getRadius() < hitBoxBottom) {
                // Z hitbox check
                if (enemy.getZ() + enemy.getRadius() > hitBoxFront && enemy.getZ() - enemy.getRadius() < hitBoxBack) {
                    return true;
                }
            }
        }

        return false;
    }

}

class Lazer {

    int x, y, z;
    int xTarget, yTarget, zTarget;
    int speed, length;
    boolean active = false;

    Lazer(int x, int y, int z, int xTarget, int yTarget, int zTarget) {
        this.x = x;
        this.y = y;
        this.z = z;
        this.xTarget = xTarget;
        this.yTarget = yTarget;
        this.zTarget = zTarget;
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
        line(x, y, z, x + (xTarget - x) / speed, y + (yTarget - y) / speed, z + (zTarget - z) / speed);
    }

    void update() {
        if (!active) return;
        if (dist(x, y, z, xTarget, yTarget, zTarget) < 10) {
            active = false;
            return;
        }
        x += (xTarget - x) / speed;
        y += (yTarget - y) / speed;
        z += (zTarget - z) / speed;
    }

    boolean isActive() {
        return active;
    }

    boolean isTouching(Enemy enemy) {
        if (dist(x, y, enemy.getX(), enemy.getY()) < enemy.getRadius()) {
            return true;
        }
        return false;
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
