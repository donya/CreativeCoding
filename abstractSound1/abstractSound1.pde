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
float x = 0;

float y = 0;
color c = color(random(0, 255), random(0, 255), random(0, 255));
int numShapes = 5;
ArrayList<RandomShape> shapes = new ArrayList<RandomShape>();
int numFiles = 10;
AudioPlayer[] players;

long tMin = 2000;
long tMax = 8000;
long timeToNextUpdate = 0;
boolean ok = true;
PFont tnrFont;

void setup() {
  tnrFont = createFont("TimesNewRoman.ttf",20);
  minim = new Minim(this);
  size(800, 600);
  background(0);
  for (int i = 0; i< numShapes; i++) {
    shapes.add(new RandomShape());
    shapes.get(i).randomize();
  }
  buildPlayers();
}


void draw() {
  if (millis() > timeToNextUpdate) {
    ok = triggerRandomPlayer();
    if (ok) {
      int n = shapes.size();
      int current = floor(random(1, 5));
      int j = 0;
      while (current >= 0) {
        RandomShape x = shapes.get(current);
        x.randomize();
        shapes.remove(current);
        shapes.add(x);
        current--;
      }
    }
    timeToNextUpdate = timeToNextUpdate + round(random(tMin, tMax));
  }
  for (int i = 0; i< numShapes; i++) {
    shapes.get(i).drawPoly();
  } 
  filter(BLUR, 1);
  drawText();
}

boolean triggerRandomPlayer() {
  int i = floor(random(0, players.length));
  if (players[i].isPlaying()) {
    i = 0;
    while (i<players.length) {
      if (!players[i].isPlaying()) {    
        players[i].rewind();
        players[i].play();
        return true;
      }
      i++;
    }
    return false;
  } else {
    players[i].rewind();
    players[i].play();
    return true;
  }
}

int[] randIntSet(int numInts, int lower, int upper) {
  int[] retVal = new int[numInts];
  for (int i = 0; i<numInts; i++) {
    retVal[i] = round(random(lower, upper-numInts+1));
    numInts--;
    lower = retVal[i];
  }
  return retVal;
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