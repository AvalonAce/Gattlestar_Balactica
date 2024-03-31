// Nathan Dejesus -- Dialogue Options and Choices

class dialogueHandler { // Handles the dialogue, Menu updates the dialogue boxes

    dialogueTrack currentTrack;
    Menu menu;
    int sceneIndex = 0;
    boolean inCutscene = false, isChoice = false;

    dialogueHandler() {
        menu = new Menu();
        currentTrack = DIALOGUE[sceneIndex];
    }

    void update() {
        // Move to next scene
        if (currentTrack.getCurrentStatement().equals("END")) {
            sceneIndex++;
            inCutscene = false;
            if (sceneIndex < DIALOGUE.length) currentTrack = DIALOGUE[sceneIndex];
            // System.out.println("End of Dialogue");


            if (sceneIndex >= DIALOGUE.length) {
                inCutscene = false;
                sceneIndex = 0;
                currentTrack = DIALOGUE[sceneIndex];
                return;
            }
            
        }

        // Set Dialogue Box -----------------------------------
        String speaker = currentTrack.getSpeaker();
        String statement = currentTrack.getCurrentStatement();
        menu.setContentOfSpeakerBox(speaker, statement);

        // Check if dialogue options are available
        if (currentTrack.optionAtStatement()) {
            isChoice = true;
            menu.setContentOfDialogueMenu(currentTrack.getOptions());

            // Check if a choice has been made, if not return
            if (menu.optionChosen()) {

                // Get choice and set the next statement
                int choice = menu.getChoice(); // Also resets the choice
                String response = currentTrack.getResponse(choice); // Get response
                currentTrack.setStatementPlaceholder(choice); // Set response as next statement
                currentTrack.nextStatement(); // Move to next statement
                isChoice = false;
            } else {
                return;
            }

        }


        // Update dialogue box
        menu.update();
    }

    void display() {
        menu.display();
    }


    void reset() {
        // Restart the dialogue
        inCutscene = false;
        isChoice = false;
        resetAllTracks();
        sceneIndex = 0;
        currentTrack = DIALOGUE[sceneIndex];
    }

    void resetAllTracks() {
        for (int i = 0; i < DIALOGUE.length; i++) {
            DIALOGUE[i].resetTrack();
        }
    }

    void resetToTrack(int index) {
        resetAllTracks();
        currentTrack = DIALOGUE[index];
    }

    Menu menu() {
        return menu;
    }

    void nextStatement() {
        currentTrack.nextStatement();
    }

    void setCutscene(boolean cutscene) {
        inCutscene = cutscene;
    }

    void setChoice(boolean choice) {
        isChoice = choice;
    }

    boolean isInCutscene() {
        return inCutscene;
    }

    boolean isInChoice() {
        return isChoice;
    }

    String getCurrentSpeaker() {
        return currentTrack.getSpeaker();
    }

}

class dialogueBox {

    PImage box;
    String name, line1, line2, line3;
    int x, y;
    int IN_FRAME_Y = height/2-178, OUT_FRAME_Y = -500;
    int fadeSpeed = 15;
    boolean reversed = false, hidden = false;

    dialogueBox(int x, int y, boolean reverse) {
        this.x = x;
        this.y = y;
        this.reversed = reverse;
        box = reverse ? loadImage("img/statement_case_reverse.png") : loadImage("img/statement_case.png");
        this.box.resize(this.box.width/2, this.box.height/2);
        name = "";
        line1 = ""; line2 = ""; line3 = ""; 
    }

    void display() {
        if (hidden) return;
        if (reversed) drawRightDialogueBox();
        else drawLeftDialogueBox();
        
    }

    void update() {
        if (hidden) return;
    }

    void setSpeaker(String name) {
        this.name = name;
    }

    void setContent(String l1) {
        // if the line exceeds 29 characters, set the second line to the rest of the string.
        // If the line exceeds 58 characters, set second line to 35 characters and third line to the rest of the string.
        // Get last word and start from there
        if (l1.length() > 58) {
            int lastSpace = l1.lastIndexOf(" ", 29);
            line1 = l1.substring(0,lastSpace);
            int secondSpace = l1.lastIndexOf(" ", 59);
            line2 = l1.substring(lastSpace+1,secondSpace);
            line3 = l1.substring(secondSpace+1);
        }
        else if (l1.length() > 29) {
            int lastSpace = l1.lastIndexOf(" ", 29);
            line1 = l1.substring(0,lastSpace);
            line2 = l1.substring(lastSpace+1);
            line3 = "";
        } else {
            line1 = l1;
            line2 = "";
            line3 = "";
        }

    }

    void fadeIn() {
        y += fadeSpeed;
        if (y >= IN_FRAME_Y) y = IN_FRAME_Y;
    }
    
    void fadeOut() {
        y -= fadeSpeed;
        if (y <= OUT_FRAME_Y) y = OUT_FRAME_Y;
    }

    boolean inFrame() {
        if (y >= IN_FRAME_Y) {
            return true;
        } else {
            return false;
        }
    }

    boolean outFrame() {
        if (y <= OUT_FRAME_Y) {
            return true;
        } else {
             return false;
        }
    }

    void drawLeftDialogueBox() {
        pushMatrix();
        rotateX(-cam.getRotX());
        rotateY(-cam.getRotY());
        rotateZ(-cam.getRotZ());
        translate(0,0,-120);
        image(box, x, y);
        // Text
        translate(0,0,5);
        textFont(mainFont); textSize(24); fill(255); textAlign(LEFT,CENTER);
        text(name,x+36,y+50);
        text(line1,x+25,y+115); text(line2,x+25,y+145); text(line3,x+25,y+175);
        // Continue Triangle
        drawTriangleL();
        popMatrix();
    }

    void drawRightDialogueBox() {
        pushMatrix();
        rotateX(-cam.getRotX());
        rotateY(-cam.getRotY());
        rotateZ(-cam.getRotZ());
        translate(0,0,-120);
        image(box, x, y);
        // Text
        translate(0,0,5);
        textFont(mainFont); textSize(24); fill(255); textAlign(LEFT,CENTER);
        text(name,x+box.width-125,y+50);
        text(line1,x+40,y+115); text(line2,x+40,y+145); text(line3,x+40,y+175);
        // Continue Triangle
        drawTriangleR();
        popMatrix();
    }

    void drawTriangleL() {
        if (!inFrame()) return;
        fill(255); stroke(255);
        beginShape();
        vertex(x+box.width,y+box.height-25);
        vertex(x+box.width+15,y+box.height+7-25);
        vertex(x+box.width,y+box.height+15-25);
        vertex(x+box.width,y+box.height-25);
        endShape();
    }

    void drawTriangleR() {
        if (!inFrame()) return;
        fill(255); stroke(255);
        beginShape();
        vertex(x,y+box.height-25);
        vertex(x-15,y+box.height+7-25);
        vertex(x,y+box.height+15-25);
        vertex(x,y+box.height-25);
        endShape();
    }

    void hide() {
        hidden = true;
    }

    void unhide() {
        hidden = false;
    }
    

}

class dialogueMenu {

    PImage box;
    String choice1L1, choice1L2, choice2L1, choice2L2, choice3L1, choice3L2;
    int x, y, choice = 0;
    int IN_FRAME_Y = height/2+60, OUT_FRAME_Y = height+500;
    int fadeSpeed = 20;
    boolean chosen = false;

    dialogueMenu(int x, int y) {
        this.x = x;
        this.y = y;
        box = loadImage("img/dialogue_box.png");
        this.box.resize(this.box.width/2, this.box.height/2);
        // Initialize strings
        choice1L1 = "OPTION 1"; choice1L2 = "";
        choice2L1 = "OPTION 2"; choice2L2 = "";
        choice3L1 = "OPTION 3"; choice3L2 = "";
    }

    void display() {
        if (chosen) fadeOut();
        pushMatrix();
        rotateX(-cam.getRotX());
        rotateY(-cam.getRotY());
        rotateZ(-cam.getRotZ());
        translate(0,0,-175);
        image(box, x, y);
        // Text
        translate(0,0,5);
        textFont(mainFont); textSize(28); fill(255); textAlign(LEFT,CENTER);
        text(choice1L1,x+44,y+65); text(choice1L2,x+44,y+105);
        text(choice2L1,x+44,y+175); text(choice2L2,x+44,y+215);
        text(choice3L1,x+44,y+285); text(choice3L2,x+44,y+325);
        // Highlight
        highlightChoice();

        popMatrix();
    }

    void update() {
        if (chosen) return;

    }

    void setContent(String l1, String l2, String l3) {
        // If the line exceeds 35 characters, set the second line to the rest of the string
        // Get last word and start from there
        if (l1.length() > 35) {
            int lastSpace = l1.lastIndexOf(" ", 35);
            choice1L1 = l1.substring(0,lastSpace);
            choice1L2 = l1.substring(lastSpace+1);
        } else {
            choice1L1 = l1;
            choice1L2 = "";
        }
        if (l2.length() > 35) {
            int lastSpace = l2.lastIndexOf(" ", 35);
            choice2L1 = l2.substring(0,lastSpace);
            choice2L2 = l2.substring(lastSpace+1);
        } else {
            choice2L1 = l2;
            choice2L2 = "";
        }
        if (l3.length() > 35) {
            int lastSpace = l3.lastIndexOf(" ", 35);
            choice3L1 = l3.substring(0,lastSpace);
            choice3L2 = l3.substring(lastSpace+1);
        } else {
            choice3L1 = l3;
            choice3L2 = "";
        }
    }

    void fadeIn() {
        y -= fadeSpeed;
        if (y <= IN_FRAME_Y) y = IN_FRAME_Y;
    }
    
    void fadeOut() {
        y += fadeSpeed;
        if (y >= OUT_FRAME_Y) {
            y = OUT_FRAME_Y;
            chosen = false;
        }
    }

    boolean inFrame() {
        if (y <= IN_FRAME_Y) {
            return true;
        } else {
            return false;
        }
    }

    boolean outFrame() {
        if (y >= OUT_FRAME_Y) {
            return true;
        } else {
             return false;
        }
    }

    void highlightChoice() {
        if (chosen) return;
        // Highlight portion of the menu based on mouse position by adding white rectangle, also sets choice variable
        pushMatrix();
        translate(0,0,5);
        if (mouseX > x+70 && mouseX < x+box.width-70) {
            if (mouseY > y+10 && mouseY < y+box.height/3-20) {
                fill(255,100); 
                rect(width/2-10,y+87,box.width-90,box.height/3-40);
                if (mousePressed) {
                    soundHandler.playSound("dialogueClick");
                    choice = 1;
                    chosen = true;
                    // System.out.println("Choice 1");
                }
            } else if (mouseY > y+box.height/3-21 && mouseY < y+box.height/3*2-60) {
                fill(255,100); 
                rect(width/2-10,y+197,box.width-90,box.height/3-40);
                if (mousePressed) {
                    soundHandler.playSound("dialogueClick");
                    choice = 2;
                    chosen = true;
                    // System.out.println("Choice 2");
                }
            } else if (mouseY > y+box.height/3*2-61 && mouseY < y+box.height-100) {
                fill(255,100); 
                rect(width/2-10,y+307,box.width-90,box.height/3-40);
                if (mousePressed) {
                    soundHandler.playSound("dialogueClick");
                    choice = 3;
                    chosen = true;
                    // System.out.println("Choice 3");
                }
            }

        }
        popMatrix();
    }

    int getChoice() {
        int temp = choice;
        choice = 0;
        chosen = false;
        return temp;
    }

    boolean isChosen() {
        return chosen;
    }

}

class DialogueOption {

    String[] choices;

    DialogueOption(String[] choices) {
        this.choices = choices;
    }

    String[] getChoices() {
        return choices;
    }



}

class dialogueTrack {
    
    String[] statements;
    String[] responses;
    String[] speaker;
    SoundFile[] statementSounds;
    SoundFile[] responseSounds;
    SoundFile currentSound;
    DialogueOption options;
    int currentStatement = 0, optionsAppearAt = 0;

    dialogueTrack(String[] statements, String[] speaker) {
        this.statements = statements;
        this.speaker = speaker;
        options = null;
    }

    dialogueTrack(String[] statements, String[] speaker, DialogueOption options, String[] responses, int optionsAppearAt) {
        this.statements = statements;
        this.responses = responses;
        this.speaker = speaker;
        this.options = options;
        this.optionsAppearAt = optionsAppearAt;
    }

    String getCurrentStatement() {
        if (currentStatement >= statements.length) return "END";
        return statements[currentStatement];
    }
    
    String[] getOptions() {
        return options.getChoices();
    }

    String getSpeaker() {
        if (currentStatement >= speaker.length) return "END";
        return speaker[currentStatement];
    }

    boolean optionAtStatement() {
        if (currentStatement == optionsAppearAt) return true;
        return false;
    }

    boolean optionIsFinalStatement() {
        if (optionsAppearAt == statements.length-1) return true;
        return false;
    }

    String getResponse(int choice) {
        return responses[choice-1];
    }

    void nextStatement() {
        currentStatement++;
    }

    void setStatementPlaceholder(int choice) {
        statements[currentStatement+1] = responses[choice-1];
    }

    void resetTrack() {
        currentStatement = 0;
    }

    void playSpeaker(int index) {
        currentSound = statementSounds[index];
        currentSound.play();
    }


}



// ALL DIALOGUE OPTIONS -- 1 Array, 7 dialogueTracks, All scenes have dialogue options
// 9 SCENES, 3 PER LEVEL

dialogueTrack[] DIALOGUE = {

    // Scene 1
    new dialogueTrack(
        new String[] { // Statements
        "Attention ACE! It's General Gastor! The commander in chief of the humanita space force!",
        "I see that you're adjusting to the new ship well. It's what's going to win us this war!",
        "The Sopren-Veil need to be wiped off our star maps!",
        "You're our best pilot, ACE. That's why you're going on the mission no one else can.",
        "Up ahead is your first challenge. The asteroid fields. They're pretty, but dangerous.",
        "Don't get distracted. I'll contact you when you're through.",
        "RESPONSE PLACEHOLDER"
    }, new String[] { // Speakers
        "Gastor",
        "Gastor",
        "Gastor",
        "Gastor",
        "Gastor",
        "Gastor",
        "Gastor"
    },
    new DialogueOption(new String[] { // Dialogue Options
        "Of course general! Long live humanita!",
        "I'm ready for the challenge.",
        "Wait, I forgot to read the briefing packet. What mission? What war?"
    }), new String[] { // Responses
        "Long live humanita!",
        "Good. You'll need to be ready for anything.",
        "Don't ask meaningless questions! Focus on the mission ahead!"
    }, 5),


    // Scene 2
    new dialogueTrack(
        new String[] { // Statements
        "You've made it through the asteroid fields, ACE. Good job!",
        "But the Sopren-Veil aren't going anywhere. You still have a mission to complete!",
        "I've sent coordinates to your ship. Make a lightspeed jump there. I'll contact you after.",
        "...",
        "*Static*",
        "RESPONSE PLACEHOLDER"
    }, new String[] { // Speakers
        "Gastor",
        "Gastor",
        "Gastor",
        "???",
        "???",
        "???"
    },
    new DialogueOption(new String[] { // Dialogue Options
        "*Ignore the failed communication and jump*",
        "What? An unknown signal? Something's not right.",
        "*Attempt to contact the unknown signal*"
    }), new String[] { // Responses
        "...",
        "...",
        "S- ... He- ... *static* ... *static* ... Don't- "
    }, 4),

};
