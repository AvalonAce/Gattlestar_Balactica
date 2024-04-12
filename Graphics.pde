// Nathan Dejesus - Graphics Handler

// Graphics Handling Glass -- Stars (that's it)
class graphicsHandler {

    // Vars
    Star[] stars = new Star[200];
    boolean star_flag = true, title_anim = false;
    int SLOW_STAR_ACC = 1, FAST_STAR_ACC = 5, SUPER_FAST_STAR_ACC = 20;
    int star_acc = 1;
    PImage crosshair = loadImage("./img/crosshair.png");

    // Cons
    graphicsHandler() {
      
      // Init stars
      for (int i = 0; i < stars.length; i++) {
          stars[i] = new Star((int)random(-1000,width+1000),(int)random(-1000,height+1000),(int)random(-1500,500), (int)random(2,11));
      }
      // Init crosshair
      crosshair.resize(50,50);
      cursor(crosshair);


    }

    void display() { // Display
        if (star_flag) drawProceduralStars(stars, star_acc);
        else if (title_anim) drawTitleStars(stars, 10, title_anim);

    }

    void update() { // Update
    }

    void setStarFlag(boolean flag) { // Flag
        star_flag = flag;
    }

    void setTitleFlag(boolean flag) {// Flag
        title_anim = flag;
    }

    void setStarAcc(int acc) { // Acc
        star_acc = acc;
    }

    void setFastStarAcc() { // ACC
        star_acc = FAST_STAR_ACC;
    }

    void setSuperFastStarAcc() {// ACC
        star_acc = SUPER_FAST_STAR_ACC;
    }

    void setSlowStarAcc() {// ACC
        star_acc = SLOW_STAR_ACC;
    }

     void moveStarsBack() { // Animation
        for (int i = 0; i < stars.length; i++) stars[i].move(0,0,-1000);
    }

}

class Camera {

    // Class for handling camera rotation and movement
    // Uses global variables for position of eye and scene center

    // Vars
    float rotX, rotY, rotZ;
    float MAX_X = 4, MAX_Y = 4, MAX_Z = 4;
    boolean flying_ship = false;
    float camAcc = 0.1f;

    Camera() { // Cons
        rotX = 0;
        rotY = 0;
        rotZ = 0;


    }

    void update() { // Update
        // System.out.println("flying_ship: " + flying_ship);

        if (flying_ship) {

            // Player movements translate to camera movements using Input

            if (input.isGoingUp()) incX(camAcc);
            else incX(-camAcc);
            if (input.isGoingDown()) incX(-camAcc);
            else incX(camAcc);
            if (input.isGoingLeft()) incY(-camAcc);
            else incY(camAcc);
            if (input.isGoingRight()) incY(camAcc);
            else incY(-camAcc);


            // MAX CHECK
            if (rotX > MAX_X) rotX = MAX_X;
            if (rotX < -MAX_X) rotX = -MAX_X;
            if (rotY > MAX_Y) rotY = MAX_Y;
            if (rotY < -MAX_Y) rotY = -MAX_Y;
            if (rotZ > MAX_Z) rotZ = MAX_Z;
            if (rotZ < -MAX_Z) rotZ = -MAX_Z;


            // Apply rotations
            beginCamera();
            camera();
            rotX();
            rotY();
            rotZ();
            endCamera();
        }
    }

    void resetRot() { // Rotation
        rotX = 0;
        rotY = 0;
        rotZ = 0;
    }

    void resetCam() { // Reset Cam
        beginCamera();
        camera();
        endCamera();
    }

    void incX(float inc) { // INC
        rotX += inc;
    }

    void incY(float inc) {// INC
        rotY += inc;
    }

    void incZ(float inc) {// INC
        rotZ += inc;
    }

    void rotX() { // ROT
        rotateX(radians(rotX));
    }

    void rotY() {// ROT
        rotateY(radians(rotY));
    }

    void rotZ() {// ROT
        rotateZ(radians(rotZ));
    }

    void flyingFlag(boolean flag) { // FLAG
        flying_ship = flag;
    }

    float getRotX() {// ROT
        return radians(rotX);
    }

    float getRotY() {// ROT
        return radians(rotY);
    }

    float getRotZ() {// ROT
        return radians(rotZ);
    }
    

}

// Stars -- just points basically
class Star {

    // Vars
    int x, y, z;
    int wgt;

    // Cons
    Star(int x, int y, int z, int wgt) {
        this.x = x;
        this.y = y;
        this.z = z;
        this.wgt = wgt;
    }

    // Move
    void move(int x, int y, int z) {
        this.x += x;
        this.y += y;
        this.z += z;
    }
    
    void reset() {  // Reset star
        this.x = (int)random(-1000,width+1000);
        this.y = (int)random(-1000,height+1000);
        this.z = (int)random(-1000,200);
        this.wgt = (int)random(2,11);
    }

    void drawStar() { // Draw star
        stroke(255);
        strokeWeight(wgt);
        point(x,y,z);
    }
    
    int getZ() { return z; } // GET

   

}

// For Asteroid Class -- drawing it specifically
class randomBox {
    
    // vars
    int x, y, z, size;
    float rotX, rotY, rotZ;

    // Const
    randomBox(int x, int y, int z, int size) {
        this.x = x;
        this.y = y;
        this.z = z;
        this.size = size;
        setRandomRotation();
    }

    void drawBox() { // Draw
        pushMatrix();
        rotateX(radians(rotX));
        rotateY(radians(rotY));
        rotateZ(radians(rotZ));
        box(size);
        popMatrix();
    }



    void setRandomRotation() { // Random Rot
        rotX = random(0,360);
        rotY = random(0,360);
        rotZ = random(0,360);
    }

    


}

// Planet Class for Level 3
class Planet {

    // Vars
    int x, y, z, size;
    float rotX, rotY, rotZ;
    boolean atPlayer = false, hide = false;
    PImage texture;
    PShape planet;

    // Cons
    Planet(int x, int y, int z, int size) {
        this.x = x;
        this.y = y;
        this.z = z;
        this.size = size;
        this.texture = loadImage("./img/planet.png");
        planet = createShape(SPHERE, size);
        planet.setTexture(texture);
        planet.setStroke(color(0,0,0,0));
        rotX = 0;
        rotY = 0;
        rotZ = 0;
    }

    // Draw
    void drawPlanet() {
        pushMatrix();
        translate(x,y,z);
        rotateX(radians(rotX));
        rotateY(radians(rotY));
        rotateZ(radians(rotZ));
        shape(planet);
        popMatrix();
    }

    void update() { // Update
        rotatePlanetY(0.2);
    }

    void rotatePlanetX(float inc) { // ROT
        rotX += inc;
    }

    void rotatePlanetY(float inc) { // ROT
        rotY += inc;
        if (rotY > 360) rotY = 0;
    }

    void rotatePlanetZ(float inc) { // ROT
        rotZ += inc;
    }

    void shiftToPlayer() { // Move to Plyaer
        if (z < -1200) z += 10;
        else atPlayer = true;
    }

    boolean atPlayer() { // At Player
        return atPlayer;
    }

    void hidePlanet() { // Hide
        hide = true;
    }

    void showPlanet() { // Reveal
        hide = false;
    }

    boolean isHidden() { // GET
        return hide;
    }

}

void drawProceduralStars(Star[] stars, int star_acc) { // Draw the stars procedurally
  
    // Draw the stars
    for (int i = 0; i < stars.length; i++) stars[i].drawStar();
 
    // Move the stars
    for (int i = 0; i < stars.length; i++) stars[i].move(0,0,star_acc);
      
    // Reset the stars if beyond sight
    for (int i = 0; i < stars.length; i++) {
       if (stars[i].getZ() > 866) stars[i].reset();

    }

}

void drawTitleStars(Star[] stars, int star_acc, boolean title_anim) { // move the stars out to empty screen
  
    // Draw the stars
    for (int i = 0; i < stars.length; i++) stars[i].drawStar();
 
    // Move the stars
    for (int i = 0; i < stars.length; i++) stars[i].move(0,0,star_acc);
    
    int c = 0;
    for (int i = 0; i < stars.length; i++) {
       if (stars[i].getZ() > 866) c++;
       if (c == stars.length) {
           title_anim = false;
           break;
       }
    } 

}
