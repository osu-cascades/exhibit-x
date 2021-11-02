import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;
static final int DEPTH_THRESHOLD = 1000;
static final int CENTROID_MIN = 2000;
static final int SHAPES = 10;
static final int DEPTH_STRIPS = DEPTH_THRESHOLD/SHAPES;
int formResolution = 15;
float angle = radians(360 / formResolution);
int initRadius = 500;
int stepSize = 2;
float[] x = new float[formResolution];
float[] y = new float[formResolution];

void setup(){
  size(1920, 1080);
  background(255);
  kinect = new Kinect(this);
  kinect.enableMirror(true);
  kinect.initDepth();
  strokeWeight(0.75);
  background(0);
  noFill();
  for (int i = 0; i < formResolution; i++) {
    x[i] = cos(angle * i) * initRadius;
    y[i] = sin(angle * i) * initRadius;
  }
  colorMode(HSB, 1.0, 1.0, 1.0);
}

void draw(){
  for(int i=0; i<SHAPES; i++){
    int[] center = centroid(kinect.getRawDepth(), i*DEPTH_STRIPS, (i+1)*DEPTH_STRIPS);
    if(center != null){
      drawShape(center[0], center[1], (float)(center[2]/Math.sqrt(width*width + height*height)), color((float)i/SHAPES,1,1));
    }
  }
}

void drawShape(int centerX, int centerY, float rad, int c){
  stroke(c, 50);
  for (int i = 0; i < formResolution; i++) {
      x[i] += random(-stepSize, stepSize);
      y[i] += random(-stepSize, stepSize);
    }

  beginShape();
  // first controlpoint
  curveVertex(x[formResolution - 1] + centerX, y[formResolution - 1] + centerY);

  // only these points are drawn
  for (int i = 0; i < formResolution; i++) {
    curveVertex(x[i]*rad + centerX, y[i]*rad + centerY);
  }
  curveVertex(x[0]*rad + centerX, y[0]*rad + centerY);

  // end controlpoint
  curveVertex(x[1]*rad + centerX, y[1]*rad + centerY);
  endShape();
  fill(0, 0,0 , 1);
  rect(0,0,width,height);
}

int[] centroid(int[] depth_data, int min, int max){
  int[] pos = {0,0,0};
  int total = 0;
  int minX=width+1;
  int minY=height+1;
  int maxX=0;
  int maxY=0;
   for(int i = 0; i < depth_data.length; i++) {
     if(min < depth_data[i] && depth_data[i] < max){
       int x = i%640;
       int y = i/640;
       pos[0] += x;
       pos[1] += y;
       if(x<minX) minX=x;
       if(y<minY) minY=y;
       if(x>maxX) maxX=x;
       if(y>maxY) maxY=y;
       total++;
     }
  }
  if(total < CENTROID_MIN){
    return null;
  }
  pos[0] = pos[0]*3/total;
  pos[1] = pos[1]*3/total;
  pos[2] = (int)Math.sqrt(Math.pow((maxX - minX),2) + Math.pow((maxY - minY), 2));
  return pos;
}

void keyPressed() {
  if (keyPressed) {
    if (key == 'r' ) {
      background(color(1));
    }
  }
}
