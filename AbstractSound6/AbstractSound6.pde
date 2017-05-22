/*
Abstract Sound VI 
Donya Quick
*/

int numCircles = 20;
int numLights = 5;
int numReps = 3;
int[] repPitches = new int[]{40+24, 47+24, 52+24}; // MUST MATCH numReps SIZE
int[] lightPitches = new int[]{40, 43, 45, 47, 52}; // MUST MATCH numLights SIZE
Agent[] agents = new Agent[numCircles];
Attractor[] lights = new Attractor[numLights];
Repulsor[] reps = new Repulsor[numReps];
float padding = 200;
float jitterDist = 5;
int particleSize = 2;

// sound
MidiHandler mh;

void setup() {
  size(1000,1000);
  mh = new MidiHandler();
  mh.initialize(0);
  mh.programChange(0,0);
  mh.programChange(1,1);
  mh.programChange(2,2);
  
  background(0);
  stroke(5,0,0);
  for (int i=0; i<numCircles; i++) {
    agents[i] = new Agent();
    agents[i].setLocation(width/2, height/2);
    agents[i].mh = mh;
    agents[i].chan = 0;
  }
  for (int i=0; i<numLights; i++) {
    lights[i] = new Attractor();
    lights[i].setLocation(random(padding, width-padding), random(padding, height-padding));
    lights[i].mh = mh;
    lights[i].chan = 1;
    lights[i].pitch = lightPitches[i];
  }
  for (int i=0; i<numReps; i++) {
    reps[i] = new Repulsor();
    reps[i].setLocation(random(padding, width-padding), random(padding, height-padding));
    reps[i].mh = mh;
    reps[i].chan = 2;
    reps[i].pitch = repPitches[i];
  }
}

void draw() {
  //background(0);
  // jitter
  for (int i=0; i<lights.length; i++) {
    jitterArea(lights[i].x-200, lights[i].x+200, lights[i].y-200, lights[i].y+200);
  }
  for (int i=0; i<agents.length; i++) {
    jitterArea(agents[i].x-200, agents[i].x+200, agents[i].y-200, agents[i].y+200);
  }
  for (int i=0; i<reps.length; i++) {
    jitterArea(reps[i].x-200, reps[i].x+200, reps[i].y-200, reps[i].y+200);
  }
  
  fill(0,30);
  rect(-5,-5,width+5,height+5);
  //jitter();
  for (int i=0; i<reps.length; i++) {
    reps[i].drawShape();
    reps[i].update();
  }
  for (int i=0; i<lights.length; i++) {
    lights[i].drawShape();
    lights[i].update();
  }
  for (int i=0; i<agents.length; i++) {
    agents[i].drawShape();
    agents[i].update();
  }
  assignAttractors();
}

void assignAttractors() {
  for (int i=0; i<reps.length; i++) {
    boolean found = false;
    float dist = max(width,height);
    for (int k=0; k<lights.length; k++) {
      if (lights[k].isOn) {
        float xDist = lights[k].x - reps[i].x;
        float yDist = lights[k].y - reps[i].y;
        float tDist = sqrt(xDist * xDist + yDist * yDist);
        if (tDist < dist) {
          found = true;
          dist = tDist;
          reps[i].setAttractor(lights[k].x, lights[k].y);
          //println(millis() + " found");
        }
      }
    }
    
    if (!found) {
      reps[i].setFree();
    }
  }
  for (int i=0; i<agents.length; i++) {
    boolean found = false;
    float dist = max(width,height);
    for (int j=0; j<reps.length; j++) {
      if (reps[j].isOn) {
        float xDist = reps[j].x - agents[i].x;
        float yDist = reps[j].y - agents[i].y;
        float tDist = sqrt(xDist * xDist + yDist * yDist);
        if (tDist < dist) {
          found = true;
          dist = tDist;
          agents[i].setRepulsor(reps[j].x, reps[j].y);
        }
      }
    }
    if (!found) {
      dist = max(width,height);
      for (int k=0; k<lights.length; k++) {
        if (lights[k].isOn) {
          float xDist = lights[k].x - agents[i].x;
          float yDist = lights[k].y - agents[i].y;
          float tDist = sqrt(xDist * xDist + yDist * yDist);
          if (tDist < dist) {
            found = true;
            dist = tDist;
            agents[i].setAttractor(lights[k].x, lights[k].y);
            //println(millis() + " found");
          }
        }
      }
    }
    if (!found) {
      agents[i].setFree();
    }
  }
}

void jitter() {
  for (int i=0; i<width*20; i = i + particleSize) {
    float x = random(jitterDist,width-jitterDist);
    float y = random(jitterDist,height-jitterDist);
    float xN = random(x-jitterDist,x+jitterDist);
    float yN = random(y-jitterDist,y+jitterDist);
    color c = get(round(xN),round(yN));
    //set(round(x), round(y), c);
    stroke(c);
    fill(c);
    rect(x,y,particleSize, particleSize);
  }
}

void jitterArea(float x1, float x2, float y1, float y2) {
  int factor = round(x2-x1);
  for (int i=0; i<factor; i = i + particleSize) {
    float x = random(x1,x2);
    float y = random(y1,y2);
    float xN = random(x-jitterDist,x+jitterDist);
    float yN = random(y-jitterDist,y+jitterDist);
    color c = get(round(xN),round(yN));
    //set(round(x), round(y), c);
    stroke(c);
    fill(c);
    rect(x,y,particleSize, particleSize);
  }
}