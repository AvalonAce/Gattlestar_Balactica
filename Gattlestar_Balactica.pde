// Nathan Dejesus - Gattlestar Balactica

// Main Global Classes -- Player, Input, Cam, Level, Graphics, Dialogue, Sound
Player player;
Input input;
Camera cam;
levelHandler levelHandler;
graphicsHandler graphicsHandler;
dialogueHandler dialogueHandler;
soundHandler soundHandler;

// Main Global Vars -- Difficulty, StartTime (animnation flag), Cam Pos, Fonts
int difficulty = 0;
int startTime = 0;
float cameraX, cameraY, cameraZ, centerX, centerY, centerZ;
PFont mainFont, titleFont;


// Set up
void setup() {
  size(1000,1000,P3D);
  background(0);
  // Font
  mainFont = createFont("./font/main.otf", 32);
  titleFont = createFont("./font/title.ttf", 148);

  // Setup Variables
  player = new Player();
  cam = new Camera();
  input = new Input();
  soundHandler = new soundHandler(this);
  graphicsHandler = new graphicsHandler();
  dialogueHandler = new dialogueHandler();
  levelHandler = new levelHandler(player, soundHandler, graphicsHandler);

  // Camera Setup
  cameraX = width/2.0; cameraY = height/2.0; cameraZ = (height/2.0) / tan(PI*30.0 / 180.0);
  centerX = width/2.0; centerY = height/2.0; centerZ = 0;

}

// Draw -- Draw/Update
void draw() {
  cam.update(); // Update Camera
  input.update(); // Update Input

  levelHandler.display(); // Display Current Level
  levelHandler.update(); // Update Current Level

  graphicsHandler.display(); // Display Graphics
  graphicsHandler.update(); // Update Graphics

}

void mousePressed() { // Mouse Pressed
  mouseClicked = true;
  input.mPressed();
}

 void mouseReleased() { // Mouse Released
  mouseClicked = false;
  input.mReleased();
}

void keyPressed() { // Key Pressed
  input.kPressed(key);
}

void keyReleased() { // Key Released
  input.kReleased(key);
}

int currentSecond() { // Get Time in Seconds
  return (int) (millis() / 1000.0);
}
