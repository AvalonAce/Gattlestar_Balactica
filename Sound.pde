// Nathan Dejesus - Sound Handler for the game
import processing.sound.*;

class soundHandler {

    SoundFile dialogueClick;
    SoundFile shoot;
    SoundFile enemyDeath;
    SoundFile playerDeath;
    SoundFile menuClick;
    Sound s;

    boolean soundOn = true;

    soundHandler(PApplet p) {
        dialogueClick = new SoundFile(p, "snd/dialogue_click.mp3");
        shoot = new SoundFile(p, "snd/shoot.mp3");
        enemyDeath = null;
        playerDeath = new SoundFile(p, "snd/player_death.mp3");
        menuClick = new SoundFile(p, "snd/menu_click.mp3");
        s = new Sound(p);
    }

    void update() {
        s.volume(1);
    }


    void playSound(String currentSound) {
        if (soundOn) {
            switch (currentSound) {
                case "dialogueClick":
                    dialogueClick.play();
                    break;
                case "shoot":
                    s.volume(0.25); // Lower volume for shooting
                    shoot.play();
                    break;
                case "enemyDeath":
                    enemyDeath.play();
                    break;
                case "playerDeath":
                    playerDeath.play();
                    break;
                case "menuClick":
                    menuClick.play();
                    break;
            }
        }
    }


}
