class Asteroid {
  float x=-100;
  float y=-100;
  float aSize = 80;
  float xSpeed = 0;
  float ySpeed = 0;
  boolean alive = true;
  color c;
  
  Asteroid() {
    x = width+100;
    y = random(0,height);
    aSize = random(5,80);
    xSpeed = random(-5,-2);
    c = color(random(100,200), random(100,200), random(100,200));
  }
  
  void setSplit(float x, float y, float newSize, float xSpeed, float ySpeed) {
    this.x = x;
    this.y = y;
    this.aSize = newSize;
    this.xSpeed = xSpeed;
    this.ySpeed = ySpeed;
  }
  
  void drawShape() {
    fill(c);
    stroke(1);
    stroke(c);
    ellipse(x,y,aSize,aSize);
  }
  
  void move() {
    x = x + xSpeed;
    y = y + ySpeed;
    if (x < -aSize) {
      alive = false;
    }
  }
  
  boolean isHit(float xTarget, float yTarget) {
    return (xTarget < x && yTarget < y+aSize && yTarget > y-aSize);
  }
}