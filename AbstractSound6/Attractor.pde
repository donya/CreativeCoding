/*
Attractor class for Abstract Sound 6
Donya Quick
*/

class Attractor {
  float x = 0;
  float y = 0;
  float xSpeed = 0;
  float ySpeed = 0;
  float aSize = 0;
  float r = 0;
  float g = 0;
  float b = 0;
  
  // midi
  MidiHandler mh;
  int chan = 1;
  int pitch = 60;
  int vol = 80;
  
  // illumination stuff
  float fadeRate = 0.02;
  float minEnergy = 0.1;
  float energy = minEnergy;
  boolean isOn = false;
  long minOn = 2000;
  long maxOn = 7000;
  long minTrigger = 1000;
  long maxTrigger = 10000;
  long nextTrigger = round(random(minTrigger, maxTrigger));
  
  Attractor() {
    xSpeed = random(-1,1);
    ySpeed = random(-1,1);
    aSize = 100;
    r = random(180,255);
    g = random(180,255);
    b = 0; //random(180,255);
  }
  
  void drawShape() {
    strokeWeight(1);
    stroke(r*energy,g*energy,b*energy);
    fill(r*energy,g*energy,b*energy);
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
    g = max(min(g + random(-2,2),255),180);
    b = 0;
  }
  
  void update() {
    updateColors();
    x = x + xSpeed;
    y = y + ySpeed;
    if (x <= aSize/2 || x >= width-aSize/2) {
      xSpeed = -xSpeed;
    } 
    if (y <= aSize/2 || y >= height-aSize/2) {
      ySpeed = -ySpeed;
    }
    if (millis() > nextTrigger) {
      if (!isOn) {
        nextTrigger = nextTrigger + round(random(minOn, maxOn));
        isOn = true;
        mh.noteOn(chan, pitch, vol);
      } else {
        nextTrigger = nextTrigger + round(random(minTrigger, maxTrigger));
        isOn = false;
        mh.noteOff(chan, pitch, vol);
      }
    }
  }
}