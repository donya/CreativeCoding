/*
Abstract Sound IV
Donya Quick
*/

Agent[] agents;
float fadeTrans = 5; // transparency to use for fade
int jitterDist = 8;
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
boolean playMusic = true;
long playTime = 10000;
long downTime = 10000;
long nextTime = playTime;


void setup() {
  size(1000,800);
  //size(3800,2140);
  //size(3840,2160);
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
  if (millis() > nextTime) {
    if (playMusic) {
      nextTime = nextTime + downTime;
    } else {
      nextTime = nextTime + playTime;
    }
    playMusic = !playMusic;
  }
  jitter();
  fade();
  for (int i = 0; i<agents.length; i++) {
    agents[i].drawAgent(playMusic);
  }
  if (counter >= countMax) { // time to switch schemes?
    doErode = !doErode;
    counter = 0;
    countMax = round(random(100,1000));
  }
  counter++;
}

void fade() {
  fill(0,fadeTrans);
  stroke(0,fadeTrans);
  rect(-5,-5,width+5,height+5);
}

void jitter() {
  for (int i=0; i<width*20; i++) {
    float x = random(jitterDist,width-jitterDist);
    float y = random(jitterDist,height-jitterDist);
    float xN = random(x-jitterDist,x+jitterDist);
    float yN = random(y-jitterDist,y+jitterDist);
    color c = get(round(xN),round(yN));
    set(round(x), round(y), c);
  }
}