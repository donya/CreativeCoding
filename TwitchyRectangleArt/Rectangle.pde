/*
Jittery rectangle class in shades of blue
Donya Quick
*/

class Rectangle {
  
  float factor = 1.5; // use this to tweak shape size quickly on different canvas
  
  // Blue must always be a higher value
  float lightness = random(0,255);
  float blue = random(lightness+50,lightness+100);
  
  // Other shape settings
  float minCurvature = 5;
  float maxCurvature = 50;
  float curvature = random(minCurvature,maxCurvature);
  float x = 0;
  float y = 0;
  float minSize = 100;
  float maxSize = 150;
  float w = 50; 
  float h = 50; 
  boolean decay = false;
  float opacity = 255;
  
  Rectangle() {
    // place the shape randomly on initialization
    x = random(0,width);
    y = random(0,height);
    
    // in case the screen was a different size we'll redo the shape dimensions
    minSize = width/15;
    maxSize = width/10;
    w = random(minSize,maxSize);
    h = random(minSize,maxSize);
  }
  
  void display() {
    if (w > 0 && h > 0) {
      strokeWeight(width/250);
      stroke(lightness-100, lightness-100, blue-50);
      fill(lightness, lightness, blue, opacity);
      rect(x,y,w*factor,h*factor, curvature);
    }
  }
  
  void update() {
    // change color slightly
    lightness = max(0,min(lightness+random(-4,4),255));
    blue = max(lightness+50,min(blue+random(-4,4),lightness+100));
    blue = max(0, min(blue,255));
    
    // slightly change shape curvature, size, and location
    curvature = max(minCurvature,min(lightness+random(-5,5),maxCurvature));
    w = max(minSize,min(w + random(-4,4),maxSize));
    h = max(minSize,min(h + random(-4,4),maxSize));
    x = max(0,min(x + random(-10,10),width));
    y = max(0,min(y + random(-10,10),height));
  }
}