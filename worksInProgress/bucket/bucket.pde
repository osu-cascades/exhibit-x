import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;

Box2DProcessing box2d;

final static int DEPTH_THRESHOLD = 900;

ArrayList<Ball> balls;
Bucket bucket;

final static int BOX_SIZE = 10;
final static int DEPTH_MAX = 900;
final static int RESET_INTERVAL = 20000; //in millsecs

float kinectToBackgroundWidth, kinectToBackgroundHieght, angle;
int prevTime = second();

void setup() {
  size(1920,1080);
  smooth();
  
  //Bucket b = new Bucket();

  box2d = new Box2DProcessing(this);
  box2d.createWorld();

  box2d.setGravity(0, -50);

  balls = new ArrayList<Ball>();
  bucket = new Bucket(300, 300);
  
  kinect = new Kinect(this);
  kinect.enableMirror(true);
  angle = kinect.getTilt();
  kinect.initDepth();
  
  kinectToBackgroundWidth = width/kinect.width;
  kinectToBackgroundHieght = height/kinect.height;
  textSize(104);
}

void draw() {
  background(255);
  
  // We must always step through time!
  box2d.step();

  int[] center = centroid(kinect.getRawDepth());
  if(center != null)
    bucket.update(center[0], center[1]);
  bucket.draw();
  
  // Display all the boxes
  for (Ball b: balls) {
    b.display();
  }
  
  if (millis() > 3000) {
    balls.add(new Ball(width/2, 0, 10,10,color(255,0,0) ));
  }
  
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      angle++;
    } else if (keyCode == DOWN) {
      angle--;
    }
    angle = constrain(angle, 0, 30);
    kinect.setTilt(angle);
  }
}

int[] centroid(int[] depth_data){
  int[] pos = {0,0};
  int total = 0;
   for(int i = 0; i < depth_data.length; i++) {
     if(depth_data[i] < DEPTH_THRESHOLD){
       int x = i%640;
       int y = i/640;
       pos[0] += x;
       pos[1] += y;
       total++;
     }
  }
  if(total == 0){
    return null;
  }
  pos[0] = (int)((pos[0]*kinectToBackgroundWidth)/total);
  pos[1] = (int)((pos[1]*kinectToBackgroundHieght)/total);
  return pos;
}
