// Nathan Dejesus - Graphics Handler

class graphicsHandler {

    Star[] stars = new Star[200];
    boolean star_flag = true, title_anim = false;
    int star_acc = 1;
    PImage crosshair = loadImage("./img/crosshair.png");

    graphicsHandler() {
      
      // Init stars
      for (int i = 0; i < stars.length; i++) {
          stars[i] = new Star((int)random(-1000,width+1000),(int)random(-1000,height+1000),(int)random(-1000,500), (int)random(2,11));
      }
      // Init crosshair
        crosshair.resize(50,50);
      cursor(crosshair);


    }

    void display() {
        if (star_flag) drawProceduralStars(stars, star_acc);
        else if (title_anim) drawTitleStars(stars, 10, title_anim);

        // System.out.println("Star Flag: " + star_flag);
        // System.out.println("Title Flag: " + title_anim);

    }

    void update() {
    }

    void setStarFlag(boolean flag) {
        star_flag = flag;
    }

    void setTitleFlag(boolean flag) {
        title_anim = flag;
    }

    void setStarAcc(int acc) {
        star_acc = acc;
    }

     void moveStarsBack() {
        for (int i = 0; i < stars.length; i++) stars[i].move(0,0,-1000);
    }

}

class Camera {

    // Class for handling camera rotation and movement
    // Uses global variables for position of eye and scene center

    // Debug: Link to mouse position first for testing

    float rotX, rotY, rotZ;
    float MAX_X = 4, MAX_Y = 4, MAX_Z = 4;
    boolean flying_ship = false;
    float camAcc = 0.1f;

    Camera() {
        rotX = 0;
        rotY = 0;
        rotZ = 0;


    }

    void update() {
        // System.out.println("flying_ship: " + flying_ship);

        // Link to mouse position
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

    void resetRot() {
        rotX = 0;
        rotY = 0;
        rotZ = 0;
    }

    void resetCam() {
        beginCamera();
        camera();
        endCamera();
    }

    void incX(float inc) {
        rotX += inc;
    }

    void incY(float inc) {
        rotY += inc;
    }

    void incZ(float inc) {
        rotZ += inc;
    }

    void rotX() {
        rotateX(radians(rotX));
    }

    void rotY() {
        rotateY(radians(rotY));
    }

    void rotZ() {
        rotateZ(radians(rotZ));
    }

    void flyingFlag(boolean flag) {
        flying_ship = flag;
    }

    float getRotX() {
        return radians(rotX);
    }

    float getRotY() {
        return radians(rotY);
    }

    float getRotZ() {
        return radians(rotZ);
    }
    

}

class Star {

    int x, y, z;
    int wgt;

    Star(int x, int y, int z, int wgt) {
        this.x = x;
        this.y = y;
        this.z = z;
        this.wgt = wgt;
    }

    void move(int x, int y, int z) {
        this.x += x;
        this.y += y;
        this.z += z;
    }
    
    void reset() {
        this.x = (int)random(-1000,width+1000);
        this.y = (int)random(-1000,height+1000);
        this.z = (int)random(-1000,200);
        this.wgt = (int)random(2,11);
    }

    void drawStar() {
        stroke(255);
        strokeWeight(wgt);
        point(x,y,z);
    }
    
    int getZ() { return z; }

   

}


void drawProceduralStars(Star[] stars, int star_acc) {
  
    // Draw the stars
    for (int i = 0; i < stars.length; i++) stars[i].drawStar();
 
    // Move the stars
    for (int i = 0; i < stars.length; i++) stars[i].move(0,0,star_acc);
      
    // Reset the stars if beyond sight
    for (int i = 0; i < stars.length; i++) {
       if (stars[i].getZ() > 866) stars[i].reset();

    }

}

void drawTitleStars(Star[] stars, int star_acc, boolean title_anim) {
  
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
