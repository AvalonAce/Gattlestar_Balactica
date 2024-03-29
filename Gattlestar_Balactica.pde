// Nathan Dejesus - Gattlestar Balactica

Player player;
Input input;
Camera cam;
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
  cam = new Camera();
  input = new Input();
  soundHandler = new soundHandler(this);
  graphicsHandler = new graphicsHandler();
  levelHandler = new levelHandler(player, soundHandler, graphicsHandler);

  // Camera
  cameraX = width/2.0; cameraY = height/2.0; cameraZ = (height/2.0) / tan(PI*30.0 / 180.0);
  centerX = width/2.0; centerY = height/2.0; centerZ = 0;
  System.out.println("Camera: " +(height/2.0) / tan(PI*30.0 / 180.0));

}


void draw() {
  
  cam.update();
  input.update();

  levelHandler.display();
  levelHandler.update();

  graphicsHandler.display();
  graphicsHandler.update();
  



  // // Display camera axis
  // stroke(255,0,0);
  // line(width/2, height/2, 0, width/2 + 100, height/2, 0);d
  // stroke(0,255,0);
  // line(width/2, height/2, 0, width/2, height/2 + 100, 0);
  // stroke(0,0,255);
  // line(width/2, height/2, 0, width/2, height/2, 100);

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
