/*
Agent class for simple attractor-based movement model
Donya Quick
*/

class Agent {
  // current position, speed, and acceleration
  float x = 0;
  float y = 0;
  float xSpeed = 0;
  float ySpeed = 0;
  float xAccel = 0;
  float yAccel = 0;
  
  // bounds for altering movement over time
  float sBound = 3; // maximum speed in any direction
  float aBound = 0.3; // maximum change in accel in any direction
  float maxAccel = 0.5; // maximum accel at any given time
  float aFactor = 0.5; // 0 to 1, affects seeking behavior
  
  // color and size variables
  color c;
  float aSize = 0;
  
  Agent() {
    xSpeed = random(-sBound,sBound);
    ySpeed = random(-sBound,sBound);
    xAccel = random(-aBound,aBound);
    yAccel = random(-maxAccel,maxAccel);
    aSize = random(20,30);
    c = color(round(random(50,200)), round(random(50,200)), round(random(50,200)));
  }
  
  void setLocation(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void drawShape() {
    fill(c);
    ellipse(x, y, aSize, aSize);
  }
  
  void update() {
    x = cap(x + xSpeed, aSize, width-aSize);
    y = cap(y + ySpeed, aSize, height-aSize);
    xSpeed = cap(bounce(xSpeed + xAccel, x, aSize,width-aSize), -sBound, sBound);
    ySpeed = cap(bounce(ySpeed + yAccel, y, aSize, height-aSize), -sBound, sBound);
    xAccel = cap(xAccel + random(-aBound,aBound), -maxAccel, maxAccel);
    yAccel = cap(yAccel + random(-aBound,aBound), -maxAccel, maxAccel);
    
    if (mousePressed) {
      if (x < mouseX && xAccel < 0 || x > mouseX && xAccel > 0) {
        xAccel = xAccel - random(min(xAccel*aFactor, xAccel), max(xAccel*aFactor, xAccel));
      }
      if (y < mouseY && yAccel < 0|| y > mouseY && yAccel > 0) {
        yAccel = yAccel - random(min(yAccel*aFactor, yAccel), max(yAccel*aFactor, yAccel));
      }
    }
  }
  
  // reflect off the sides of the window
  float bounce(float speed, float x, float lower, float upper) {
    if (x <= lower && speed < 0 || x >=upper && speed > 0) {
      return -speed;
    } else {
      return speed;
    }
  }
  
  // helper function to bound a value
  float cap(float val, float lower, float upper) {
    return max(min(val, upper), lower);
  }
  
  
  // ============== OTHER UPDATE FUNCTIONS ===============
  
    // Most basic model: updates position only (no speed or accel)
  void updateBasic() {
    x = cap(x + random(-sBound,sBound), aSize, width-aSize);
    y = cap(y + random(-sBound,sBound), aSize, height-aSize);
    
    if (mousePressed) {
      if (x < mouseX) {
        x = x + random(1,2);
      } else if (x > mouseX) {
        x = x - random(1,2);
      }
      if (y < mouseY) {
        y = y + random(1,2);
      } else if (y > mouseY) {
        y = y - random(1,2);
      }
    }
  }
  
  // a slightly better method: operate on speed/velocity
  void updateBetter() {
    x = cap(x + xSpeed, aSize, width-aSize);
    y = cap(y + ySpeed, aSize, height-aSize);
    xSpeed = cap(xSpeed + random(-3,3), -sBound, sBound);
    ySpeed = cap(ySpeed + random(-3,3), -sBound, sBound);
    
    if (mousePressed) {
      if (x < mouseX) {
        xSpeed = xSpeed + random(1,2);
      } else if (x > mouseX) {
        xSpeed = xSpeed - random(1,2);
      }
      if (y < mouseY) {
        ySpeed = ySpeed + random(1,2);
      } else if (y > mouseY) {
        ySpeed = ySpeed - random(1,2);
      }
    }
  }
}