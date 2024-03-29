// Nathan Dejesus -- Dialogue Options and Choices

class dialogueHandler {


}

class dialogueBox {

    PImage box;
    String name, line1, line2, line3;
    int x, y;
    int IN_FRAME_Y = height/2-178, OUT_FRAME_Y = -500;
    int fadeSpeed = 15;

    dialogueBox(int x, int y) {
        this.x = x;
        this.y = y;
        box = loadImage("img/statement_case.png");
        this.box.resize(this.box.width/2, this.box.height/2);
        name = "Test"; 
        line1 = "Lorem impsum some cum laude.";
        line2 = "Lorem impsum some cum laude.";
        line3 = "Lorem impsum some cum laude.";
    }

    void display() {
        pushMatrix();
        rotateX(-cam.getRotX());
        rotateY(-cam.getRotY());
        rotateZ(-cam.getRotZ());
        translate(0,0,-100);
        image(box, x, y);
        // Text
        translate(0,0,5);
        textFont(mainFont); textSize(24); fill(255); textAlign(LEFT,CENTER);
        text(name,x+40,y+50);
        text(line1,x+40,y+115); text(line2,x+40,y+145); text(line3,x+40,y+175);
        // Continue Triangle
        drawTriangle();
        popMatrix();
    }

    void update() {}

    void setName(String name) {
        this.name = name;
    }

    void setContent(String l1, String l2, String l3) {
        this.line1 = l1;
        this.line2 = l2;
        this.line3 = l3;
    }

    void fadeIn() {
        y += fadeSpeed;
    }
    
    void fadeOut() {
        y -= fadeSpeed;
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

    void drawTriangle() {
        if (!inFrame()) return;
        fill(255); stroke(255);
        beginShape();
        vertex(x+box.width,y+box.height-25);
        vertex(x+box.width+15,y+box.height+7-25);
        vertex(x+box.width,y+box.height+15-25);
        vertex(x+box.width,y+box.height-25);
        endShape();
    }
    

}

class dialogueMenu {

    PImage box;
    String choice1, choice2, choice3;
    int x, y, choice = 0;
    int IN_FRAME_Y = height/2, OUT_FRAME_Y = height+500;
    int fadeSpeed = 15;
    boolean chosen = false;

    dialogueMenu(int x, int y) {
        this.x = x;
        this.y = y;
        box = loadImage("img/dialogue_box.png");
        this.box.resize(this.box.width/2, this.box.height/2);
        choice1 = "Lorem impsum some cum laude."; // Replace with dialogue optoins and responses
        choice2 = "Lorem impsum some cum laude.";
        choice3 = "Lorem impsum some cum laude.";
    }

    void display() {
        if (chosen) return;
        pushMatrix();
        rotateX(-cam.getRotX());
        rotateY(-cam.getRotY());
        rotateZ(-cam.getRotZ());
        translate(0,0,-175);
        image(box, x, y);
        // Text
        translate(0,0,5);
        textFont(mainFont); textSize(24); fill(255); textAlign(LEFT,CENTER);
        text(choice1,x+40,y+115); text(choice2,x+40,y+145); text(choice3,x+40,y+175);
        popMatrix();
    }

    void update() {
        if (chosen) return;
        highlightChoice();
    }

    void setContent(String l1, String l2, String l3, String l4) {
        this.choice1 = l1;
        this.choice2 = l2;
        this.choice3 = l3;
    }

    void fadeIn() {
        y -= fadeSpeed;
    }
    
    void fadeOut() {
        y += fadeSpeed;
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

    void highlightChoice() {}

    int getChoice() {
        return choice;
    }

}


class Statement {
    
    String content;
    Statement(String content) {
        this.content = content;
    }

    String getContent() {
        return content;
    }

}

class DialogueOption extends Statement {

    String[] choices;
    SoundFile menuClick;

    DialogueOption(String content, String[] choices) {
        super(content);
        this.choices = choices;
    }

    String[] getChoices() {
        return choices;
    }



}
