// Nathan Dejesus - Player Class

class Player {

    // Vars
    int x, y;
    Health health;
    int currentLazer;
    Ship ship;
    boolean hidden, damaged, dead, disabledFire, invertedControls;
    Lazer[] lazers = new Lazer[8];

    // Cons
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
        invertedControls = false;
    }

    void display() { // Display
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

    void update() { // Player Update
        if (dead) {
            // Game over
            disableFire();
            levelHandler.getLevelEngine().gameOver();

            return;
        }
        // Health update
        health.update();
        
    }

    void takeDamage(int damage) { // Take Damage Function
        health.takeDamage(damage);
        damaged = true;
        if (health.getHealth() <= 0) {
            dead = true;
        }
    }
    
    private void checkfire() { // Fire from ship on click
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
    
    void disableFire() { // disable fire
        disabledFire = true;
    }

    void enableFire() { // enable fire
        disabledFire = false;
    }

    private void lazerUpdate() { // Lazer Update

        for (int i = 0; i < lazers.length; i++) { // Reset lazers
            if (lazers[i] != null && !lazers[i].isActive()) lazers[i] = null;
        }
        for (int i = 0; i < lazers.length; i++) { // Display lazers
            if (lazers[i] != null && lazers[i].isActive()) lazers[i].update();
            if (lazers[i] != null && lazers[i].isActive()) lazers[i].display();
        }

    }

    void moveShip() { // Move ship based on inputs
        if (!invertedControls) {
            if (input.isGoingUp()) y -= 15;
            if (input.isGoingDown()) y += 15;
            if (input.isGoingLeft()) x -= 15;
            if (input.isGoingRight()) x += 15;
        }
        // Inverted controls check
        else  {
            if (input.isGoingUp()) y += 15;
            if (input.isGoingDown()) y -= 15;
            if (input.isGoingLeft()) x += 15;
            if (input.isGoingRight()) x -= 15;
        }
        if (frameCount % 30 == 0) invertedControls = false;

        // Boundary check
        if (x < 25) x = 25;
        if (x > width - 25) x = width - 25;
        if (y < 25) y = 25;
        if (y > height - 25) y = height - 25;
    }

    void hide() { // Hide
        hidden = true;
    }

    void hideHealth() { // hide Health
        health.hide();
    }

    void unhideHealth() { // unhide health
        health.unhide();
    }

    void deactivatePlayerCamera() { // Player cam deactivate
        ship.deactivatePlayerCamera();
    }

    void show() { // show ship
        x = width / 2;
        y = height / 2;
        hidden = false;
    }

    int getX() { // get x coord
        return x;
    }

    int getY() { // get y coord
        return y;
    }

    int getZ() { // get z -> for animation
        return ship.getZ();
    } 

    boolean isTouching(Enemy enemy) { // Enemy touching checker
        return ship.isTouching(enemy);
    }


    void reset() { // Reset Player
        health.reset();
        ship.resetZ();
        currentLazer = 0;
        hidden = true;
        damaged = false;
        dead = false;
        invertedControls = false;
    }

    void resetShipToCenter() { // Reset Ship to center of screen
        x = width / 2;
        y = height / 2;
    }

    void drawTutorialMovement() { // Tutorial Movement
        ship.drawTutorialMovement();
    }

    boolean isDamaged() { // Is damaged function
        return damaged;
    }

    Lazer[] getLazers() { // Getter of lazers
        return lazers;
    }

    void animateForwardDrive(int level) { // Animation out
        ship.animateForwardDrive(level);
    }

    void invertControls() { // Invert controls
        invertedControls = true;
    }

    int getHitBoxLeft() { // GET HB
        return ship.getLeftHitBox();
    }

    int getHitBoxRight() {// GET HB
        return ship.getRightHitBox();
    }

    int getHitBoxTop() {// GET HB
        return ship.getTopHitBox();
    }

    int getHitBoxBottom() {// GET HB
        return ship.getBottomHitBox();
    }

    int getHitBoxFront() {// GET HB
        return ship.getFrontHitBox();
    }

    int getHitBoxBack() {// GET HB
        return ship.getBackHitBox();
    }
    

}

// Ship Class -- Draws Ship
class Ship {

    // Vars
    int x, y, z = 0;
    int hitBoxTop, hitBoxBottom, hitBoxLeft, hitBoxRight;
    int hitBoxBack, hitBoxFront;


    Ship() {} // Cons

    void display(int x, int y, boolean damaged) { // Display -- Draw
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

    void update() {} // Update - Empty

    void activatePlayerCamera() { // Activate Ship Cam
        cam.flyingFlag(true);
    }

    void deactivatePlayerCamera() { // Deact Shjp Cam
        cam.flyingFlag(false);
    }

    private void setShipPosition(int x, int y) { // Set Ship Pos
        this.x = x;
        this.y = y;
    }

    private void setHitBox() { // Set HB
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

    private void drawBody(int x, int y) { // Draw BOdy
        noFill();
        beginShape();
        vertex(x-35, y+12, z); // Back
        vertex(x+35, y+12, z);
        vertex(x+15, y-12, z);
        vertex(x-15, y-12, z);
        vertex(x-35, y+12, z); // Back
        vertex(x-35, y+12, z-100); // Bottom
        vertex(x+35, y+12, z-100);
        vertex(x+35, y+12, z); // Bottom
        vertex(x+15, y-12, z); // Right
        vertex(x+15, y-12, z-40); 
        vertex(x+35, y+12, z-100); // Right
        vertex(x-35, y+12, z-100); // Left
        vertex(x-15, y-12, z-40);
        vertex(x-15, y-12, z); // Left
        vertex(x-15, y-12, z-40); // Top
        vertex(x+15, y-12, z-40);
        endShape();
    }

    private void drawEngines(int x, int y) { // Draw Engines
        fill(1, 206, 178); 
        pushMatrix();
        translate(x,y,z+5);
        box(20,10,10);
        translate(-35, 0, z-15);
        stroke(1, 206, 178);
        sphere(8);
        translate(70,0, z);
        sphere(8);
        popMatrix();
        stroke(255);
    }

    private void drawWings(int x, int y) { // Draw Wings
        fill(1, 206, 178);
        beginShape(); // Left Wing
        vertex(x-27, y, z-30);
        vertex(x-65, y, z-30);
        vertex(x-27, y, z-50);
        endShape();
        beginShape(); // Right Wing
        vertex(x+27, y, z-30);
        vertex(x+65, y, z-30);
        vertex(x+27, y, z-50);
        endShape();
        beginShape(); // Vertical Wing
        vertex(x, y-12, z-10);
        vertex(x, y-35, z-10);
        vertex(x, y-12, z-30);
        endShape();
    }

    void drawTutorialMovement() { // Draw Tutorial Movement
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

        // Mouse text
        text("Mouse - Shoot", x, y+45);

        popMatrix();
    }

    boolean isTouching(Enemy enemy) {
        // Check if player is touching enemy

        // X and Y hitbox check based on enemy type
        if (enemy instanceof Asteroid || enemy instanceof StarEater || enemy instanceof BotFly || enemy instanceof enemyShip) {
            if (enemy.getX() + enemy.getRadius() > hitBoxLeft && enemy.getX() - enemy.getRadius() < hitBoxRight) {
                if (enemy.getY() + enemy.getRadius() > hitBoxTop && enemy.getY() - enemy.getRadius() < hitBoxBottom) {
                    // Z hitbox check
                    if (enemy.getZ() + enemy.getRadius() > hitBoxFront && enemy.getZ() - enemy.getRadius() < hitBoxBack) {
                        if (enemy instanceof BotFly) enemy.invertControls(); // Invert botfly controls
                        return true;
                    }
                }
            }
        }
        
        else if (enemy instanceof Leviathan) {
            if (enemy.getLeftHitBox() < hitBoxRight && enemy.getRightHitBox() > hitBoxLeft) {
                if (enemy.getTopHitBox() > hitBoxBottom && enemy.getBottomHitBox() < hitBoxTop) {
                    if (enemy.getFrontHitBox() < hitBoxBack && enemy.getBackHitBox() > hitBoxFront) {
                        return true;
                    }
                }
            }



        }


        return false;
    }

    void animateForwardDrive(int level) { // Animation Out
        if (z < -6000) {
            levelHandler.getLevels()[level].trueExit();
            return;
        }
        z -= 100;
    }

    void resetZ() { // Reset Z
        z = 0;
    }

    int getZ() { // Get Z
        return z;
    }

    int getLeftHitBox() { // GET HB
        return hitBoxLeft;
    }

    int getRightHitBox() {// GET HB
        return hitBoxRight;
    }

    int getTopHitBox() {// GET HB
        return hitBoxTop;
    }

    int getBottomHitBox() {// GET HB
        return hitBoxBottom;
    }

    int getFrontHitBox() {// GET HB
        return hitBoxFront;
    }

    int getBackHitBox() {// GET HB
        return hitBoxBack;
    }

}

// Lazer Class for Player -- shoot, shoot
class Lazer {

    // Vars
    int x, y, z;
    int xTarget, yTarget, zTarget;
    int speed, length;
    boolean active = false;

    // Cons
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

    // Cons - Empty
    Lazer() {
        active = false;
    }

    void display() { // Display
        if (!active) return;
        stroke(255,0,0);
        strokeWeight(2);
        // Draw line in direction of mouse of length 10
        line(x, y, z, x + (xTarget - x) / speed, y + (yTarget - y) / speed, z + (zTarget - z) / speed);
    }

    void update() { // Update -- Move lazer forward
        if (!active) return;
        if (dist(x, y, z, xTarget, yTarget, zTarget) < 10) {
            active = false;
            return;
        }
        x += (xTarget - x) / speed;
        y += (yTarget - y) / speed;
        z += (zTarget - z) / speed;
    }

    boolean isActive() { // Get is active
        return active;
    }

    boolean isTouching(Enemy enemy) { // Check contact on enemy
        
        if (enemy instanceof Asteroid || enemy instanceof StarEater || enemy instanceof BotFly || enemy instanceof enemyShip) {
            if (dist(x, y, enemy.getX(), enemy.getY()) < enemy.getRadius()) return true;
        }

        else if (enemy instanceof Leviathan) {
            // If lazer is within leviathan hitbox
            if (x + 10 > enemy.getLeftHitBox() && x - 10 < enemy.getRightHitBox()) {
                if (y - 10 < enemy.getTopHitBox() && y + 10 > enemy.getBottomHitBox()) {
                    if (z + 10 > enemy.getFrontHitBox() && z - 10 < enemy.getBackHitBox()) {
                        return true;
                    }
                }
            }


        }

        return false;
    }



}

class Input { // Input class to handle inputs

    // Handle input for player
    // WASD - Movement, Mouse1 - Fire

    // Vars
    boolean up, down, left, right, fire;
    boolean wasGoingUp, wasGoingLeft, moving;

    // Cons
    Input() {
        up = false; down = false; left = false; right = false; fire = false;
        wasGoingUp = false; wasGoingLeft = false; 
    }

    void update() { // Update
        directionCheck();
        
    }

    void kPressed(char key) { // Key Pressed
        if (dialogueHandler.isInCutscene() && !dialogueHandler.isInChoice() && key == ' ' ) {
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

    void kReleased(char key) { // Key released
        moving = false;
        if (key == 'w') up = false;
        if (key == 's') down = false;
        if (key == 'a') left = false;
        if (key == 'd') right = false;
        
    }

    void directionCheck() { // Direction Checking for ship movement
        // No up or down at the same time
        if (wasGoingUp && up && down && moving) up = true;
        else if (!wasGoingUp && up && down && moving) down = true;
        // No left or right at the same time
        if (wasGoingLeft && left && right && moving) left = true;
        else if (!wasGoingLeft && left && right && moving) right = true;
    }

    void mPressed() { // Mouse pressed
        if (dialogueHandler.isInCutscene() && !dialogueHandler.isInChoice()) {
            soundHandler.playSound("continueClick");
            dialogueHandler.nextStatement();
        }
        fire = true;
    }

    void mReleased() { // Mouse released
        fire = false;
    }

    boolean isGoingUp() { // direction getter
        return up;
    }

    boolean isGoingDown() { // direction getter
        return down;
    }

    boolean isGoingLeft() { // direction getter
        return left;
    }

    boolean isGoingRight() { // direction getter
        return right;
    }




}
