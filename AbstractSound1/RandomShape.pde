/*
Abstract Sound I - RandomShape class
 Donya Quick
 */

class RandomShape {
  float x = 0;
  float y = 0;
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

  void randomize() {
    x = random(padding, width-padding);
    y = random(padding, height-lowerPadding);
    c = color(0, random(0, 255), 255);
    for (int i=0; i<numVerts; i++) {
      xs[i] = random(-(width/4), (width/4));
      ys[i] = random(-(width/4), (width/4));
    }
  }
  
  void randomize(float opacity) {
    this.opacity = opacity;
    randomize();
  }

  void drawPoly() {
    fill(c,opacity);
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
  }
}