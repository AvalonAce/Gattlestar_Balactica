// Nathan Dejesus -- Dialogue Options and Choices

class dialogueHandler {


}

class dialogueBox {
    

}

class dialogueMenu {}


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
