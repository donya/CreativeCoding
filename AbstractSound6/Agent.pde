/*
Agent class for Abstract Sound 6
Donya Quick
*/

class Agent {
  float x = 0;
  float y = 0;
  float xSpeed = 0;
  float ySpeed = 0;
  float maxSpeed = 10;
  float xAccel = 0;
  float yAccel = 0;
  float aSize = 0;
  float minSize = 20;
  float maxSize = 30;
  float r = 0;
  float g = 0;
  float b = 0;
  float attractorX = -1;
  float attractorY = -1;
  float repulsorX = -1;
  float repulsorY = -1;
  long minEmit = 100;
  long maxEmit = 3000;
  long nextEmit = round(random(minEmit, maxEmit));
  long emitDist = 100;
  long minJitterTime = 5000;
  long maxJitterTime = 10000;
  long nextJitterTime = round(random(minJitterTime, maxJitterTime));
  
  // midi
  MidiHandler mh;
  int chan = 0;
  int[] pitches = new int[]{0,2,3,5,7,8,  12,13,15,17,19,20, 24};
  int pOffset = 52;
  
  Agent(float r, float g, float b, float s) {
    this.r = r;
    this.g = g;
    this.b = b;
    this.aSize = s;
  }
  
  Agent() {
    xSpeed = random(-3,3);
    ySpeed = random(-3,3);
    xAccel = random(-1,1);
    yAccel = random(-1,1);
    aSize = random(minSize,maxSize);
    r = 0; //random(50,200);
    g = random(50,200);
    b = random(50,200);
  }
  
  void chirp(int vol) {
    int p = pOffset + pitches[floor(random(0,pitches.length))];
    mh.noteOn(chan, p, vol);
  }
  
  void setLocation(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void drawShape() {
    checkEmit();
    strokeWeight(1);
    stroke(r,g,b);
    fill(r,g,b);
    ellipse(x, y, aSize, aSize);
  }
  
  void updateColors() {
    g = max(min(g + random(-2,2),200),50);
    b = max(min(b + random(-2,2),200),50);
    r = 0;
  }
  
  void emit() {
    strokeWeight(5);
    float intensity = random(0.25,1.0);
    stroke(255*intensity);
    fill(0,0);
    ellipse(x,y,aSize*2,aSize*2);
    chirp(round(0.8*intensity*100));
  }
  
  void checkEmit() {
    if (millis() >= nextEmit) {
      nextEmit = nextEmit + round(random(minEmit, maxEmit));
      float dist = sqrt(pow(x-attractorX,2) + pow(y-attractorY,2));
      if (dist <= emitDist) {
        emit();
      }
    }
  }
  
  void jitterSpeed() {
    if (millis() > nextJitterTime) {
      float jx = random(10,15);
      float jy = random(10,15);
      if (random(0,1) > 0.5) {
        jx = -jx;
      }
      if (random(0,1) > 0.5) {
        jy = -jy;
      }
      xSpeed = xSpeed + jx;
      ySpeed = ySpeed + jy;
      nextJitterTime = nextJitterTime + round(random(minJitterTime,maxJitterTime));
      //println(millis() + " Jitter!");
    } 
    
    if (xSpeed < -5 && xAccel < 0) {
      xAccel = xAccel + 1;
    }else if (xSpeed > 5 && xAccel > 0) {
      xAccel = xAccel - 1;
    }
    if (ySpeed < -5 && yAccel < 0) {
      yAccel = yAccel + 1;
    }else if (ySpeed > 5 && yAccel > 0) {
      yAccel = yAccel - 1;
    }
  }
  
  void update() {
    updateColors();
    x = min(max(x + xSpeed,aSize),width-aSize);
    y = min(max(y + ySpeed,aSize),height-aSize);
    xSpeed = min(max(bounce(xSpeed + xAccel, x, aSize,width-aSize), -maxSpeed), maxSpeed);
    ySpeed = min(max(bounce(ySpeed + yAccel, y, aSize, height-aSize), -maxSpeed), maxSpeed);
    //xSpeed = min(max(xSpeed, -5),5);
    //ySpeed = min(max(ySpeed, -5),5);
    xAccel = min(max(xAccel + random(-0.5,0.5), -1), 1);
    yAccel = min(max(yAccel + random(-0.5,0.5), -1), 1);
    
    jitterSpeed();
    
    if (repulsorX >=0 && repulsorY >=0) {
      if (x < repulsorX && xAccel > 0 || x > repulsorX && xAccel < 0) {
        xAccel = xAccel * -1.2;  //- random(xAccel/2, xAccel);
      }
      if (y < repulsorY && yAccel > 0|| y > repulsorY && yAccel < 0) {
        yAccel = yAccel * -1.2; // - random(yAccel/2, yAccel);
      }
    } else if (attractorX >=0 && attractorY >=0) {
      if (x < attractorX && xAccel < 0 || x > attractorX && xAccel > 0) {
        xAccel = xAccel - random(xAccel/2, xAccel);
      }
      if (y < attractorY && yAccel < 0|| y > attractorY && yAccel > 0) {
        yAccel = yAccel - random(yAccel/2, yAccel);
      }
    }
    
    aSize = min(max(aSize + random(-1,1), minSize), maxSize);
  }
  
  void setFree() {
    attractorX = -1;
    attractorY = -1;
    repulsorX = -1;
    repulsorY = -1;
  }
  
  void setAttractor(float x, float y) {
    attractorX = x;
    attractorY = y;
    repulsorX = -1;
    repulsorY = -1;
  } 
  
  void setRepulsor(float x, float y) {
    attractorX = -1;
    attractorY = -1;
    repulsorX = x;
    repulsorY = y;
  }
  
  float bounce(float speed, float x, float lower, float upper) {
    if (x <= lower && speed < 0 || x >=upper && speed > 0) {
      return -speed;
    } else {
      return speed;
    }
  }
  
}