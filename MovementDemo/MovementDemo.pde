/*
Simple attractor-based movement model.
Circles swarm to mouse when pressed.
Donya Quick
*/

int numCircles = 20;
Agent[] agents = new Agent[numCircles];

void setup() {
  size(800,600);
  //frameRate(15); // uncomment to slow down
  background(0);
  for (int i=0; i<numCircles; i++) {
    agents[i] = new Agent();
    agents[i].setLocation(width/2, height/2);
  }
}

void draw() {
  fill(0,30);
  rect(-5,-5,width+5,height+5);
  //background(0); // uncomment to turn off trails
  for (int i=0; i<agents.length; i++) {
    agents[i].drawShape();
    agents[i].update();
  }
}