// Nathan Dejesus - Gattlestar Balactica

Player player;
levelHandler levelHandler;
int difficulty = 1;


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
