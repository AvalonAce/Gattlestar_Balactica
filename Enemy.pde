// Nathan Dejesus - Enemies in the game, includes engines

class levelEngine {

    levelBar progressBar;
    int progress = 0, difficultyTime = 18;
    int MAX_PROGRESS = 100;
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
        progressBar.setProgress(progress);

        // Enemies
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
        isPaused = false;
    }

    void decideDifficulty() {
        switch (difficulty) {
            case 1:
                difficultyTime = 18; // 30 Seconds
                break;
            case 2:
                difficultyTime = 36; // 1 Minute
                break;
            case 3:
                difficultyTime = 72; // 2 Minutes
                break;
            default :
                difficultyTime = 18; // 30 Seconds
            break;	
            
        }
    }
    
    


}

class Enemy {}

class Asteroid extends Enemy {}

class Monster extends Enemy {}

class enemyShip extends Enemy {}

class bossShip extends Enemy {}

class enemyLaser {}
