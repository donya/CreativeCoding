/*
Represents a single push-button square on the game board.
*/

class Square {
  private float x = 0;
  private float y = 0;
  private float size = 10;
  private boolean lightOn = false; // is the square's light on?
  private float energy=0; // to achieve fade effect on button press
  
  Square(float newSize) {
    size = newSize;
  }
  
  void cool() {
    energy = energy - 10;
    cap(energy,0,255);
  }
  
  private float cap(float val, float lower, float upper) {
    if (val < lower) {
      return lower;
    } else if (val > upper) {
      return upper;
    } else {
      return val;
    }
  }
  
  private void flash() {
    energy=255;
  }
  
  void drawSquare() {
    stroke(0);
    strokeWeight(2);
    if (lightOn) {
      fill(0,255,255-energy);
    } else {
      fill(0,0,cap(energy,50,255));
    }
    rect(x,y,size,size);
    if (energy > 0) {
      cool();
    }
  }
  
  void autoPress(){
    energy = 0;
    lightOn = !lightOn;
  }
  
  void press() {
    flash();
    lightOn = !lightOn;
  }
  
  void press(boolean fade) {
    if (fade) {
      autoPress();
    } else {
      press();
    }
  }
  
  void setLocation(float newX, float newY) {
    x = newX;
    y = newY;
  }
  
  /* Check if a coordinate is within the square */
  boolean overSquare(float tx, float ty) {
    return tx >= x && tx <= x+size && ty >= y && ty <= y+size;
  }
  
  void off() {
    lightOn = false;
  }
  
  void on() {
    lightOn = true;
  }
  
  boolean isOn() {
    return lightOn;
  }
}