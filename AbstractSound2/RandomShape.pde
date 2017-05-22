/*
Abstract Sound I - RandomShape class
 Donya Quick
 */

class RandomShape {
  float x = 0;
  float y = 0;
  float minX = 0;
  float maxX = 0;
  float minY = 0;
  float maxY = 0;
  float radius;
  color c;
  int numVerts = 10;
  float[] xs = new float[numVerts];
  float[] ys = new float[numVerts];
  long timeInterval = 10000;
  long timeToNextUpdate = 0;
  float padding = 200;
  float lowerPadding = 250;
  float opacity=255;
  float opacityAdjustRate = 3;
  boolean invert = false;
  float lifeMin = 100;
  float lifeMax = 500;
  float life = lifeMax;
  float area = 0;
  float w = 0;
  float h = 0;

  void randomize() {
    life = random(lifeMin,lifeMax);
    padding = width/5;
    numVerts = round(15*log(random(0.0, 1.0))/(-2));//round(random(10,30));
    xs = new float[numVerts];
    ys = new float[numVerts];
    radius = random(width/10, width/4);
    x = random(padding, width-padding);
    y = random(padding, height-lowerPadding);
    if (random(0.0, 1.0) > 0.5) {
      c = color(random(0, 255), 0, 255);
    } else {
      c = color(0, random(0, 255), 255);
    }
    for (int i=0; i<numVerts; i++) {
      xs[i] = random(-radius, radius);
      ys[i] = random(-radius, radius);
      minX = min(xs[i], minX);
      maxX = max(xs[i], maxX);
      minY = min(ys[i], minY);
      maxY = max(ys[i], maxY);
    }
    w = maxX-minX;
    h = maxY-minY;
    area = w*h;
  }
  
  void randomize(float opacity) {
    this.opacity = opacity;
    randomize();
  }

  void drawPoly() {
    if (life > 0) {
      strokeWeight(5);
      if (invert) {
        stroke(c);
        fill(255, opacity);
      } else {
        stroke(255);
        fill(c,opacity);
      }
      pushMatrix();
      translate(x, y);
      beginShape();
      for (int i=0; i<numVerts; i++) {
        curveVertex(xs[i], ys[i]);
      }
      endShape(CLOSE);
      popMatrix();
      if (opacity < 255) {
        opacity = opacity + opacityAdjustRate;
        if (opacity > 255) {
          opacity = 255;
        }
      }
      life--;
    }
  }
}