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
            inCutscene = false;
            
        }

        // Set Dialogue Box -----------------------------------
        String speaker = currentTrack.getSpeaker();
        String statement = currentTrack.getCurrentStatement();
        menu.setContentOfSpeakerBox(speaker, statement);

        // Check if dialogue options are available
        if (currentTrack.optionAtStatement()) {
            isChoice = true;
            menu.setContentOfDialogueMenu(currentTrack.getOptions());

            // Check if a choice has been made, if not return (includes final track extra scene)
            if (menu.optionChosen() && sceneIndex != 5) {

                // Get choice and set the next statement
                int choice = menu.getChoice(); // Also resets the choice
                String response = currentTrack.getResponse(choice); // Get response
                currentTrack.setStatementPlaceholder(choice); // Set response as next statement
                currentTrack.nextStatement(); // Move to next statement
                isChoice = false;
            } else if (menu.optionChosen() && sceneIndex == 5) {
                int choice = menu.getChoice();
                switch (choice) {
                    case 1:
                        speaker = "Gastor";
                        break;
                    case 2:
                        speaker = "Solara";
                        break;
                    case 3:
                        speaker = "You";
                        break;
                }
                System.out.println(speaker);
                String response = currentTrack.getResponse(choice); // Get response
                currentTrack.setSpeakerPlaceholder(speaker); // Set speaker as next speaker
                currentTrack.setStatementPlaceholder(choice); // Set response as next statement
                currentTrack.nextStatement(); // Move to next statement
                isChoice = false;
            }
            else {
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

    String getCurrentStatement() {
        return currentTrack.getCurrentStatement();
    }

    int getCurrentTrackStatementIndex() {
        return currentTrack.getCurrentStatementIndex();
    }

    void setCurrentTrackStatementIndex(int index) {
        currentTrack.setCurrentStatement(index);
    }

    void nextTrack() {
        sceneIndex++;
        if (sceneIndex < DIALOGUE.length) currentTrack = DIALOGUE[sceneIndex];
        else {
            sceneIndex = 0;
            currentTrack = DIALOGUE[sceneIndex];
        }
    }

    int getChoice() {
        return menu.getChoice();
    }



}

class dialogueBox {

    PImage box;
    String name, line1, line2, line3;
    int x, y;
    int IN_FRAME_Y = height/2-178, OUT_FRAME_Y = -500;
    int fadeSpeed = 15;
    boolean reversed = false, hidden = false, center = false;

    dialogueBox(int x, int y, boolean reverse) {
        this.x = x;
        this.y = y;
        this.reversed = reverse;
        box = reverse ? loadImage("img/statement_case_reverse.png") : loadImage("img/statement_case.png");
        this.box.resize(this.box.width/2, this.box.height/2);
        name = "";
        line1 = ""; line2 = ""; line3 = ""; 
    }

    dialogueBox(int x, int y) {
        this.x = x;
        this.y = y;
        box = loadImage("img/statement_case_center.png");
        this.box.resize(this.box.width/2, this.box.height/2);
        name = "";
        line1 = ""; line2 = ""; line3 = ""; 
        center = true;
    }

    void display() {
        if (hidden) return;
        if (center) drawCenterDialogueBox();
        else if (reversed) drawRightDialogueBox();
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

    void drawCenterDialogueBox() {
        pushMatrix();
        rotateX(-cam.getRotX());
        rotateY(-cam.getRotY());
        rotateZ(-cam.getRotZ());
        translate(0,0,-120);
        image(box, x, y);
        // Text
        translate(0,0,5);
        textFont(mainFont); textSize(24); fill(255); textAlign(CENTER,CENTER);
        text(name,x+box.width/2,y);
        text(line1,x+box.width/2,y+30); text(line2,x+box.width/2,y+60); text(line3,x+box.width/2,y+90);
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

    void setSpeaker(String name) {
        speaker[currentStatement] = name;
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

    String getStatement(int index) {
        return statements[index];
    }

    void nextStatement() {
        currentStatement++;
    }

    void setStatementPlaceholder(int choice) {
        statements[currentStatement+1] = responses[choice-1];
    }

    void setSpeakerPlaceholder(String name) {
        speaker[currentStatement+1] = name;
    }

    void resetTrack() {
        currentStatement = 0;
    }

    void playSpeaker(int index) {
        currentSound = statementSounds[index];
        currentSound.play();
    }

    int getCurrentStatementIndex() {
        return currentStatement;
    }

    void setCurrentStatement(int index) {
        currentStatement = index;
    }

}



// ALL DIALOGUE OPTIONS -- 1 Array, 7 dialogueTracks, All scenes have dialogue options

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
        "Good! You'll need to be ready for anything.",
        "Don't ask meaningless questions! Focus on the mission ahead!"
    }, 5),


    // Scene 2
    new dialogueTrack(
        new String[] { // Statements
        "You've made it through the asteroid fields, ACE. Good job!",
        "But the Sopren-Veil aren't going anywhere. You still have a mission to complete!",
        "I've sent coordinates to your ship. Make a lightspeed jump there. I'll contact you after.",
        "(incoming transmission)",
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
        "What? An unknown signal? It's nothing but static.",
        "*Attempt to contact the unknown signal*"
    }), new String[] { // Responses
        "...",
        "...",
        "S- ... He- ... *static* ... *static* ... Don't- "
    }, 4),


    // Scene 3
    new dialogueTrack(
        new String[] { // Statements
        "ACE, ACE! Attention! Hailing ACE!",
        "*He audibly sighs*",
        "I was worried I lost contact with you. But no matter! You're at the coordinates.",
        "You're not at the Sopren-Veil's home planet yet, but  you're closer.",
        "Right now, you need to make it through this dense pocket of space alive.",
        "I know you've heard of it.",
        "Bootes Monstra",
        "This is how we're going to get you through undetected, by going through this void space.",
        "RESPONSE PLACEHOLDER",
        "Let me remind you of why we call it Bootes Monstra.",
        "It's because it's full of space-breathing monsters. There are three types of them here.",
        "The first are the STAR EATERS. They're massive, but       can barely move.",
        "The second are known as LEVIATHANS. They're dragon-like creatures, don't get in their way.",
        "The last are the BOT FLIES. They won't hurt you, but don't let them get into the engines.",
        "If you can make it through, you'll be able to make a jump straight to their home planet.",
        "I believe in you ACE. Humanita needs you.",
        "Good luck.",
        "(incoming transmission)",
        "(you hear more static, but this time, you can hear a voice through it)",
        "Hel- ... *static* You can't trust!- *static* ... -isten to me!- We're not- ",
        "(the transmission cuts off)",
        "...",
        "(you continue forward with your mission)"
    }, new String[] { // Speakers
        "Gastor",
        "Gastor",
        "Gastor",
        "Gastor",
        "Gastor",
        "Gastor",
        "Gastor",
        "Gastor",
        "Gastor",
        "Gastor",
        "Gastor",
        "Gastor",
        "Gastor",
        "Gastor",
        "Gastor",
        "Gastor",
        "Gastor",
        "???",
        "???",
        "???",
        "???",
        "???"
    },
    new DialogueOption(new String[] { // Dialogue Options
        "I see... Good thinking. They won't see us coming!",
        "You sent me to Bootes Monstra?!  Are you insane?!",
        "General, someone was trying to contact me before. I think it- "
    }), new String[] { // Responses
        "Exactly! You're the only one skilled enough to make it through.",
        "I do what I will to win this war! You'll make it through!",
        "You're imagining things! It was probably just interference! Focus ACE, focus!"
    }, 7),


    // Scene 4
    new dialogueTrack(
        new String[] { // Statements
        "YES! You made it through Bootes Monstra! That's our best pilot for you!",
        "But don't get too excited. You're not at the Sopren-Veil's home planet yet.",
        "I've sent you the coordinates to the planet, a few space-knots away.",
        "Once you jump, I'll send my final transmission detailing on what to do next.",
        "Understand?",
        "RESPONSE PLACEHOLDER"
    }, new String[] { // Speakers
        "Gastor",
        "Gastor",
        "Gastor",
        "Gastor",
        "Gastor",
        "Gastor"
    },
    new DialogueOption(new String[] { // Dialogue Options
        "YES SIR!",
        "I understand. I'll be ready for your transmission.",
        "General, I got another transmission! It isn't interference!"
    }), new String[] { // Responses
        "Ata' boy! See you on the other side!",
        "Good. I'll see you soon.",
        "ACE! Do you want to win this war or not?! Just jump!"
    }, 4),


    // Scene 5
    new dialogueTrack(
        new String[] { // Statements
        "Attention. Atention ACE! This is your final mission.",
        "Right in front of you is the Sopren-Veil's home planet. You are going to destroy it.",
        "...",
        "There is a supernova bomb aboard your ship.",
        "I apologize for not telling you earlier.",
        "...",
        "There is a button on the underside of your dashboard.",
        "When you are in range of the planet, press it. It will launch the bomb.",
        "Understand?",
        "RESPONSE PLACEHOLDER",
        "Save humanita. Save us all."
    }, new String[] { // Speakers
        "Gastor",
        "Gastor",
        "Gastor",
        "Gastor",
        "Gastor",
        "Gastor",
        "Gastor",
        "Gastor",
        "Gastor",
        "Gastor",
        "Gastor"
    },
    new DialogueOption(new String[] { // Dialogue Options
        "Of course general. I was born for this mission.",
        "A supernova bomb?! How am I supposed to escape it?",
        "General, what else aren't you telling me?! I- "
    }), new String[] { // Responses
        "That's my ACE.",
        "You'll figure it out. You always do.",
        "No time. Their fleet is coming."
    }, 8),


    // Scene 6
    new dialogueTrack(
        new String[] { // Statements
        "ACE! YOU'RE IN RANGE! PRESS THE BUTTON!", // Gastor
        "*static*", // Unknown
        "(the static you've heard before finally clears)",
        "(A feminine voice comes through)",
        "Don't do it!", // Solara
        "(you look at the transmission signal, it's coming from the planet)",
        "My name is Solara. I am the imperial princess of the Sopren-Veil.",
        "I've been trying to contact you before you left your homeworld!",
        "You can't do this! You can't destroy my people! It's genocide!",
        "Don't listen to her ACE! PRESS THE BUTTON!", // Gastor
        "DON'T! We can handle this another way!", // Solara
        "TURN THAT DAMN    TRANSMISSION OFF AND                    PRESS THE BUTTON!", // Gastor
        "The humanita race have betrayed you! Led you to believe   we were the enemy!", // Solara
        "We're not!",
        "She's lying! DESTROY HER!", // Gastor
        "ACE! I'm not! You can still join the right side! Fight for peace!", // Solara
        "Join me! Together we can end this war and get revenge on those who betrayed you!",
        "PRESS THE BUTTON!", // Gastor
        "(you hear avid banging from other side of the com as he beats the terminal with his fist)",
        "Join me ACE!", // Solara
        "PRESS IT!", // Gastor
        "", // 21
        "RESPONSE PLACEHOLDER", // 22 - Nothing
        "You do nothing.",
        "The transmission from Solara continues as she pleads for you to join her.",
        "But you do nothing.",
        "The transmission from Gastor continues as he demands you to press the button.",
        "But you do nothing.",
        "The transmission from Solara cuts off as she assumes you've betrayed her.",
        "The transmission from Gastor cuts off as he assumes you've betrayed him.",
        "And at that point, you realize the pointlessness of it all.",
        "You're just a pawn in a game of war.",
        "Their game of war.",
        "Humanita, Sopren-Veil, it doesn't matter.",
        "You're done.",
        "You turn off the comms and fly off into the vast expanse of space.",
        "Supernova bomb in hand",
        "And the greatest pilot skills in the galaxy.",
        "Because in the end...",
        "This is your story.",
        "END",
        "You press the button on the underside of your dashboard.", // 41 - Gastor
        "The bomb launches from your ship and heads straight for the planet.",
        "You watch as it gets closer and closer.",
        "And then it hits.",
        "As it does so, you attempt to make a jump to lightspeed.",
        "But your engines have shut down.",
        "Did the button do that?",
        "You'll never know.",
        "You watch as the planet explodes.",
        "And then you're gone.",
        "The Sopren-Veil are no more.",
        "Humanita lives on.",
        "Long live humanita.",
        "END", // 5
        "You refuse to press the button.", // 56 - Solara
        "You refuse to destroy the planet and it's people.",
        "The shouting is loud in your ears from your commander, but you ignore it.",
        "You turn off his comms and listen to Solara.",
        "Her voice is hypnotic.",
        "She tells you to come to her.",
        "To join her.",
        "And you do.",
        "You fly down to the planet and land.",
        "Solara is there to greet you.",
        "And as you step out of your ship, a smirk crosses her face.",
        "And you are shot.",
        "You fall to the ground, dead. The supernova bomb still on your ship.",
        "It appears that's all she wanted.",
        "She didn't really care for you.",
        "Just the bomb.",
        "To make more of them.",
        "And to destroy humanita.",
        "...",
        "As the light fades from your eyes, you wonder if you made the right choice.",
        "But it's too late now.",
        "Long live the Sopren-Veil.",
        "END", // 75
    }, new String[] { // Speakers
        "Gastor",
        "???",
        "???",
        "???",
        "Solara",
        "Solara",
        "Solara",
        "Solara",
        "Solara",
        "Gastor",
        "Solara",
        "Gastor",
        "Solara",
        "Solara",
        "Gastor",
        "Solara",
        "Solara",
        "Gastor",
        "Gastor",
        "Solara",
        "Gastor",
        "...", // 21
        "SPEAKER PLACEHOLDER", 
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        ""
    },
    new DialogueOption(new String[] { // Dialogue Options
        "*Press the button*",
        "*Don't press the button*",
        "*Do nothing*"
    }), new String[] { // Responses
        "YES! I KNEW IN THE END YOU'D DO THE RIGHT THING! LONG LIVE HUMANITA!",
        "Thank you ACE... Come. We have much to discuss.",
        "..."
    }, 21)

};
