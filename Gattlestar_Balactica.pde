// Nathan Dejesus - Gattlestar Balactica

Player player;
Input input;
Camera cam;
levelHandler levelHandler;
graphicsHandler graphicsHandler;
dialogueHandler dialogueHandler;
soundHandler soundHandler;

int difficulty = 1;
int startTime = 0;
float cameraX, cameraY, cameraZ, centerX, centerY, centerZ;
PFont mainFont, titleFont;


void setup() {

  size(1000,1000,P3D);
  background(0);
  // Font
  mainFont = createFont("./font/main.otf", 32);
  titleFont = createFont("./font/title.ttf", 148);
  // Sounds


  // Setup
  player = new Player();
  cam = new Camera();
  input = new Input();
  soundHandler = new soundHandler(this);
  graphicsHandler = new graphicsHandler();
  dialogueHandler = new dialogueHandler();
  levelHandler = new levelHandler(player, soundHandler, graphicsHandler);

  // Camera
  cameraX = width/2.0; cameraY = height/2.0; cameraZ = (height/2.0) / tan(PI*30.0 / 180.0);
  centerX = width/2.0; centerY = height/2.0; centerZ = 0;

}


void draw() {
  cam.update();
  input.update();

  levelHandler.display();
  levelHandler.update();

  graphicsHandler.display();
  graphicsHandler.update();

}

void mousePressed() {
  mouseClicked = true;
  input.mPressed();
}

 void mouseReleased() {
  mouseClicked = false;
  input.mReleased();
}

void keyPressed() {
  input.kPressed(key);
}

void keyReleased() {
  input.kReleased(key);
}

int currentSecond() {
  return (int) (millis() / 1000.0);
}
