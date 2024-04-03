// Nathan Dejesus - Enemies in the game, includes engines

class levelEngine {

    levelBar progressBar;
    int progress = 0, difficultyTime = 18, currentLevel = 1;
    int MAX_PROGRESS = 5;
    boolean isPaused = false, isLevelOver = false;
    Enemy[] enemies;

    levelEngine() {
        progress = 0;
        progressBar = new levelBar(width/2-180, -40);
        decideDifficulty();
    }

    void display() {
        if (isPaused) return;

     }

    void update() {
        if (isLevelOver) {}
        if (isPaused) {
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

    void reset() {
        isLevelOver = false;
        isPaused = false;
        progress = 0;
        player.reset();
        decideDifficulty();
    }

    void displayLevelBar() {
        progressBar.display();
    }

    void hideLevelBar() {
        progressBar.hide();
    }

    void unhideLevelBar() {
        progressBar.unhide();
    }

    void resetLevelBar() {
        progressBar.reset();
    }

    void pause() {
        isPaused = true;
    }

    void resume() {
        isPaused = false;
    }


    void spawn() {
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
                        enemies[i] = new Asteroid();
                        break;
                    default:
                        enemies[i] = new Asteroid();
                        break;
                }
            }
        
        }
    }

    private void displayEnemies() {
        for (int i = 0; i < enemies.length; i++) {
            if (enemies[i] != null) {
                enemies[i].display();
            }
        }
    }

    private void updateEnemies() {
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

    void removeDeadEnemies() {
        for (int i = 0; i < enemies.length; i++) {
            if (enemies[i] != null && enemies[i].isDead()) {
                enemies[i] = null;
            }
        }
    }

    boolean enemiesAllDead() {
        for (int i = 0; i < enemies.length; i++) {
            if (enemies[i] != null) return false;
        }
        return true;
    }

    private void decideDifficulty() {
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

    boolean levelOver() {
        return progress >= MAX_PROGRESS;
    }

    void setCurrentLevel(int level) {
        currentLevel = level;
    }

    boolean isPaused() {
        return isPaused;
    }

    void gameOver() {
        
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
class Enemy {

    int health, damage, acc;
    boolean isDead = false;
    int cX, cY, cZ;

    Enemy() {}

    void display() {}

    void update() {
        if (isDead()) return;
        if (ifPassedCamera()) isDead = true;
    }
    
    boolean isDead() {
        return isDead;
    }

    

    boolean ifPassedCamera() {
        return cZ > 800;
    }

    void takeDamage(int damage) {
        health -= damage;
        if (health <= 0) {
            isDead = true;
            soundHandler.playSound("enemyDeath");
        }
    }

    int getX() {
        return cX;
    }

    int getY() {
        return cY;
    }

    int getZ() {
        return cZ;
    }

    int getRadius() {
        return 0;
    }

    int getLeftHitBox() {
        return 0;
    }

    int getRightHitBox() {
        return 0;
    }

    int getTopHitBox() {
        return 0;
    }

    int getBottomHitBox() {
        return 0;
    }

    int getFrontHitBox() {
        return 0;
    }

    int getBackHitBox() {
        return 0;
    }

    void invertControls() {}

}

// Asteroid class
class Asteroid extends Enemy {

    int ellipseSize = 1;
    int r, g, b;
    randomBox[] boxes;

    Asteroid() {
        setColor();
        setStats();
        setPos();
        setBoxes(); 
    }

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

    void display() {
        if (isDead()) return;

        // Display asteroid
        drawAsteroid();
    }

    void update() {
        if (isDead()) return;
        super.update();
        // Update asteroid
        cZ += acc;
    }

    private void setStats() {
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

    void drawAsteroid() {
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

class Leviathan extends Enemy {
    
    int hitBoxLeft, hitBoxRight, hitBoxTop, hitBoxBottom, hitBoxFront, hitBoxBack;
    int shiftType = 1, flySpeed = 15, leviathanHeightSize = 50, leviathanWidthSize = 50;
    color[] colors = new color[3];
    color mainColor;
    
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

    void display() {
        if (isDead()) return;

        // Display Leviathan
        drawLeviathan();
    }

    void update() {
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

    void drawLeviathan() {
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


    private void shiftLeft() {
        cX -= flySpeed;
    }

    private void shiftRight() {
        cX += flySpeed;
    }

    private void shiftUp() {
        cY -= flySpeed;
    }

    private void shiftDown() {
        cY += flySpeed;
    }

    private void updateHitBox() {
        hitBoxLeft = cX - leviathanWidthSize;
        hitBoxRight = cX + leviathanWidthSize;
        hitBoxTop = cY + leviathanHeightSize;
        hitBoxBottom = cY - leviathanHeightSize;
        hitBoxFront = cZ - 50;
        hitBoxBack = cZ + 50;
    }

    int getLeftHitBox() {
        return hitBoxLeft;
    }

    int getRightHitBox() {
        return hitBoxRight;
    }

    int getTopHitBox() {
        return hitBoxTop;
    }

    int getBottomHitBox() {
        return hitBoxBottom;
    }

    int getFrontHitBox() {
        return hitBoxFront;
    }

    int getBackHitBox() {
        return hitBoxBack;
    }

}

class StarEater extends Enemy {

    int ellipseSize = 1;

    StarEater() {
        setStats();
        setPos();
    }

    void display() {
        if (isDead()) return;

        // Display Monster
        drawStarEater();
    }

    void update() {
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

    void setPos() {
        cX = (int)random(-100, width+100);
        cY = (int)random(-100, height+100);
        cZ = (int)random(-1500, -1000);
    }



    void drawStarEater() {
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

    int getRadius() {
        return ellipseSize;
    }



}

class BotFly extends Enemy {

    int ellipseSize = 1;

    BotFly() {
        setStats();
        setPos();
    }

       void display() {
        if (isDead()) return;

        // Display Monster
        drawBotFly();
    }

    void update() {
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

    void setPos() {
        cX = (int)random(100, width-100);
        cY = (int)random(100, height-100);
        cZ = (int)random(-1500, -500);
    }


    void drawBotFly() {
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

    int getRadius() {
        return ellipseSize+10;
    }

    void invertControls() {
        player.invertControls();
    }


}


// Ship classes
class enemyShip extends Enemy {}

class bossShip extends Enemy {}

class enemyLaser {}
