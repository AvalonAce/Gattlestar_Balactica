// Nathan Dejesus - Sound Handler for the game
import processing.sound.*;

class soundHandler {


    SoundFile shoot;
    SoundFile enemyDeath;
    SoundFile playerDeath;
    SoundFile menuClick;
    SoundFile dialogueClick;
    SoundFile continueClick;
    Sound s;

    boolean soundOn = true;

    soundHandler(PApplet p) {

        shoot = new SoundFile(p, "snd/shoot.mp3");
        enemyDeath = null;
        playerDeath = new SoundFile(p, "snd/player_death.wav");
        menuClick = new SoundFile(p, "snd/menu_click.mp3");
        dialogueClick = new SoundFile(p, "snd/dialogue_click.mp3");
        continueClick = new SoundFile(p, "snd/continue_click.wav");
        s = new Sound(p);
    }

    void update() {

        
    }


    void playSound(String currentSound) {
        if (soundOn) {
            switch (currentSound) {
                case "dialogueClick":
                    s.volume(0.6);
                    dialogueClick.play();
                    break;
                case "shoot":
                    s.volume(0.05);
                    shoot.play();
                    break;
                case "enemyDeath":
                    enemyDeath.play();
                    break;
                case "playerDeath":
                    playerDeath.play();
                    break;
                case "menuClick":
                    s.volume(0.8);
                    menuClick.play();
                    break;
                case "continueClick":
                    s.volume(0.6);
                    continueClick.play();
                break;
            }
        }
    }

    void setVolume(float volume) {
        s.volume(volume);
    }


}
