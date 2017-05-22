/*
Attractor class for Abstract Sound 6
Donya Quick
*/

class Repulsor {
  float x = 0;
  float y = 0;
  float xSpeed = 0;
  float ySpeed = 0;
  float maxSpeed = 1;
  float aSize = 0;
  float xAccel = 0;
  float yAccel = 0;
  float r = 0;
  float g = 0;
  float b = 0;
  float attractorX = -1;
  float attractorY = -1;
  long minJitterTime = 5000;
  long maxJitterTime = 10000;
  long nextJitterTime = round(random(minJitterTime, maxJitterTime));
  
  // midi
  MidiHandler mh;
  int chan = 2;
  int pitch = 60;
  int vol = 120;
  
  // illumination stuff
  float fadeRate = 0.05;
  float minEnergy = 0.25;
  float energy = minEnergy;
  boolean isOn = false;
  float opacity = 0;
  long onTime = 500;
  long minTrigger = 10000;
  long maxTrigger = 20000;
  long nextTrigger = round(random(minTrigger, maxTrigger));
  
  // ring
  float ringSize = 5;
  float ringEnergy = 0;
  float ringGrowth = 8;
  float ringDecay = 8;
  float minDecay = 4;
  float maxDecay = 10;
  float ringWeight = 5;
  float bgDecay = 5;
  
  Repulsor() {
    xSpeed = random(-1,1);
    ySpeed = random(-1,1);
    aSize = 100;
    r = random(180,255);
    g = 0;
    b = 0; //random(180,255);
  }
  
  void triggerRing() {
    b = 255/2;
    g = 255/2;
    ringWeight=5;
    ringEnergy = 255;
    ringSize = aSize;
    ringDecay = random(minDecay, maxDecay);
  }
  
  void drawShape() {
    if (ringEnergy > 0) {
      fill(0,0);
      strokeWeight(ringWeight);
      stroke(ringEnergy);
      ellipse(x,y,ringSize, ringSize);
      ringSize = ringSize + ringGrowth;
      ringEnergy = ringEnergy - ringDecay;
      ringWeight = ringWeight + 1;
      b = b - bgDecay;
      g = g - bgDecay;
    }
    strokeWeight(0);
    if (isOn) {
      opacity = 255;
    } else {
      opacity = 0;
    }
    stroke(r*energy,g*energy,b*energy, max(opacity,15));
    fill(r*energy,g*energy,b*energy, max(opacity,15));
    ellipse(x, y, aSize, aSize);
  }
  
  void setLocation(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void updateColors() {
    if (isOn) {
      energy = min(max(energy+fadeRate, minEnergy),1.0);
    } else {
      energy = min(max(energy-fadeRate, minEnergy),1.0);
    }
    r = max(min(r + random(-2,2),255),180);
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
    
    if (xSpeed < -maxSpeed && xAccel < 0) {
      xAccel = xAccel + 1;
    }else if (xSpeed > maxSpeed && xAccel > 0) {
      xAccel = xAccel - 1;
    }
    if (ySpeed < -maxSpeed && yAccel < 0) {
      yAccel = yAccel + 1;
    }else if (ySpeed > maxSpeed && yAccel > 0) {
      yAccel = yAccel - 1;
    }
  }
  
  void update() {
    if (millis() > nextTrigger) {
      if (!isOn) {
        triggerRing();
        nextTrigger = nextTrigger + onTime;
        isOn = true;
        mh.noteOn(chan, pitch, vol);
      } else {
        nextTrigger = nextTrigger + round(random(minTrigger, maxTrigger));
        isOn = false;
        mh.noteOff(chan, pitch, vol);
      }
    }
    updateColors();
    x = min(max(x + xSpeed,aSize),width-aSize);
    y = min(max(y + ySpeed,aSize),height-aSize);
    xSpeed = max(min(bounce(xSpeed + xAccel, x, aSize,width-aSize), maxSpeed), -maxSpeed);
    ySpeed = max(min(bounce(ySpeed + yAccel, y, aSize, height-aSize), maxSpeed), -maxSpeed);
    //xSpeed = min(max(xSpeed, -5),5);
    //ySpeed = min(max(ySpeed, -5),5);
    xAccel = min(max(xAccel + random(-0.5,0.5), -1), 1);
    yAccel = min(max(yAccel + random(-0.5,0.5), -1), 1);
    
    jitterSpeed();
    
    if (attractorX >=0 && attractorY >=0) {
      if (x < attractorX && xAccel < 0 || x > attractorX && xAccel > 0) {
        xAccel = xAccel - random(xAccel/2, xAccel);
      }
      if (y < attractorY && yAccel < 0|| y > attractorY && yAccel > 0) {
        yAccel = yAccel - random(yAccel/2, yAccel);
      }
    }
    
    //aSize = min(max(aSize + random(-1,1), minSize), maxSize);
  }
  
  void setFree() {
    attractorX = -1;
    attractorY = -1;
  }
  
  void setAttractor(float x, float y) {
    attractorX = x;
    attractorY = y;
  } 
  
  float bounce(float speed, float x, float lower, float upper) {
    if (x <= lower && speed < 0 || x >=upper && speed > 0) {
      return -speed;
    } else {
      return speed;
    }
  }
}