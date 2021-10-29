import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;
static final int DEPTH_THRESHOLD = 900;
int formResolution = 15;
float angle = radians(360 / formResolution);
int initRadius = 150;
int stepSize = 2;
int radius = (int)(initRadius * random(0.5, 1));
float[] x = new float[formResolution];
float[] y = new float[formResolution];

void setup(){
  size(1920, 1080);
  background(255);
  kinect = new Kinect(this);
  kinect.enableMirror(true);
  kinect.initDepth();
  stroke(0, 50);
  strokeWeight(0.75);
  background(255);
  noFill();
  for (int i = 0; i < formResolution; i++) {
    x[i] = cos(angle * i) * initRadius;
    y[i] = sin(angle * i) * initRadius;
  }
}

void draw(){
  int[] center = centroid(kinect.getRawDepth());
  int centerX = center[0];
  int centerY = center[1];
  for (int i = 0; i < formResolution; i++) {
    x[i] += random(-stepSize, stepSize);
    y[i] += random(-stepSize, stepSize);
    // uncomment the following line to show position of the agents
    // ellipse(x[i] + centerX, y[i] + centerY, 5, 5);
  }

  beginShape();
  // first controlpoint
  curveVertex(x[formResolution - 1] + centerX, y[formResolution - 1] + centerY);

  // only these points are drawn
  for (int i = 0; i < formResolution; i++) {
    curveVertex(x[i] + centerX, y[i] + centerY);
  }
  curveVertex(x[0] + centerX, y[0] + centerY);

  // end controlpoint
  curveVertex(x[1] + centerX, y[1] + centerY);
  endShape();
}

int[] centroid(int[] depth_data){
  int[] pos = {0,0};
  int total = 0;
   for(int i = 0; i < depth_data.length; i++) {
     if(depth_data[i] < DEPTH_THRESHOLD){
       total++;
       pos[0] += i%640;
       pos[1] += i/640;
     }
  }
  if(total == 0){
    pos[0] = 0;
    pos[1] = 0;
    return pos;
  }
  pos[0] = pos[0]*3/total;
  pos[1] = pos[1]*3/total;
  return pos;
}
