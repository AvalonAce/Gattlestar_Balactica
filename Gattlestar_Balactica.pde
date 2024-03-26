// Nathan Dejesus - Gattlestar Balactica

Player player;
levelHandler levelHandler;
soundHandler soundHandler = new soundHandler();
int difficulty = 1;


void setup() {
  size(1000,1000,P3D);
  background(0);

  // Setup
  player = new Player();
  levelHandler = new levelHandler(player, soundHandler);

}

void draw() {

  levelHandler.display();
  levelHandler.update();

}
