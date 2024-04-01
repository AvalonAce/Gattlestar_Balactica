// Nathan Dejesus - Enemies in the game, includes engines

class levelEngine {

    levelBar progressBar;
    int progress = 0, difficultyTime = 18, currentLevel = 1;
    int MAX_PROGRESS = 100;
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
                        enemies[i] = new StarEater();
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
    
    Leviathan() {

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

        // Display Leviathan
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
                damage = 20;
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
        return ellipseSize+20;
    }



}

class BotFly extends Enemy {

    BotFly() {
        super();

    }

}


// Ship classes
class enemyShip extends Enemy {}

class bossShip extends Enemy {}

class enemyLaser {}
