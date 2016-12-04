/*
Abstract Sound I
 Donya Quick
 */

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim = new Minim(this);
int numShapes = 5;
ArrayList<RandomShape> shapes = new ArrayList<RandomShape>();
int numFiles = 10;
AudioPlayer[] players;
float slow = 0;
float med = 150;
float fast = 253;
float[] opacities = new float[]{fast, fast, slow, med, med, slow, med, slow, slow, med};
float currOpacity = 0;
boolean allowFade = true;

long tMin = 2000; // minimum time to update
long tMax = 8000; // maximum time to update
long timeToNextUpdate = 0;
boolean ok = true; // update status
PFont tnrFont;

void setup() {
  tnrFont = createFont("TimesNewRoman.ttf",20);
  minim = new Minim(this);
  size(800, 600);
  background(0);
  // initialize shapes
  for (int i = 0; i< numShapes; i++) {
    shapes.add(new RandomShape());
    shapes.get(i).randomize();
  }
  // load audio
  buildPlayers();
}


void draw() {
  // check update time
  if (millis() > timeToNextUpdate) {
    ok = triggerRandomPlayer();
    if (!allowFade) {
      currOpacity=255;
    }
    // only update if an audio player is free
    if (ok) {
      // choose a random index to start updating from (1 to 4 shapes)
      int current = floor(random(1, 5));
      // update everything from that index to the end
      while (current >= 0) {
        RandomShape x = shapes.get(current);
        x.randomize(currOpacity); // draw a new shape
        shapes.remove(current); // pop out of the list
        shapes.add(x); // place back on the end
        current--;
      }
    }
    timeToNextUpdate = timeToNextUpdate + round(random(tMin, tMax));
  }
  // draw all shapes
  for (int i = 0; i< numShapes; i++) {
    shapes.get(i).drawPoly();
  } 
  filter(BLUR, 1);
  drawText();
}

boolean triggerRandomPlayer() {
  // try to choose a random player
  int i = floor(random(0, players.length));
  
  // if that player is busy, search from the beginning
  if (players[i].isPlaying()) {
    i = 0;
    while (i<players.length) {
      if (!players[i].isPlaying()) {    
        players[i].rewind();
        players[i].play();
        currOpacity = opacities[i];
        return true;
      }
      i++;
    }
    return false;
  } else {
    players[i].rewind();
    players[i].play();
    currOpacity = opacities[i];
    return true;
  }
}

void buildPlayers() {
  players = new AudioPlayer[numFiles];
  for (int i=0; i<numFiles; i++) {
    String fname = "soundx"+(i+1)+".wav";
    players[i] = minim.loadFile(fname);
  }
}

void drawText() {
  fill(0);
  rect(0,height-50,400,50);
  fill(255);
  textSize(20);
  textFont(tnrFont);
  text("Abstract Sound I - Donya Quick", 20, height-20);
}