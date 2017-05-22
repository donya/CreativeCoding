/*
Something Kind of Like Asteroids
Donya Quick
*/

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();
long defMin = 500;
long defMax = 2000;
long minSpawnTime = defMin;
long maxSpawnTime = defMax;
float rateFactor = 1.0;
long nextSpawnTime = round(random(minSpawnTime, maxSpawnTime));
float mSize = 30;
boolean lost = false;
int survived = 0;
int highScore = 0;
boolean canFire = false;
String title = "Something Kindofsortofmaybe Like Asteroids by Donya Quick";
int currFrames = 0;
int framesToFire = 50;
int maxCoolDown = 200;
int coolDown = 200;
boolean gen = false;
boolean started = false;

Minim minim;
AudioPlayer pFire;
AudioPlayer pLose;

void setup() {
  frameRate(60);
  size(500, 500);
  minim = new Minim(this);
  pFire = minim.loadFile("fire.wav");
  pLose = minim.loadFile("lose.wav");
}

void draw() {
  if (started) { // is the game running yet?
    // check cooldown
    coolDown = max(coolDown-1, 0);
    if (currFrames >= framesToFire && coolDown <=0) { 
      canFire = true; 
      currFrames = 0;
    } 
    
    // background trick to allow fading trails
    currFrames++; 
    noStroke(); 
    fill(0, 50); 
    rect(-5, -5, width+5, height+5); 
    
    // check whether to play loss sound
    boolean lastLost = lost;
    lost = gotHit(); 
    if (lost && !lastLost) {
      pLose.rewind();
      pLose.play();
    }
    
    // spawn another asteroid?
    if (millis() > nextSpawnTime) {
      long lower = round(minSpawnTime * rateFactor);
      long upper = round(maxSpawnTime * rateFactor);
      nextSpawnTime = nextSpawnTime + round(random(lower, upper));
      if (gen) {
        asteroids.add(new Asteroid());
        rateFactor = rateFactor * 0.95;
        if (rateFactor < 0.05) { 
          rateFactor = 1.0;
        }
      }
    } 
    
    // update everything
    for (int i=asteroids.size()-1; i>=0; i--) {
      asteroids.get(i).move();
      asteroids.get(i).drawShape();
      if (!asteroids.get(i).alive) {
        asteroids.remove(i);
        if (coolDown <=0 && gen) {
          survived++;
        }
      }
    }

    // show where the cursor really is with a dark red "x"
    stroke(255, 0, 0, 50);
    strokeWeight(1);
    line(mouseX-5, mouseY-5, mouseX+5, mouseY+5);
    line(mouseX+5, mouseY-5, mouseX-5, mouseY+5);

    // draw the "spaceship"
    strokeWeight(2);
    stroke(255, 0, 0);
    if (lost) {  
      fill(255, 0, 0);
      highScore = max(highScore, survived);
      survived = 0;
      minSpawnTime = defMin;
      maxSpawnTime = defMax;
      gen = false;
    } else {
      fill(255);
    }
    ellipse(width/2, mouseY, mSize, mSize);

    // score text
    fill(255);
    textSize(15);
    text(title+"\nScore: "+survived+"\nHigh score: "+highScore, 10, 30);

    // get ready text
    if (!gen || lost || asteroids.size() <= 0) {
      textSize(50);
      text("Get ready!", width/2-100, height/2-50);
    }

    // increase or reset rate
    if (asteroids.size() <= 0) {
      lost = false;
      gen = true;
      rateFactor = 1.0;
    }
  } else {
    background(0);
    fill(255);
    textSize(15);
    text(title+"\nScore: "+survived+"\nHigh score: "+highScore, 10, 30);
    textSize(40);
    text("Click to start game.", width/2-200, height/2-50);
  }
}

// fire if it's allowed
void mousePressed() {
  if (started) {
    if (coolDown <= 0) { 
      if (canFire) { 
        pFire.rewind();
        pFire.play();
        strokeWeight(5); 
        stroke(255, 0, 0); 
        line(width/2+mSize, mouseY, mouseX+width, mouseY); 
        canFire = false; 
        for (int i=asteroids.size()-1; i>=0; i--) {
          if (asteroids.get(i).isHit(width/2, mouseY)) {
            Asteroid ax = asteroids.get(i);
            Asteroid a1 = new Asteroid();
            Asteroid a2 = new Asteroid();
            float ys1 = random(1, 5);
            float ys2 = random(-1, -5);
            a1.setSplit(ax.x, ax.y, ax.aSize/2, ax.xSpeed, ys1);
            a2.setSplit(ax.x, ax.y, ax.aSize/2, ax.xSpeed, ys2);
            asteroids.add(a1);
            asteroids.add(a2);
            asteroids.remove(i);
          }
        }
      }
    }
  } else {
    started = true;
    noCursor();
    nextSpawnTime = millis() + 2000;
  }
}

// detect loss (collision)
boolean gotHit() {
  boolean hit = false;
  for (int i=0; i<asteroids.size(); i++) {
    float xDist = width/2 - asteroids.get(i).x;
    float yDist = mouseY - asteroids.get(i).y;
    float dist = sqrt(xDist * xDist + yDist * yDist);
    if (dist <= (mSize + asteroids.get(i).aSize)/2) {
      hit = true;
    }
  }
  return hit;
}