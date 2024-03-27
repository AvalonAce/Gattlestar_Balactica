// Nathan Dejesus - Gattlestar Balactica

Player player;
levelHandler levelHandler;
graphicsHandler graphicsHandler;
soundHandler soundHandler;
int difficulty = 0;
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
  soundHandler = new soundHandler(this);
  graphicsHandler = new graphicsHandler();
  levelHandler = new levelHandler(player, soundHandler, graphicsHandler);

  // Camera
  cameraX = width/2.0; cameraY = height/2.0; cameraZ = (height/2.0) / tan(PI*30.0 / 180.0);
  centerX = width/2.0; centerY = height/2.0; centerZ = 0;
  System.out.println("Camera: " +(height/2.0) / tan(PI*30.0 / 180.0));

}


void draw() {
  

  levelHandler.display();
  levelHandler.update();

  graphicsHandler.display();
  

}

void mousePressed() {
  mouseClicked = true;
}

 void mouseReleased() {
  mouseClicked = false;
}