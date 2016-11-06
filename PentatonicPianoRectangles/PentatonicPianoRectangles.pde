String title = "Pentatonic Piano Rectangles - Donya Quick";
int outDevNum = 0; // change this to use a custom synthesizer
int numButtons = 40;
int pitchRoot = 48;
float[] xs = new float[numButtons];
float[] ys = new float[numButtons];
float[] ws = new float[numButtons];
float[] hs = new float[numButtons];
color[] colors = new color[numButtons];
int[] scaleInds = new int[numButtons];
MidiHandler mh = new MidiHandler();
float padding = 100;
float minSize = 20;
float maxSize = 120;
float energy = 0;
boolean grow = false;
long nextRefreshTime = 15000;
long refreshInterval = 15000;
int tSize = 20;

int numAgents = 3;
float[] ax = new float[numAgents];
float[] ay = new float[numAgents];
float aSize = 10;
float[] axSpeed = new float[numAgents];
float[] aySpeed = new float[numAgents];
float minSpeed = 0;
float maxSpeed = 0;
long[] aTriggerTime = new long[numAgents];
long aMinTime = 2000;
long aMaxTime = 5000;
float[] aEnergy = new float[numAgents];
float aMaxEnergy = 0;

int[] cPentaScale = new int[]{0, 0, 0, 2, 4, 4, 4, 7, 7, 7, 9, 9};


void setup() {
  size(800,600);
  for (int i=0; i<numAgents; i++) {
    ax[i] = width/2;
    ay[i] = height/2;
    aEnergy[i] = 0;
    aTriggerTime[i] = round(random(aMinTime, aMaxTime));
  }
  minSize = width/40;
  maxSize = width/6;
  padding = width/8;
  tSize = width/50;
  minSpeed = width/266;
  maxSpeed = width/240;
  aSize = width/100;
  aMaxEnergy = aSize*3;
  mh.initialize(outDevNum);
  buildSquares();
  //noCursor();
}

void drawAgent(int i) {
  if (aEnergy[i]>0) {
    fill(0,0,255,50);
  } else {
  fill(255,100);
  }
  ellipse(ax[i], ay[i], aSize+aEnergy[i],aSize+aEnergy[i]);
}

void updateAgent(int i) {
  int j = 0;
  boolean triggered = false;
  while (j<numButtons && !triggered) {
    if(mouseWithinRect2(ax[i], ay[i], xs[j], ys[j], ws[j], hs[j])) {
      triggered = true;
    }
    j = j+1;
  }
  if (millis() >= aTriggerTime[i] && triggered) {
    aEnergy[i] = aMaxEnergy;
    aTriggerTime[i] = aTriggerTime[i] + round(random(aMinTime, aMaxTime));
    agentTrigger(i);
  }
  ax[i] = ax[i] + axSpeed[i];
  ay[i] = ay[i] + aySpeed[i];
  axSpeed[i] = cap(axSpeed[i]+random(-1,1), -maxSpeed, maxSpeed);
  aySpeed[i] = cap(aySpeed[i]+random(-1,1), -maxSpeed, maxSpeed);
  
  if (ax[i] < padding && axSpeed[i]<0) {
    axSpeed[i] = - axSpeed[i];
  }else if (ax[i] > width-padding && axSpeed[i] > 0) {
    axSpeed[i] = -axSpeed[i];
  }
  
  if (ay[i] < padding && aySpeed[i] < 0) {
    aySpeed[i] = -aySpeed[i];
  } else if(ay[i] > height - padding && aySpeed[i] > 0) {
    aySpeed[i] = -aySpeed[i];
  }
  if (aEnergy[i] > 0) {
    aEnergy[i] = aEnergy[i] - aSize/5;
  }
}

void draw() {
  if (millis() >= nextRefreshTime) {
    nextRefreshTime = nextRefreshTime + refreshInterval;
    grow = true;
  }
  if (grow && energy==255) {
    buildSquares();
    grow = false;
  }
  background(0);
  drawSquares();
  for (int i=0; i<numAgents; i++) {
    updateAgent(i);
    drawAgent(i);
  }
  /*
  if (mousePressed) {
    fill(0,0,255,50);
    ellipse(mouseX, mouseY, 20,20);
  } else {
  fill(255,100);
    ellipse(mouseX, mouseY, 10,10);
    */

  fill(0,energy);
  rect(-5,-5,width+5,height+5);
  if (grow) {
    energy = energy+5;
  } else if (energy > 0) {
    energy = energy-5;
  }
  fill(255,100);
  textSize(tSize);
  text(title, 30, height-30);
}


void agentTrigger(int i) {
  for (int j=0; j<numButtons; j++) {
    if (mouseWithinRect2(ax[i], ay[i], xs[j], ys[j], ws[j], hs[j])) {
      mh.noteOn(pitchRoot+intToScalePitch(cPentaScale, scaleInds[j]));
    }
  }
}

void mousePressed() {
  for (int i=0; i<numButtons; i++) {
    if (mouseWithinRect(xs[i], ys[i], ws[i], hs[i])) {
      mh.noteOn(pitchRoot+intToScalePitch(cPentaScale, scaleInds[i]));
    }
  }
}

void mouseReleased() {
  for (int i=0; i<numButtons; i++) {
    if (mouseWithinRect(xs[i], ys[i], ws[i], hs[i])){
      mh.noteOff(pitchRoot+intToScalePitch(cPentaScale, scaleInds[i]));
    }
  }
}

void buildSquares() {
  for (int i=0; i<numButtons; i++) {
    ws[i] = random(minSize, maxSize);
    hs[i] = random(minSize, maxSize);
    xs[i] = random(0+padding, width-padding-ws[i]);
    ys[i] = random(0+padding, height-padding-hs[i]);
    colors[i] = color(random(50,100), random(50,100), random(50,100), 100);
    scaleInds[i] = i % scaleInds.length;
  }
}

void drawSquares() {
  for (int i=0; i<numButtons; i++) {
    fill(colors[i]);
    stroke(colors[i]);
    //if (mousePressed && mouseWithinRect(xs[i],ys[i],ws[i],hs[i])) {
    boolean isHit = false;
    int j=0;
    while (j < numAgents && !isHit) {
      if (mouseWithinRect2(ax[j], ay[j], xs[i], ys[i], ws[i], hs[i]) && aEnergy[j]>0) {
        isHit = true;
      }
      j = j + 1;
    }
    if(isHit) {
      stroke(255,255,255);
      fill(255,255,255);
    }
    rect(xs[i],ys[i], ws[i], hs[i]);
  }
}



boolean mouseWithinRect(float x, float y, float sWidth, float sHeight) {
  return mouseX >= x && mouseX <= x+sWidth && mouseY >= y && mouseY <= y+sHeight;
}


boolean mouseWithinRect2(float ax, float ay, float x, float y, float sWidth, float sHeight) {
  return ax >= x && ax <= x+sWidth && ay >= y && ay <= y+sHeight;
}


int intToScalePitch(int[] scale, int value) {
  // what is the octave?
  int pc = value % scale.length;
  // what is the pitch class?
  int oct = floor(value / scale.length);
  return oct*12 + scale[pc];
}

float cap(float val, float minVal, float maxVal) {
  float retVal = val;
  if (val < minVal) {
    retVal = minVal;
  } else if (val > maxVal) {
    retVal = maxVal;
  }
  return retVal;
}