// Nathan Dejesus - Sound Handler for the game
import processing.sound.*;

class soundHandler {

    SoundFile dialogueClick;
    SoundFile shoot;
    SoundFile enemyDeath;
    SoundFile playerDeath;
    SoundFile menuClick;

    boolean soundOn = true;

    soundHandler() {
        // dialogueClick = new SoundFile(this, "snd/dialogue_click.mp3");
        // shoot = new SoundFile(this, "snd/shoot.mp3");
        // enemyDeath = null;
        // playerDeath =  null;
        // menuClick = new SoundFile(this, "snd/menu_click.mp3");
    }


    void playSound(String currentSound) {
        if (soundOn) {
            switch (currentSound) {
                case "dialogueClick":
                    dialogueClick.play();
                    break;
                case "shoot":
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
