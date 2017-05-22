/*
Abstract Sound 4 agent
*/

class Agent {
  // MIDI values
  int chan = 0;
  int minV = 30;
  int maxV = 80;
  int minP = 30;
  int maxP = 105;
  MidiHandler mh;
  int[] pitches = new int[]{33, 35, 36, 38, 40, 41, 43, 45, 47,48,50,52,53,55, 57,59,60,62,64,65,67, 69,71,72,74,76,77,79, 81,83,84,86,88,89,91};
  
  // agent color, speed, & position variables
  float fadeFactor = 0.3;
  float r = random(0,255);
  float g = random(0,255);
  float b = random(0,255);
  float deltaR = random(2,10);
  float deltaG = random(2,10);
  float deltaB = random(2,10);
  float x = 0;
  float y = 0;
  float xSpeed = random(-20,20);
  float ySpeed = random(-20,20);
  float maxLineVal = 30;
  float minLineVal = 20;
  float minCircleSize = 10;
  float maxCircleSize = 127;
  
  // circle variables
  float cR = 0;
  float cG = 0;
  float cB = 0;
  float cWeight = 0;
  float cX = -200;
  float cY = -200;
  float cSize = 0;
  float energy = 0;
  float deltaEnergy = 2;
  
  // timing variables
  float minTriggerTime = 1000; // 1 second
  float maxTriggerTime = 25000; // 15 seconds
  long nextTriggerTime = round(random(minTriggerTime, maxTriggerTime));
  boolean triggered = false;
  
  
  Agent(MidiHandler mh) {
    this.mh = mh;
    x = random(0,width);
    y = random(0,height);
    xSpeed = random(-width*0.02, width*0.02);
    ySpeed = random(-width*0.02, width*0.02);
    maxLineVal = width * 0.03;
    minLineVal = width * 0.02;
    minCircleSize = width * 0.02;
    maxCircleSize = width * 0.127;
  }
  
  void reflect() {
    if ((x <= 0 && xSpeed<0) || (x >= width && xSpeed > 0)) {
      xSpeed = -xSpeed;
    }
    if ((y <= 0 && ySpeed < 0) || (y >= height && ySpeed > 0)) {
      ySpeed = -ySpeed;
    }
  }
  
  void drawAgent() {
    drawAgent(true);
  }
  
  void drawAgent(boolean active) {
    if (!active) {
      triggered = false;
    }
    // move the agent
    float newX = cap(0, width, x+xSpeed);
    float newY = cap(0, height, y+ySpeed);
    reflect();
    float amtMovedY = abs(newY - y);
    float amtMovedX = abs(newX - x);
    xSpeed = cap(-20,20,xSpeed + random(-20,20));
    ySpeed = cap(-20,20,ySpeed + random(-20,20));
    
    // draw the agent
    float lineWidth = maxLineVal-max(0, min(amtMovedY, minLineVal));
    strokeWeight(lineWidth);
    if (active && triggered) {
      stroke(r,g,b);
    } else {
      stroke(r*fadeFactor,g*fadeFactor,b*fadeFactor);
    }
    line(x, y, newX, newY);
    if (amtMovedY > 0 || amtMovedX > 0){
      updateRGB();
    }
    
    // store updated position
    x = newX;
    y = newY;
    
    energy = cap(0,255,energy+deltaEnergy);
    
    // should the agent make a noise?
    if (millis() >= nextTriggerTime) {
      if (active) {
        triggered = true;
        energy = 0;
        cSize = random(minCircleSize,maxCircleSize);
        cX = x;
        cY = y;
        cR = r;
        cG = g;
        cB = b;
        cWeight = lineWidth;
        playSound();
      }
      nextTriggerTime = nextTriggerTime + round(random(minTriggerTime, maxTriggerTime));
    }
    
    if (active && triggered) {
      fill(255, energy);
      stroke(cR,cG,cB);
      strokeWeight(cWeight);
      ellipse(cX,cY,cSize,cSize);
    }
  }
  
  // generates a MIDI note relative to position on screen
  void playSound() {
    float dist = 1 - (y/ height);
    int p = pitches[round(dist * (pitches.length-1))];
    int v = round(random(50,120)); // minV + round((maxV-minV) * x / width);
    cSize = 200*(v-30)/100;
    mh.noteOn(chan, p, v);
    deltaEnergy = 30.2 - 30*(1.0 - (((float)p - 33)/58));
  }
  
  // update the color so it changes gradually
  void updateRGB(){
    r = r+deltaR;
    if(r>255 || r < 0){
      deltaR = -deltaR;
    }
    
    g = g+deltaG;
    if(g>255 || g < 0){
      deltaG = -deltaG;
    }
    
    b = b+deltaB;
    if(b>255 || b < 0){
      deltaB = -deltaB;
    }
  }
  
  // utility function
  float cap(float lower, float upper, float val) {
    if (val < lower) {
      return lower;
    } else if (val > upper) {
      return upper;
    } else {
      return val;
    }
  }
}