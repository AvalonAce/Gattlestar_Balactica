// Nathan Dejesus - Graphics Handler

class graphicsHandler {

    Star[] stars = new Star[200];
    boolean star_flag = true, title_anim = false;
    int star_acc = 1;
    PImage crosshair = loadImage("./img/crosshair.png");

    graphicsHandler() {
      
      // Init stars
      for (int i = 0; i < stars.length; i++) {
          stars[i] = new Star((int)random(width+500),(int)random(height+500),(int)random(-600,500), (int)random(2,11));
      }
      // Init crosshair
        crosshair.resize(50,50);
      cursor(crosshair);

    }

    void display() {
        if (star_flag) drawProceduralStars(stars, star_acc);
        else if (title_anim) drawTitleStars(stars, 10, title_anim);


    }

    void setStarFlag(boolean flag) {
        star_flag = flag;
    }

    void setTitleFlag(boolean flag) {
        title_anim = flag;
    }

    void setAcc(int acc) {
        star_acc = acc;
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
        this.x = (int)random(width+500);
        this.y = (int)random(height+500);
        this.z = -300 * wgt;
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
