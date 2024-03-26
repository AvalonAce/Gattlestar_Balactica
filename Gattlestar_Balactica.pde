// Nathan Dejesus - Gattlestar Balactica

Player player;
levelHandler levelHandler;
graphicsHandler graphicsHandler;
soundHandler soundHandler = new soundHandler();
int difficulty = 1;
PFont mainFont, titleFont;

void setup() {
  size(1000,1000,P3D);
  background(0);
  mainFont = createFont("./font/main.otf", 32);
  titleFont = createFont("./font/title.ttf", 148);

  // Setup
  player = new Player();
  graphicsHandler = new graphicsHandler();
  levelHandler = new levelHandler(player, soundHandler, graphicsHandler);

  // Camera
  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);

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