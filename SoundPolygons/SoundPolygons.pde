import java.util.ArrayList; // for lists of MIDI devices
import java.util.List; // for lists of MIDI devices
import java.util.Vector; // for storing listeners
import javax.sound.midi.*;// for working with MIDI

int numSquares = 150;
float[] xs = new float[numSquares];
float[] ys = new float[numSquares];
float[] thetas = new float[numSquares];
float[] tSpeeds = new float[numSquares];
float[] rs = new float[numSquares];
int[] numSides = new int[numSquares];
float[] sizes = new float[numSquares];
float[] energy = new float[numSquares];
float[] xSpeeds = new float[numSquares];
float[] ySpeeds = new float[numSquares];
float energyDecay = -2;
float padding = 100;
float minSize = 30;
float maxSize = 60;
long minTime = 1000;
long maxTime = 3000;
long nextTime = minTime;
long pauseTime = 8000;
float minSpeed = -3;
float maxSpeed = 3;
int playLimit = 8;
int maxPlayed = 10;
int minPlayed = 6;
int currPlayed = 0;
int minVol = 50;
int maxVol = 120;

int[] pitchClasses = new int[]{2, 4, 6, 9, 11, 14}; // D major pentatonic
int[] octaves = new int[]{5,6};
MidiDevice outDev;
int outDevNum = 2;
int channel = 0;
boolean channelRotation = false;

void setup() {
  size(800,600);
  blendMode(DIFFERENCE);
  setupMidi();
  minSize = min(width,height) * 0.05;
  maxSize = min(width,height) * 0.1;
  for (int i=0; i<numSquares; i++) {
    xs[i] = random(padding, width-padding);
    ys[i] = random(padding, height-padding);
    thetas[i] = 0;
    tSpeeds[i] = random(-0.05, 0.05);
    rs[i] = random(50,250);
    numSides[i] = floor(random(3,3+pitchClasses.length));
    sizes[i] = random(20,60);
    energy[i] = 0;
    xSpeeds[i] = random(minSpeed, maxSpeed);
    ySpeeds[i] = random(minSpeed, maxSpeed);
  }
}

void draw() {
  if (millis() >= nextTime) {
    currPlayed++;
    int i = round(random(0,numSquares-1));
    energy[i] = 255;
    nextTime = nextTime + round(random(minTime, maxTime));
    int pitch = pitchClasses[numSides[i]-3] + 12*octaves[floor(random(0,octaves.length))];
    int volume = floor(((sizes[i]-minSize) / (maxSize - minSize)) * (maxVol-minVol) + minVol);
    MidiUtils.noteOn(outDev, channel, pitch, volume);
    if (channelRotation) {
      channel++;
      if (channel >= 9) {
        channel = 0;
      }
    }
    if (currPlayed >= playLimit) {
      currPlayed = 0;
      playLimit = round(random(minPlayed, maxPlayed));
      nextTime = nextTime + pauseTime;
    }
  }
  background(20,0,0);
  for (int i=0; i<numSquares; i++) {
    fill(cap(rs[i]+energy[i], 0, 255),energy[i],energy[i]);
    stroke(0,0);
    pushMatrix();
    translate(xs[i], ys[i]);
    rotate(thetas[i]);
    //rectMode(CENTER);
    //rect(0, 0, squareSize, squareSize);
    polygon(0,0, sizes[i], numSides[i]);
    popMatrix();
    thetas[i] = thetas[i] + tSpeeds[i];
    rs[i] = cap(rs[i]+random(-2,2), 20,255);
    jitter(i);
    if (energy[i] > 0) {
      energy[i] = energy[i]+energyDecay;
    }
  }
  textSize(20);
  fill(100,0,0);
  text("Sound Polygons - Donya Quick", 20, height-20);
}

float cap(float val, float min, float max) {
  float newVal = val;
  if (newVal > max) {
    newVal = max;
  } else if (newVal < min) {
    newVal = min;
  }
  return newVal;
}


void jitter(int i) {
  xs[i] = xs[i]+ xSpeeds[i];
  ys[i] = ys[i] + ySpeeds[i];
  xSpeeds[i] = cap (xSpeeds[i] + random(-0.1,0.1), minSpeed, maxSpeed);
  ySpeeds[i] = cap (ySpeeds[i] + random(-0.1,0.1), minSpeed, maxSpeed);
  sizes[i] = cap(sizes[i] + random(-0.5,0.5), minSize, maxSize);
  tSpeeds[i] = cap(tSpeeds[i] + random(-0.0002, 0.0002), -0.05, 0.05);
  handleCollisions(i);
}


void polygon(float x, float y, float radius, int n) {
  float angle = TWO_PI / n;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}


void handleCollisions(int i) {
  if (xs[i] >= width-padding || xs[i] <= padding) {
    xSpeeds[i] = -xSpeeds[i];
  }
  if (ys[i] >= height-padding || ys[i] <= padding) {
    ySpeeds[i] = -ySpeeds[i];
  }
}


void exit() {
   println("Stopping...");
   outDev.close(); 
   println("Done.");
   super.exit();
}



public void setupMidi() { 
  try {
    List<MidiDevice> outDevs = MidiUtils.getOutputDevices();
    outDev = outDevs.get(outDevNum);
    println(outDev.getDeviceInfo().getName());
    outDev.open();
  } 
  catch (Exception e) {
    println(e.getMessage());
  }
}