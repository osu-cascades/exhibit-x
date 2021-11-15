import org.openkinect.freenect.*;
import org.openkinect.processing.*;

int NORTH = 0;
int EAST = 1;
int SOUTH = 2;
int WEST = 3;
int direction = SOUTH;

int stepSize = 3;
int minLength = 10;
int diameter = 1;
int angleCount = 7;
float angle;
boolean reachedBorder = false;

float posX;
float posY;
float posXcross;
float posYcross;

int dWeight = 50;
int speed = 10;

Kinect kinect;

PImage img;

double backgroundToKinectW, backgroundToKinectH;

static final int DEPTH_THRESHOLD = 850;


void setup() {
  size(1920, 1080);
  background(255);

  angle = getRandomAngle(direction);
  posX = floor(random(width));
  posY = 5;
  posXcross = posX;
  posYcross = posY;
  
  kinect = new Kinect(this);
   kinect.enableMirror(true);
  kinect.initDepth();
  img = createImage(width, height, ARGB);
  backgroundToKinectW = (double)kinect.width/((double)width);
  backgroundToKinectH = (double)kinect.height/((double)height);
  colorMode(HSB, 1.0, 1.0, 1.0);
}

void draw() {
  for (int i = 0; i <= speed; i++) {
    int[] depthData = kinect.getRawDepth();
  
    posX += cos(radians(angle)) * stepSize;
    posY += sin(radians(angle)) * stepSize;

    reachedBorder = false;

    if (posY <= 5) {
      direction = SOUTH;
      reachedBorder = true;
    } else if (posX >= width - 5) {
      direction = WEST;
      reachedBorder = true;
    } else if (posY >= height - 5) {
      direction = NORTH;
      reachedBorder = true;
    } else if (posX <= 5) {
      direction = EAST;
      reachedBorder = true;
    }

    int depth = depthData[(int)(posX*backgroundToKinectW) + (int)(posY*backgroundToKinectH*((float)kinect.width))];
    boolean hitPerson = (depth < DEPTH_THRESHOLD);
    if (reachedBorder || hitPerson) {
      angle = getRandomAngle(direction);

      float distance = dist(posX, posY, posXcross, posYcross);
      if (distance >= minLength) {
        strokeWeight(constrain(distance / dWeight, 3, 100));
        stroke(hitPerson ? color((float)depth/DEPTH_THRESHOLD,1,1) : color(0));
        line(posX, posY, posXcross, posYcross);
      }

      posXcross = posX;
      posYcross = posY;
    }
  }
  
}

void keyReleased() {
  if (keyCode == DELETE || keyCode == BACKSPACE) background(1);
}

float getRandomAngle(int currentDirection) {
  float a = (floor(random(-angleCount, angleCount)) + 0.5) * 90 / angleCount;
  if (currentDirection == NORTH) return a - 90;
  if (currentDirection == EAST) return a;
  if (currentDirection == SOUTH) return a + 90;
  if (currentDirection == WEST) return a + 180;
  return 0;
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
     kinect.setTilt(constrain(kinect.getTilt()+1,0,30));
    } else if (keyCode == DOWN) {
      kinect.setTilt(constrain(kinect.getTilt()-1,0,30));
    }
  }
}
