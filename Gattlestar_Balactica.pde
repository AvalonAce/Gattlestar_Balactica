// Nathan Dejesus - Gattlestar Balactica

Player player;
levelHandler levelHandler;


void setup() {
  size(1000,1000,P3D);
  background(0);

  // Setup
  player = new Player();
  levelHandler = new levelHandler(player);

}

void draw() {

  levelHandler.display();

}
