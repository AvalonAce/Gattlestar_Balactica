// Nathan Dejesus - Sound Handler for the game
import processing.sound.*;

class soundHandler {


    SoundFile shoot;
    SoundFile enemyDeath;
    SoundFile playerDeath;
    SoundFile menuClick;
    SoundFile dialogueClick;
    SoundFile continueClick;
    SoundFile hit;
    SoundFile gameOver;
    SoundFile transition;
    SoundFile introMusic;
    SoundFile gameMusic;
    SoundFile outroMusic;
    Sound s;

    boolean soundOn = true;

    soundHandler(PApplet p) {

        shoot = new SoundFile(p, "snd/shoot.wav");
        enemyDeath = new SoundFile(p, "snd/enemy_explosion.mp3");
        playerDeath = new SoundFile(p, "snd/player_death.wav");
        menuClick = new SoundFile(p, "snd/menu_click.mp3");
        dialogueClick = new SoundFile(p, "snd/dialogue_click.mp3");
        continueClick = new SoundFile(p, "snd/continue_click.wav");
        hit = new SoundFile(p, "snd/hit.wav");
        gameOver = new SoundFile(p, "snd/game_over.wav");
        transition = new SoundFile(p, "snd/transition.wav");
        introMusic = new SoundFile(p, "snd/intro_music.mp3");
        outroMusic = new SoundFile(p, "snd/ending_music.mp3");
        s = new Sound(p);
    }

    void update() { }

    void playMusic(String music) {
        if (soundOn) {
            switch (music) {
                case "intro":
                    if (outroMusic.isPlaying()) outroMusic.pause();
                    s.volume(0.5);
                    if (!introMusic.isPlaying()) introMusic.loop();
                    break;
                case "outro":
                    if (introMusic.isPlaying()) introMusic.pause();
                    s.volume(0.5);
                    if (!outroMusic.isPlaying()) outroMusic.loop();
                    break;
                case "pause":
                    if (introMusic.isPlaying()) introMusic.pause();
                    if (outroMusic.isPlaying()) outroMusic.pause();
                break;
            }
        }
    }

    


    void playSound(String currentSound) {
        if (soundOn) {
            switch (currentSound) {
                case "dialogueClick":
                    s.volume(0.6);
                    dialogueClick.play();
                    break;
                case "shoot":
                    if (hit.isPlaying()) return;
                    s.volume(0.05);
                    shoot.play();
                    break;
                case "enemyDeath":
                    s.volume(0.08);
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
                case "hit":
                    if (shoot.isPlaying()) return;
                    s.volume(0.5);
                    hit.play();
                break;
                case "gameOver":
                    s.volume(0.5);
                    gameOver.play();
                break;
            }
        }
    }

    void setVolume(float volume) {
        s.volume(volume);
    }

    SoundFile getFile(String sound) {
        switch (sound) {
            case "shoot":
                return shoot;
            case "enemyDeath":
                return enemyDeath;
            case "playerDeath":
                return playerDeath;
            case "menuClick":
                return menuClick;
            case "dialogueClick":
                return dialogueClick;
            case "continueClick":
                return continueClick;
            case "hit":
                return hit;
            case "gameOver":
                return gameOver;
            case "transition":
                return transition;
        }
        return null;
    }


}
