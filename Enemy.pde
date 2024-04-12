// Nathan Dejesus - Enemies in the game, includes engines

// Level Engine for each level -- Time, Generation, UI Level Bar
class levelEngine {

    // Vars
    levelBar progressBar;
    int progress = 0, difficultyTime = 18, currentLevel = 1;
    int MAX_PROGRESS = 100;
    boolean isPaused = false, isLevelOver = false;
    Enemy[] enemies;

    // Constructor
    levelEngine() {
        progress = 0;
        progressBar = new levelBar(width/2-180, -40);
        decideDifficulty();
    }

    void display() { // Diplay -- Useless
        if (isPaused) return;

     }

    void update() { // Update Function -- Update Constant
        if (isLevelOver) {}
        if (isPaused) { // Engine Paused == Level Over
            if (!enemiesAllDead()) {
                updateEnemies();
                removeDeadEnemies();
                displayEnemies();
            }
            return;
        }

        // Progress bar
        if (frameCount % difficultyTime == 0) {
            progress++;
            if (progress >= MAX_PROGRESS) {
                progress = MAX_PROGRESS;
                isPaused = true;
            }
        }
        progressBar.setProgress(progress, MAX_PROGRESS);

        // Enemies
        spawn();
        displayEnemies();
        updateEnemies();
    }

    void reset() { // Reset Engine
        isLevelOver = false;
        isPaused = false;
        progress = 0;
        player.reset();
        decideDifficulty();
    }

    void displayLevelBar() { /// Display Engine
        progressBar.display();
    }

    void hideLevelBar() { // Hide Bar
        progressBar.hide();
    }

    void unhideLevelBar() { // Unhide Bar
        progressBar.unhide();
    }

    void resetLevelBar() { // Reset bar
        progressBar.reset();
    }

    void pause() { // Pause Engine
        isPaused = true;
    }

    void resume() { // Resume Engine
        isPaused = false;
    }


    void spawn() { // Spawn enemies based on level
        if (isPaused) return;

        // Remove dead enemies
        for (int i = 0; i < enemies.length; i++) {
            if (enemies[i] != null && enemies[i].isDead()) {
                enemies[i] = null;
            }
        }

        // Spawn enemies
        for (int i = 0; i < enemies.length; i++) {
            if (enemies[i] == null) {
                switch (currentLevel) {
                    case 1:
                        enemies[i] = new Asteroid();
                        break;
                    case 2:
                        enemies[i] = decideMonster();
                        break;
                    case 3:
                        enemies[i] = new enemyShip();
                        break;
                    default:
                        enemies[i] = new Asteroid();
                        break;
                }
            }
        
        }
    }

    private void displayEnemies() { // Display Enemies
        for (int i = 0; i < enemies.length; i++) {
            if (enemies[i] != null) {
                enemies[i].display();
            }
        }
    }

    private void updateEnemies() { // Update Enemoies
        for (int i = 0; i < enemies.length; i++) {
            if (enemies[i] != null) {
                enemies[i].update();
                
                // Check if player is touching enemy
                boolean isDead = player.isTouching(enemies[i]); 
                if (isDead) {
                    soundHandler.playSound("hit");
                    player.takeDamage(enemies[i].damage);
                    enemies[i].isDead = true;
                }

                // Check if lazer hits enemy
                for (int j = 0; j < player.getLazers().length; j++) {
                    if (player.getLazers()[j] != null && player.getLazers()[j].isTouching(enemies[i])) {
                        enemies[i].takeDamage(10);
                        player.getLazers()[j] = null;
                    }
                }

            }
        }

    }

    void removeDeadEnemies() { // Remove Dead Enemies
        for (int i = 0; i < enemies.length; i++) {
            if (enemies[i] != null && enemies[i].isDead()) {
                enemies[i] = null;
            }
        }
    }

    boolean enemiesAllDead() { // Check if enemies all dead
        for (int i = 0; i < enemies.length; i++) {
            if (enemies[i] != null) return false;
        }
        return true;
    }

    private void decideDifficulty() { // Decide Level Time and Enemy Amount
        switch (difficulty) {
            case 1:
                difficultyTime = 18; // 30 Seconds
                enemies = new Enemy[25];
                break;
            case 2:
                difficultyTime = 36; // 1 Minute
                enemies = new Enemy[40];
                break;
            case 3:
                difficultyTime = 42; // 1 Minute 15 Seconds
                enemies = new Enemy[45];
                break;
            default :
                difficultyTime = 18; // 30 Seconds
                enemies = new Enemy[25];
            break;	
            
        }
    }

    private Enemy decideMonster() {
        // Randomly decide which monster to spawn for level 2
        // StarEaters and leviathans are twice as likely to spawn as botflies
        int monsterChoice = (int)random(1, 100);
        if (monsterChoice <= 40) {
            return new StarEater();
        } else if (monsterChoice > 40 && monsterChoice <= 80) {
            return new Leviathan();
        } else {
            return new BotFly();
        }
    }

    boolean levelOver() { // Level Over getter
        return progress >= MAX_PROGRESS;
    }

    void setCurrentLevel(int level) { // Set current level
        currentLevel = level;
    }

    boolean isPaused() { // Is paused getter
        return isPaused;
    }

    void gameOver() { // Level Engine Game over
        
        isLevelOver = true;
        pause();
        for (int i = 0; i < enemies.length; i++) {
            if (enemies[i] != null) {
                enemies[i] = null;
            }
        }
        progress = 0;
        levelHandler.gameOver();
        

    }
    


}

// Enemy classes ------------------------------
class Enemy { // Universal Enemy Abstract Class

    // Empty Vars
    int health, damage, acc;
    boolean isDead = false;
    int cX, cY, cZ;

    // Empty Constructor
    Enemy() {}

    void display() {} // Empty Display

    void update() { // Update Enemy, dead if off screen
        if (isDead()) return;
        if (ifPassedCamera()) isDead = true;
    }
    
    boolean isDead() { // Is dead getter
        return isDead;
    }

    

    boolean ifPassedCamera() { // Is passed camera/dead getter
        return cZ > 800;
    }

    void takeDamage(int damage) { // Take Damage function for enemy
        health -= damage;
        if (health <= 0) {
            isDead = true;
            soundHandler.playSound("enemyDeath");
        }
    }

    int getX() { // Get X
        return cX;
    }

    int getY() { // Get Y
        return cY;
    }

    int getZ() { // Get Z
        return cZ;
    }

    int getRadius() { // Get Rad
        return 0;
    }

    int getLeftHitBox() { // Get HB - Leviathan
        return 0;
    }

    int getRightHitBox() { // Get HB - Leviathan
        return 0;
    }

    int getTopHitBox() {// Get HB - Leviathan
        return 0;
    }

    int getBottomHitBox() {// Get HB - Leviathan
        return 0;
    }

    int getFrontHitBox() {// Get HB - Leviathan
        return 0;
    }

    int getBackHitBox() {// Get HB - Leviathan
        return 0;
    }

    void invertControls() {} // Invert Controls - Bot Fly

}

// Asteroid class
class Asteroid extends Enemy {

    // Vars
    int ellipseSize = 1;
    int r, g, b;
    randomBox[] boxes;

    // Constructor
    Asteroid() {
        setColor();
        setStats();
        setPos();
        setBoxes(); 
    }

    // Constructor of size and pos
    Asteroid(int x, int y, int z,int size)  {
        this.cX = x;
        this.cY = y; 
        this.cZ = z;
        ellipseSize = size;
        health = (int)random(20, 50);
        damage = 5;
        acc = 5;
        setColor();
        setBoxes();
    }

    void display() { // Display Function -- Draw Asteroid at pos
        if (isDead()) return;

        // Display asteroid
        drawAsteroid();
    }

    void update() { // Update Function -- Move Asteroid
        if (isDead()) return;
        super.update();
        // Update asteroid
        cZ += acc;
    }

    private void setStats() { // Set Stats of Asteroid
        // Set stats based on global difficulty
        switch (difficulty) {
            case 1:
                health = (int)random(20, 50);
                damage = 5;
                acc = 5;
                ellipseSize = (int)random(10, 50);
                break;
            case 2:
                health = (int)random(20, 60);
                damage = 10;
                acc = 10;
                ellipseSize = (int)random(20, 90);
                break;
            case 3:
                health = (int)random(20, 70);
                damage = 15;
                acc = 12;
                ellipseSize = (int)random(30, 100);
                break;
            default:
                health = (int)random(30, 50);
                damage = 5;
                acc = 3;
                ellipseSize = (int)random(10, 50);
                break;
        }
    }

    private void setPos() {
        // Set position of asteroid
        // Random x,y,z within bounds, z from -1000 to 500
        cX = (int)random(-100, width+100);
        cY = (int)random(-100, height+100);
        cZ = (int)random(-1500, -600);
    }

    void setBoxes() {
        // Set boxes for asteroid
        int numBoxes = (int)random(10, 15);
        boxes = new randomBox[numBoxes];
        for (int i = 0; i < numBoxes; i++) {
            boxes[i] = new randomBox(cX, cY, cZ, (int)random(ellipseSize+1,ellipseSize+10));
        }
    }

    private void setColor() {
        // Red, Orange, Yellow, Green, Blue, Purple possible colors
        // Randomly choose color, Red is the most common
        int colorChoice = (int)random(1, 100);

        switch(colorChoice) {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
                r = 255; g = 0; b = 100;
                break;
            case 6:
            case 7:
            case 8:
            case 9:
            case 10:
                r = 255; g = 165; b = 0;
                break;
            case 11:
            case 12:
            case 13:
            case 14:
            case 15:
                r = 255; g = 255; b = 0;
                break;
            case 16:
            case 17:
            case 18:
            case 19:
            case 20:
                r = 0; g = 255; b = 0;
                break;
            case 21:
            case 22:
            case 23:
            case 24:
            case 25:
                r = 0; g = 0; b = 255;
                break;
            case 26:
            case 27:
            case 28:
            case 29:
            case 30:
                r = 128; g = 0; b = 128;
                break;
            default:
                r = 255; g = 0; b = 0;
                break;
        }
    }
 
    void drawAsteroid() { // Draw asteroid
        pushMatrix();

        translate(cX, cY, cZ);
        strokeWeight(1); stroke(r,g,b,20); fill(r,g,b, 50);
        ellipse(0, 0, ellipseSize, ellipseSize);
        for (int i = 0; i < boxes.length; i++) boxes[i].drawBox();

        popMatrix();
    }

    int getRadius() {
        return ellipseSize+5;
    }

    

}


// Monster classes

// Enemey Leviathan
class Leviathan extends Enemy {

    // Vars
    int hitBoxLeft, hitBoxRight, hitBoxTop, hitBoxBottom, hitBoxFront, hitBoxBack;
    int shiftType = 1, flySpeed = 15, leviathanHeightSize = 50, leviathanWidthSize = 50;
    color[] colors = new color[3];
    color mainColor;
    
    // Constructor
    Leviathan() {
        

        // Type - 1: Left to Right, 2: Right to Left, 3: Down to Up, 4: Up to Down
        shiftType = (int)random(1, 5);
        // Stats
        setStats();
        setSize();
        setPos();
        // Three possible colors for Leviathan - Purple, Blue, Dark Green
        colors[0] = color(128, 0, 128, 20); colors[1] = color(0, 0, 255, 30); colors[2] = color(0, 100, 0, 30);
        mainColor = colors[(int)random(0, 3)];

    }

    void display() { // Display Function -- Draw Enemy
        if (isDead()) return;

        // Display Leviathan
        drawLeviathan();
    }

    void update() { // Update Enemy
        if (isDead()) return;
        super.update();
        // Update Monster
        cZ += acc;
        shiftLeviathan();
        updateHitBox();
    }

    void setStats() {
        // Set stats based on global difficulty
        switch (difficulty) {
            case 1:
                health = 10;
                damage = 5;
                acc = 5;
                break;
            case 2:
                health = (int)random(10, 30);
                damage = 8;
                acc = 10;
                break;
            case 3:
                health = (int)random(20,40);
                damage = 10;
                acc = 15;
                break;
            default:
                health = 15;
                damage = 5;
                acc = 5;
                break;
        }
    
    }

    void setSize() {

        // Based on difficulty, set size of leviathan
        switch (difficulty) {
            case 1:
                if (shiftType == 1 || shiftType == 2) {
                    leviathanHeightSize = 50;
                    leviathanWidthSize = 2000 + (int)random(0, 800);
                } else {
                    leviathanHeightSize = 2000 + (int)random(0, 800);
                    leviathanWidthSize = 50;
                }
                break;
            case 2:
                if (shiftType == 1 || shiftType == 2) {
                    leviathanHeightSize = 50 + (int)random(0, 25);
                    leviathanWidthSize = 2000 + (int)random(0, 800);
                } else {
                    leviathanHeightSize = 2000 + (int)random(0, 800);
                    leviathanWidthSize = 50 + (int)random(0, 25);
                }
                break;
            case 3:
                if (shiftType == 1 || shiftType == 2) {
                    leviathanHeightSize = 50 + (int)random(0, 75);
                    leviathanWidthSize = 2000 + (int)random(0, 1000);
                } else {
                    leviathanHeightSize = 2000 + (int)random(0, 1000);
                    leviathanWidthSize = 50 + (int)random(0, 75);
                }
                break;
            default:
                if (shiftType == 1 || shiftType == 2) {
                    leviathanHeightSize = 25 + (int)random(0, 75);
                    leviathanWidthSize = 800 + (int)random(0, 1000);
                } else {
                    leviathanHeightSize = 800 + (int)random(0, 1000);
                    leviathanWidthSize = 25 + (int)random(0, 75);
                }
                break;
        }
        
    }

    void setPos() {
        // Based on type (left->right, right->left, up->down, down->up), set position of leviathan to the other side of the screen
        int gap = 150;
        switch (shiftType) {
            case 1:
                cX = width/2 + leviathanWidthSize*2;
                cY = (int)random(-100, height+100);
                if (cX > width/2 - gap && cX < width/2 + gap) {
                    if (cX < width/2) cX -= 200;
                    else cX += 200;
                }
                if (cY > height/2 - gap && cY < height/2 + gap) {
                    if (cY < height/2) cY -= gap;
                    else cY += gap;
                }
                break;
            case 2:
                cX = -leviathanWidthSize*2;
                cY = (int)random(-100, height+100);
                if (cX > width/2 - gap && cX < width/2 + gap) {
                    if (cX < width/2) cX -= gap;
                    else cX += gap;
                }
                if (cY > height/2 - gap && cY < height/2 + gap) {
                    if (cY < height/2) cY -= gap;
                    else cY += gap;
                }
                break;
            case 3:
                cX = (int)random(-100, width+100);
                cY = height/2 + leviathanHeightSize*2;
                if (cX > width/2 - gap && cX < width/2 + gap) {
                    if (cX < width/2) cX -= gap;
                    else cX += gap;
                }
                if (cY > height/2 - gap && cY < height/2 + gap) {
                    if (cY < height/2) cY -= gap;
                    else cY += gap;
                }
                break;
            case 4:
                cX = (int)random(-100, width+100);
                cY = -leviathanHeightSize*2;
                if (cX > width/2 - gap && cX < width/2 + gap) {
                    if (cX < width/2) cX -= gap;
                    else cX += gap;
                }
                if (cY > height/2 - gap && cY < height/2 + gap) {
                    if (cY < height/2) cY -= gap;
                    else cY += gap;
                }
                break;
            default:
                cX =  width/2 + leviathanWidthSize*2;
                cY = (int)random(-100, height+100);
                break;
        }

        switch (difficulty) {
            case 1:
                cZ = (int)random(-3000, -1200);
                break;
            case 2:
                cZ = (int)random(-4000, -2000);
                break;
            case 3:
                cZ = (int)random(-6000, -3500);
                break;
            default:
                cZ = (int)random(-4500, -3000);
                break;
        }
    }

    void drawLeviathan() { // Draw Leviathan
        pushMatrix();

        // Leviathan consists of a box as the main body, a sphere as the head on the side of the shifttype, and two smaller boxes as the eyes
        translate(cX, cY, cZ);
        strokeWeight(1); stroke(0); fill(mainColor);
        box(leviathanWidthSize, leviathanHeightSize, 100);
        // Head
        if (shiftType == 1) {
            translate(-leviathanWidthSize/2, 0, 0);

            pushMatrix();
            box(150, 150, 150);
            noStroke();
            translate(-75,25,0);
            fill(255, 0, 0, 50); strokeWeight(2); stroke(0);
            box(50, 50, 140);
            // Eyes
            translate(0, -50, -50);
            noStroke();
            sphere(25);
            translate(0, 0, 100);
            sphere(25);
            popMatrix();

            // Ears
            translate(50,-75,25);
            fill(mainColor); stroke(0);
            box(50, 100, 50);
            translate(0, 0, -75);
            box(50, 100, 50);
        }
        else if (shiftType == 2) {
            translate(leviathanWidthSize/2, 0, 0);

            pushMatrix();
            box(150, 150, 150);
            noStroke();
            translate(75,25,0);
            fill(255, 0, 0, 50); strokeWeight(2); stroke(0);
            box(50, 50, 140);
            // Eyes
            translate(0, -50, -50);
            noStroke();
            sphere(25);
            translate(0, 0, 100);
            sphere(25);
            popMatrix();

            // Ears
            translate(-50,-75,25);
            fill(mainColor); stroke(0);
            box(50, 100, 50);
            translate(0, 0, -75);
            box(50, 100, 50);
        }
        else if (shiftType == 4) {
            translate(0, leviathanHeightSize/2, 0);

            pushMatrix();
            box(150, 150, 150);
            noStroke();
            translate(25,75,0);
            fill(255, 0, 0, 50); strokeWeight(2); stroke(0);
            box(50, 50, 140);
            // Eyes
            translate(-50, 0, -50);
            noStroke();
            sphere(25);
            translate(0, 0, 100);
            sphere(25);
            popMatrix();

            // Ears
            translate(-75,50,25);
            fill(mainColor); stroke(0);
            box(100, 50, 50);
            translate(0, 0, -75);
            box(100, 50, 50);
        }
        else if (shiftType == 3) {
            translate(0, -leviathanHeightSize/2, 0);

            pushMatrix();
            box(150, 150, 150);
            noStroke();
            translate(25,-75,0);
            fill(255, 0, 0, 50); strokeWeight(2); stroke(0);
            box(50, 50, 140);
            // Eyes
            translate(-50, 0, -50);
            noStroke();
            sphere(25);
            translate(0, 0, 100);
            sphere(25);
            popMatrix();

            // Ears
            translate(-75,-50,25);
            fill(mainColor); stroke(0);
            box(100, 50, 50);
            translate(0, 0, -75);
            box(100, 50, 50);

        }
        
        popMatrix();
    }

    private void shiftLeviathan() {
        // Based on type (left->right, right->left, up->down, down->up), shift leviathan
        switch (shiftType) {
            case 1:
                shiftLeft();
                break;
            case 2:
                shiftRight();
                break;
            case 3:
                shiftUp();
                break;
            case 4:
                shiftDown();
                break;
            default:
                shiftLeft();
                break;
        }
    }


    private void shiftLeft() { // Shift Left
        cX -= flySpeed;
    }

    private void shiftRight() { // Shift Right
        cX += flySpeed;
    }

    private void shiftUp() { // Shift UP
        cY -= flySpeed;
    }

    private void shiftDown() { // Shift Down
        cY += flySpeed;
    }

    private void updateHitBox() { // Update Hitbox based on pos
        hitBoxLeft = cX - leviathanWidthSize;
        hitBoxRight = cX + leviathanWidthSize;
        hitBoxTop = cY + leviathanHeightSize;
        hitBoxBottom = cY - leviathanHeightSize;
        hitBoxFront = cZ - 50;
        hitBoxBack = cZ + 50;
    }

    int getLeftHitBox() { // Get HB
        return hitBoxLeft;
    }

    int getRightHitBox() { // Get HB
        return hitBoxRight;
    }

    int getTopHitBox() { // Get HB
        return hitBoxTop;
    }

    int getBottomHitBox() { // Get HB
        return hitBoxBottom;
    }

    int getFrontHitBox() { // Get HB
        return hitBoxFront;
    }

    int getBackHitBox() { // Get HB
        return hitBoxBack;
    }

}

class StarEater extends Enemy { // Star Eater Enemy Level 2

    // Var
    int ellipseSize = 1;

    // Cons
    StarEater() {
        setStats();
        setPos();
    }

    void display() { // Display Function
        if (isDead()) return;

        // Display Monster
        drawStarEater();
    }

    void update() { // Update Function
        if (isDead()) return;
        super.update();
        // Update Monster
        cZ += acc;
    }

    void setStats() {
        // Set stats based on global difficulty
        switch (difficulty) {
            case 1:
                health = 20;
                damage = 5;
                acc = 5;
                ellipseSize = 40;
                break;
            case 2:
                health = (int)random(20, 30);
                damage = 10;
                acc = 10;
                ellipseSize = 50;
                break;
            case 3:
                health = (int)random(20, 40);
                damage = 15;
                acc = 15;
                ellipseSize = 60;
                break;
            default:
                health = 20;
                damage = 5;
                acc = 5;
                ellipseSize = 50;
                break;
        }
    }

    void setPos() { // Set Position on Spawn
        cX = (int)random(-100, width+100);
        cY = (int)random(-100, height+100);
        cZ = (int)random(-1500, -1000);
    }



    void drawStarEater() { // Draw Enemy -- Star Eater
        pushMatrix();

        // StarEater consists of a sphere with custom starfish shaped tentacles, and a mouth
        translate(cX, cY, cZ);
        strokeWeight(1); 
        noStroke(); fill(255,0,255,20);
        ellipse(0, 0, ellipseSize/1.5, ellipseSize/1.5);
        stroke(255); noFill();
        ellipse(0, 0, ellipseSize, ellipseSize);

        // Rotate towards player
        float angle = atan2(player.getY() - cY, abs(player.getX() - cX));
        rotateX(-angle);
        // Base rotation Y on cZ
        angle = atan2(player.getZ() - cZ - 300, abs(player.getX() - cX));
        // If player is to the right of monster, rotate right
        if (player.getX() > cX) angle = -angle;
        rotateY(angle);

        // Draw Mouth and Tentacles
        translate(0, 0, ellipseSize/2);
        fill(255, 0, 0, 50); stroke(0);
        circle(0, 0, ellipseSize/2);
        translate(0, 0, 1);
        fill(0,99); stroke(0);
        circle(0, 0, ellipseSize/3);
        // Tentacles
        translate(0, 0, 10);
        fill(255,0,0,40); stroke(255, 0, 0, 50); strokeWeight(2);
        beginShape();
        for (int i = 0; i < 360; i+= 60) {
            float x = cos(radians(i)) * ellipseSize/2;
            float y = sin(radians(i)) * ellipseSize/2;
            vertex(x, y);
            x = cos(radians(i+30)) * ellipseSize/1.5;
            y = sin(radians(i+30)) * ellipseSize/1.5;
            vertex(x, y);
        }
        endShape();

        popMatrix();
    }

    int getRadius() { // Get Rad
        return ellipseSize;
    }



}


class BotFly extends Enemy { // Enemey -- Bot Fly

    // Var
    int ellipseSize = 1;

    // Cons
    BotFly() {
        setStats();
        setPos();
    }

       void display() { // Display Function
        if (isDead()) return;

        // Display Monster
        drawBotFly();
    }

    void update() { // Update Function
        if (isDead()) return;
        super.update();
        // Update Monster
        cZ += acc;


    }

    
    void setStats() {
        // Set stats based on global difficulty
        switch (difficulty) {
            case 1:
                health = 10;
                damage = 1;
                acc = 5;
                ellipseSize = 5;
                break;
            case 2:
                health = 10;
                damage = 2;
                acc = 10;
                ellipseSize = 10;
                break;
            case 3:
                health = 20;
                damage = 3;
                acc = 15;
                ellipseSize = 15;
                break;
            default:
                health = 10;
                damage = 1;
                acc = 5;
                ellipseSize = 5;
                break;
        }
    }

    void setPos() { // Set Position on spawn
        cX = (int)random(100, width-100);
        cY = (int)random(100, height-100);
        cZ = (int)random(-1500, -500);
    }


    void drawBotFly() { // Draw Bot FLy
        pushMatrix();

        // BotFly consists of a sphere with wings made of 2 ellipses
        translate(cX, cY, cZ);
        strokeWeight(1); stroke(255,0,0,80); fill(0,255,0,80);
        ellipse(0, 0, ellipseSize, ellipseSize*2);
        // Head
        fill(255,0,0,40); stroke(255,0,0,90);
        translate(0, -ellipseSize, 0);
        ellipse(0, 0, ellipseSize, ellipseSize/2);
        // Wings
        fill(255,0,0,60); stroke(0);
        translate(-ellipseSize/2, ellipseSize, 0);
        ellipse(0, 0, ellipseSize, ellipseSize);
        translate(ellipseSize, 0, 0);
        ellipse(0, 0, ellipseSize, ellipseSize);

        popMatrix();
    }

    int getRadius() { // Get Rad
        return ellipseSize+10;
    }

    void invertControls() { // Invert player controls on call
        player.invertControls();
    }


}


// Ship classes
class enemyShip extends Enemy { // Enemy -- Enemy Ship

    // Vars
    int ellipseSize = 1, fireRate = 60;
    int targetX, targetY, targetZ;
    enemyLaser[] lazers;

    // Cons
    enemyShip() {
        setStats();
        setPos();
        setTarget();
        lazers = new enemyLaser[5];
    }

    void display() { // Display Function
        if (isDead()) return;

        // Display Monster
        drawShip();
    }

    void update() { // Update Function
        if (isDead()) return;
        super.update();
        // Update Monster
        cZ += acc;
        fireLazer();
        updateLazers();
    }

    void setStats() {
        // Set stats based on global difficulty
        switch (difficulty) {
            case 1:
                health = 10;
                damage = 5;
                acc = 5;
                ellipseSize = 30;
                fireRate = 60 + (int)random(-10, 10);
                break;
            case 2:
                health = 20;
                damage = 10;
                acc = 10;
                ellipseSize = 40;
                fireRate = 40 + (int)random(-10, 10);
                break;
            case 3:
                health = (int)random(10, 30);
                damage = 15;
                acc = 15;
                ellipseSize = 30;
                fireRate =  30 + (int)random(-10, 10);
                break;
            default:
                health = 20;
                damage = 5;
                acc = 5;
                ellipseSize = 50;
                break;
        }
    }

    void setPos() { // Set position
        // X and Y points are on a grid, Z is random
        cX = (int)random(-100, width+100) / ellipseSize * ellipseSize;
        cY = (int)random(-100, height+100) / ellipseSize * ellipseSize;
        cZ = (int)random(-2500, -1800) / 100 * 100;
    }

    void setTarget(){
        // Randomly set target of nine points within bounds of screen, random margin of 100
        // 200,200 | width/2, 200 | width-200, 200
        // 200, height/2 | width/2, height/2 | width-200, height/2
        // 200, height-200 | width/2, height-200 | width-200, height-200
        int targetChoice = (int)random(1, 10);
        switch (targetChoice) {
            case 1:
                targetX = 200 + (int)random(-100, 100);
                targetY = 200 + (int)random(-100, 100);
                break;
            case 2:
                targetX = width/2 + (int)random(-100, 100);
                targetY = 200 + (int)random(-100, 100);
                break;
            case 3:
                targetX = width-200 + (int)random(-100, 100);
                targetY = 200 + (int)random(-100, 100);
                break;
            case 4:
                targetX = 200 + (int)random(-100, 100);
                targetY = height/2 + (int)random(-100, 100);
                break;
            case 5:
                targetX = width/2 + (int)random(-100, 100);
                targetY = height/2 + (int)random(-100, 100);
                break;
            case 6:
                targetX = width-200 + (int)random(-100, 100);
                targetY = height/2 + (int)random(-100, 100);
                break;
            case 7:
                targetX = 200 + (int)random(-100, 100);
                targetY = height-200 + (int)random(-100, 100);
                break;
            case 8:
                targetX = width/2 + (int)random(-100, 100);
                targetY = height-200 + (int)random(-100, 100);
                break;
            case 9:
                targetX = width-200 + (int)random(-100, 100);
                targetY = height-200 + (int)random(-100, 100);
                break;
            default:
                targetX = width/2 + (int)random(-100, 100);
                targetY = height/2 + (int)random(-100, 100);
                break;
        }
        // Determine Z target based of relative position of target and enemyship position
        targetZ = (int)abs(300 / cos(tan(dist(cX, cY, targetX, targetY) / abs(cZ))));

    
    }

    void drawShip() { // Draw Ship
        pushMatrix();

        // Ship consists of a diamond shaped body, an small front window, and two wings, purple color
        translate(cX, cY, cZ);
        rotateShip();
        strokeWeight(1); stroke(255,80); fill(128,0,128, 50);
        // Body
        beginShape();
        vertex(-ellipseSize/2, 0, 0); // Left point
        vertex(0, -ellipseSize/2, 0); // Top point
        vertex(ellipseSize/2, 0, 0); // Right point
        vertex(0, ellipseSize/2, 0); // Bottom point
        vertex(-ellipseSize/2, 0, 0); // Left point
        vertex(0,0,ellipseSize/2); // Front point
        vertex(ellipseSize/2, 0, 0); // Right point
        vertex(0,0,-ellipseSize/2); // Back point
        vertex(-ellipseSize/2, 0, 0); // Left point
        vertex(0, ellipseSize/2, 0); // Bottom point
        endShape();
        // Window
        fill(255,0,255, 90); noStroke();
        translate(0, -ellipseSize/4, 0);
        sphere(ellipseSize/6);
        // Wings
        translate(0, ellipseSize/4, 0);
        fill(255, 80); stroke(255);
        beginShape();
        vertex(-ellipseSize/4, 0, ellipseSize/4);
        vertex(-ellipseSize, 0, 0); 
        vertex(-ellipseSize/4, 0, -ellipseSize/4);
        vertex(-ellipseSize/4, 0, ellipseSize/4);
        endShape();
        beginShape();
        vertex(ellipseSize/4, 0, ellipseSize/4);
        vertex(ellipseSize, 0, 0);
        vertex(ellipseSize/4, 0, -ellipseSize/4);
        vertex(ellipseSize/4, 0, ellipseSize/4);
        endShape();

        popMatrix();
    }

    private void rotateShip() {
        // Rotate ship towards player
        float angle = atan2(player.getY() - cY, abs(player.getX() - cX));
        // Adjust by 30 degrees
        if (player.getX() > cX) angle += PI/6;
        else angle -= PI/6;
        rotateX(-angle);
        // Base rotation Y on cZ
        angle = atan2(player.getZ() - cZ - 300, abs(player.getX() - cX));
        // Adjust by 30 degrees
        if (player.getX() > cX) angle = -angle + PI/6;
        else angle = -angle - PI/6;

        rotateY(angle);
    }

    void updateLazers() { // Update Lazer

        for (int i = 0; i < lazers.length; i++) { // Reset lazers
            if (lazers[i] != null && !lazers[i].isActive()) lazers[i] = null;
        }
        for (int i = 0; i < lazers.length; i++) { // Display lazers
            if (lazers[i] != null && lazers[i].isActive()) lazers[i].update();
            if (lazers[i] != null && lazers[i].isActive()) lazers[i].display();
        }

    }

    void fireLazer() {
        // Fire lazer at player based on fireRate
        if (frameCount % fireRate != 0) return;
        for (int i = 0; i < lazers.length; i++) {
            if (lazers[i] == null) {
                lazers[i] = new enemyLaser(cX, cY, cZ, targetX, targetY, targetZ, player);
                break;
            }
        }
    }

    int getRadius() { // Get Ship Rad
        return ellipseSize+5;
    }

}

class enemyLaser { // Enemy Lazer

    // Vars
    Player player;
    int x, y, z;
    int xTarget, yTarget, zTarget;
    int speed, length;
    boolean active = false;

    // Cons
    enemyLaser(int x, int y, int z, int xTarget, int yTarget, int zTarget, Player player) {
        this.x = x;
        this.y = y;
        this.z = z;
        this.xTarget = xTarget;
        this.yTarget = yTarget;
        this.zTarget = zTarget;
        this.player = player;
        speed = 100;
        length = 10;
        active = true;
    }

    enemyLaser() { // Empty Cons
        active = false;
    }

    void display() { // Dipslay
        if (!active) return;
        stroke(255,0,0);
        strokeWeight(2);
        // Draw line in direction of determined target of length length
        beginShape();
        vertex(x, y, z);
        vertex(x + (xTarget - x) / speed * length, y + (yTarget - y) / speed * length, z + (zTarget - z) / speed * length);
        vertex(x,y,z);
        vertex(x + (xTarget - x) / speed * length, y + (yTarget - y) / speed * length, z + (zTarget - z) / speed * length);
        endShape();
    }

    void update() { // Update
        if (zTarget < z) {
            active = false;
            return;
        }
        isTouchingPlayer();
        x += (xTarget - x) / speed * length;
        y += (yTarget - y) / speed * length;
        z += abs((zTarget - z) / speed * length);
    }

    boolean isActive() { // Get is active
        return active;
    }

    boolean isTouchingPlayer() {
        // Check if laser is touching player
        if (x > player.getHitBoxLeft() && x < player.getHitBoxRight() && y < player.getHitBoxBottom() && y > player.getHitBoxTop() && z > player.getHitBoxFront() && z < player.getHitBoxBack()) {
            player.takeDamage(difficulty);
            soundHandler.playSound("hit");
            active = false;
            return true;
        }

        return false;
    }

}
