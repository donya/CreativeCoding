/*
Abstract Sound II
Donya Quick
*/

MidiHandler mh;
int volMin = 30;
int volMax = 80;

int numShapes = 10;
ArrayList<RandomShape> shapes = new ArrayList<RandomShape>();
int numFiles = 10;
float slow = 70; 
float med = 180; 
float fast = 253;
int[] pcs = new int[]{2,4,5,7,9,11,12,14};
int[] octs = new int[]{3,4,5}; 
int[] pitches;
float[] opacities = new float[]{fast, fast, med, med, med, med, slow, slow, slow, slow};
float currOpacity = 0;
boolean allowFade = true;
boolean invert = false;

long tMin = 2000; // minimum time to update
long tMax = 8000; // maximum time to update
long timeToNextUpdate = 0;
boolean ok = true; // update status
PFont tnrFont;
long nextFlip = 3000;
long flipDelay = 3000;
long tConst = 8000;
float lambda = 4.0;

void setup() {
  frameRate(15);
  tnrFont = createFont("TimesNewRoman.ttf",20);
  size(800, 600);
  background(0);
  // initialize shapes
  for (int i = 0; i< numShapes; i++) {
    shapes.add(new RandomShape());
    shapes.get(i).randomize();
  }
  buildPitches();
  mh = new MidiHandler();
  mh.initialize(1);
  mh.programChange(0,0); // set the instrument
}

void buildPitches() {
  pitches = new int[pcs.length * octs.length];
  int n = 0;
  for (int i=0; i<octs.length; i++) {
    for (int j=0; j<pcs.length; j++) {
      pitches[n] = pcs[j] + 12*octs[i];
      n++;
    }
  }
}

void border() {
 noStroke();
 fill(10,10,10);
 rect(-1,-1,width+1,5);
 rect(-1,-1,5,height+5);
 rect(-1,height+1,width+1,height-5);
 rect(width-5,-1, width+1,height+1);
}

void draw() { 
  if (millis() > nextFlip) {
    nextFlip = nextFlip + round(random(1000,flipDelay));
    invert = !invert;
  }
  if (millis() > timeToNextUpdate) {
    //ok = triggerRandomPlayer();
    if (!allowFade) {
      currOpacity=255;
    }
    // only update if an audio player is free
    if (ok) {
      // choose a random index to start updating from (1 to 4 shapes)
      int current = floor(random(1, 5));
      // update everything from that index to the end
      while (current >= 0) {
        currOpacity = opacities[round(random(0, opacities.length-1))];
        RandomShape x = shapes.get(current);
        x.randomize(currOpacity); // draw a new shape
        x.invert = invert;
        shapes.remove(current); // pop out of the list
        shapes.add(x); // place back on the end
        current--;
        shapeTone(x.w, x.h);
      }
    }
    
    //background(255);
    double t = round(tConst*log(random(0,1.0))/ (-lambda));
    timeToNextUpdate = timeToNextUpdate + (long)t; // round(random(tMin, tMax));
  }
  // draw all shapes
  for (int i = 0; i< numShapes; i++) {
    shapes.get(i).drawPoly();
  } 
  filter(ERODE);
  drawText();
}

boolean shapeTone(float w, float h) {
  int n = pitches.length;
  float x = n * 1.2 * ((w / (width/2)) - 0.2);
  int p = pitches[floor(max(0, min(n-1, x)))];
  int v = max(volMin, min(volMax, floor(volMax * (2 * h / height))));
  mh.noteOn(0,p,v);
  return true;
}

void drawText() {
  fill(0);
  stroke(0,0);
  rect(0,height-50,400,50);
  fill(255);
  textSize(20);
  textFont(tnrFont);
  text("Abstract Sound II - Donya Quick", 20, height-20);
}