/*
Abstract Sound III
Donya Quick
*/

Agent[] agents;
int numAgents = 20;
int frames = 15;
int counter = 0;
float choice = 0;
int countMax = round(random(100,500));
MidiHandler mh;
boolean doErode = true;
int fontSize = 20;
int textBoxWidth = fontSize * 18;
int textBoxHeight = round(fontSize * 2.5);


void setup() {
  size(1000,800);
  frameRate(frames);
  mh = new MidiHandler();
  mh.initialize();
  agents = new Agent[numAgents];
  for (int i = 0; i<agents.length; i++) {
    agents[i] = new Agent(mh);
  }
  background(0);
}

void draw() {
  for (int i = 0; i<agents.length; i++) {
    agents[i].drawAgent();
  }
  if (counter >= countMax) { // time to switch schemes?
    doErode = !doErode;
    counter = 0;
    countMax = round(random(100,1000));
  }
  if (doErode) {
    filter(ERODE);
  } else {
    filter(DILATE);
  }
  counter++;
}