/*
Abstract Sound 3 agent
*/

class Agent {
  // MIDI values
  int chan = 0;
  int minV = 30;
  int maxV = 80;
  int minP = 30;
  int maxP = 105;
  MidiHandler mh;
  
  // agent color, speed, & position variables
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
  
  // timing variables
  float minTriggerTime = 1000; // 1 second
  float maxTriggerTime = 15000; // 15 seconds
  long nextTriggerTime = round(random(minTriggerTime, maxTriggerTime));
  
  
  Agent(MidiHandler mh) {
    this.mh = mh;
    x = random(0,width);
    y = random(0,height);
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
    stroke(r,g,b);
    line(x, y, newX, newY);
    if (amtMovedY > 0 || amtMovedX > 0){
      updateRGB();
    }
    
    // store updated position
    x = newX;
    y = newY;
    
    // should the agent make a noise?
    if (millis() >= nextTriggerTime) {
      float d = random(minCircleSize,maxCircleSize);
      fill(255);
      ellipse(x,y,d,d);
      playSound();
      nextTriggerTime = nextTriggerTime + round(random(minTriggerTime, maxTriggerTime));
    }
  }
  
  // generates a MIDI note relative to position on screen
  void playSound() {
    int p = minP + round((maxP-minP) * (1-(y / height)));
    int v = minV + round((maxV-minV) * x / width);
    mh.noteOn(chan, p, v);
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