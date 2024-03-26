// Nathan Dejesus - Graphics Handler

class graphicsHandler {

    Star[] stars = new Star[100];

    graphicsHandler() {
      
      // Init stars
      for (int i = 0; i < 100; i++) {
          stars[i] = new Star((int)random(width),(int)random(height),(int)random(500), (int)random(2,12));
      }

    }

    void display() {
        drawProceduralStars(stars);


    }

}

class deathScreen {}

class settingsBox {}

class dialogueBox {}

class potraitBox {}

class portrait {}


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
        this.x = (int)random(width);
        this.y = (int)random(height);
        this.z = 0;
    }

    void drawStar() {
        stroke(255);
        strokeWeight(wgt);
        point(x,y,z);
    }
    
    int getZ() { return z; }

}



// Init stars


void drawProceduralStars(Star[] stars) {
  
    float acc = 1;
    
    // Draw the stars
    for (int i = 0; i < 100; i++) stars[i].drawStar();
 
    // Move the stars
    for (int i = 0; i < 100; i++) stars[i].move(0,0,(int)acc);
      
    // Reset the stars if beyond sight
    for (int i = 0; i < 100; i++) {
       if (stars[i].getZ() > 100) stars[i].reset();
    }


}
