/*
Some Algorithmic Art
Donya Quick
December 2017

Turn the image created by jittery squares into an interesting eroded, 
fractal-looking thing. Caution: the rendering into that interesting 
image can take a while! Expect a pause for a few seconds, particularly 
if you set the canvas size to be large.

How to use: 
1. Run it and let the squares fill the space a bit.
2. Click to stop and render a cool image. Be patient! 
3. Click again to start over and go back to step 1.
*/

Rectangle[] shapes = new Rectangle[80];
int jitterDist = 10; // for use with oilify function
boolean keepDrawing = true; // flag to detect when to render

// for the edge e
float[][] kernel = {{ -1, -1, -1}, 
                    { -1,  9.2, -1}, 
                    { -1, -1, -1}};
                    
                   
void setup() {
  size(1500,1500); // better to keep it a square or close to it
  initialize();
}

void draw() {
  if (keepDrawing) {
    for (int i =0; i<shapes.length; i++) {
      shapes[i].display();
      shapes[i].update();
    }
  }
}

/*
First click stops animation and renders, second click resets, and so on.
*/
void mousePressed() {
  if (keepDrawing) {
    keepDrawing = false;
    postProcessing();
  } else {
    keepDrawing = true;
    initialize();
  }
}

void initialize() {
  background(0);
  jitterDist = width/150;
  for (int i =0; i<shapes.length; i++) {
    shapes[i] = new Rectangle();
  }
}

void postProcessing() {
  PImage bg = get(); 
  image(bg,0,0);
  
  // effect processing - these take some time on a large canvas!
  oilify(width/150,255,255);
  cubism(width/15);
  oilify(width/300,200,50);
  oilify(width/300,50,50);
  edgeDetect(); 
  
  for (int i=0; i<3; i++) {
    filter(ERODE);
  }  
}

/*
Edge detection code from Processing.org modified to use all RGB
fields rather than being grayscale.
*/
void edgeDetect() {
  PImage img = get();
  PImage edgeImg = createImage(img.width, img.height, RGB);
  // Loop through every pixel in the image.
  for (int y = 1; y < img.height-1; y++) { // Skip top and bottom edges
    for (int x = 1; x < img.width-1; x++) { // Skip left and right edges
      float sum = 0; // Kernel sum for this pixel
      float sum2 = 0;
      float sum3 = 0;
      for (int ky = -1; ky <= 1; ky++) {
        for (int kx = -1; kx <= 1; kx++) {
          // Calculate the adjacent pixel for this kernel point
          int pos = (y + ky)*img.width + (x + kx);
          // Image is grayscale, red/green/blue are identical
          float val = red(img.pixels[pos]);
          float val2 = green(img.pixels[pos]);
          float val3 = blue(img.pixels[pos]);
          // Multiply adjacent pixels based on the kernel values
          sum += kernel[ky+1][kx+1] * val;
          sum2 += kernel[ky+1][kx+1] * val2;
          sum3 += kernel[ky+1][kx+1] * val3;
        }
      }
      // new pixel uses all three color components now
      edgeImg.pixels[y*img.width + x] = color(sum, sum2, sum3);
    }
  }
  // State that there are changes to edgeImg.pixels[]
  edgeImg.updatePixels();
  image(edgeImg, 0, 0); // Draw the new image

}


/*
My attempt at the "oilify" effect in GIMP, but with some added control 
over opacity of the blobs. This means you can oilify over something 
without fully obscuring what's underneath, and you can have blobs with
visible edges (or faded edges) for an interesting effect.
*/
void oilify(int particleSize, float strokeOpacity, float fillOpacity) {
  for (int i=0; i<width*100; i = i + particleSize) {
    float x = random(jitterDist,width-jitterDist);
    float y = random(jitterDist,height-jitterDist);
    float xN = random(x-jitterDist,x+jitterDist);
    float yN = random(y-jitterDist,y+jitterDist);
    color c = get(round(xN),round(yN));
    //set(round(x), round(y), c);
    stroke(c, strokeOpacity);
    strokeWeight(particleSize/2);
    fill(c, fillOpacity);
    polygon(particleSize*1.5, x, y);
  }
}

/*
My attempt at the "cubism" effect in GIMP (which never really looks like 
actual cubism, but whatever)
*/
void cubism(int squareSize) {
  int xl = ceil(width/squareSize);
  int yl = ceil(height/squareSize);
  PImage[][] images = new PImage[xl][yl];
  for (int x=0; x<xl; x++) {
    for (int y=0; y<yl; y++) {
      images[x][y] = get(x*squareSize,y*squareSize,squareSize,squareSize);
    }
  }
  
  for (int x = 0; x<xl; x++) {
    for (int y = 0; y<yl; y++) {
      fill(255,0,0);
      pushMatrix();
      float rlim = squareSize/4;
      translate(x*squareSize+random(-rlim, rlim), y*squareSize+random(-rlim, rlim));
      rotate(random(0,PI/2));
      image(images[x][y], -squareSize/2, -squareSize/2);
      popMatrix();
    }
  }
}

/*
Drawing a convex but randomized polygon
*/
void polygon(float radius, float x, float y) {
  beginShape();
  for (float a = 0; a < TWO_PI; a += random(PI/8, PI/4)) {
    float sx = x + cos(a) * radius * random(0.5, 1.5);
    float sy = y + sin(a) * radius * random(0.5, 1.5);
    vertex(sx, sy);
  }
  endShape(CLOSE);
}