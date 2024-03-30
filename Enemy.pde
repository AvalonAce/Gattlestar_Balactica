// Nathan Dejesus - Enemies in the game, includes engines

class levelEngine {

    levelBar progressBar;
    int progress = 0, difficultyTime = 18, currentLevel = 1;
    int MAX_PROGRESS = 1000;
    boolean isPaused = false;
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
        if (isPaused) return;

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
        progress = 0;
        enemies = null;
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

    void pause() {
        isPaused = true;
    }

    void resume() {
        if (isPaused && !levelOver()) {
            isPaused = false;
        }
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
                        enemies[i] = new Asteroid();
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
            }
        }
    }


    private void decideDifficulty() {
        switch (difficulty) {
            case 1:
                difficultyTime = 18; // 30 Seconds
                enemies = new Enemy[25];
                break;
            case 2:
                difficultyTime = 36; // 1 Minute
                enemies = new Enemy[50];
                break;
            case 3:
                difficultyTime = 72; // 2 Minutes
                enemies = new Enemy[100];
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
        if (health <= 0) isDead = true;
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

}

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
                health = (int)random(30, 50);
                damage = 5;
                acc = 3;
                ellipseSize = (int)random(10, 50);
                break;
            case 2:
                health = (int)random(50, 100);
                damage = 15;
                acc = 5;
                ellipseSize = (int)random(20, 75);
                break;
            case 3:
                health = (int)random(100, 150);
                damage = 30;
                acc = 10;
                ellipseSize = (int)random(30, 110);
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
        cX = (int)random(-100, width-100);
        cY = (int)random(-100, height-100);
        cZ = (int)random(-1500, -500);
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

    

}

class bigAsteroid extends Asteroid {

    bigAsteroid() {
        r = 255; g = 0; b = 100;
        ellipseSize = 500;
        setBoxes();
        cX = width/2;
        cY = height/2;
        cZ = -500;
    }

    void display() {
        if (isDead()) return;

        // Display asteroid
        drawAsteroid();
    }

}

class Monster extends Enemy {}

class enemyShip extends Enemy {}

class bossShip extends Enemy {}

class enemyLaser {}
