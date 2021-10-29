import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;
import java.awt.event.KeyEvent;

Kinect kinect;
PImage paintSurface;
float angle;
float heading = 0.0;

ArrayList<PVector> vectorLocations;

void setup() {
  kinect = new Kinect(this);
  kinect.initDepth();
  size(1920, 1080, P3D);
  angle = kinect.getTilt();
  vectorLocations = generateVectorLocations(50, 50);
}

void draw() {
  background(255);
  int[] depth_data = kinect.getRawDepth();
  
  heading += 0.1;
  
  int depthIndexOfClosestPoint = indexOfMinNotZero(depth_data);
  PVector target = getWindowPixelAtDepthIndex(depthIndexOfClosestPoint);  
  PVector mousePos = new PVector(mouseX, mouseY);

  for(PVector loc : vectorLocations) {
    if(getDepthAtWindowPixel(depth_data, loc) > 1000) {
      drawVector(loc, target);
    }
  }
  
  fill(#ff0000);
  ellipse(target.x, target.y, 20, 20);
 
}

ArrayList<PVector> generateVectorLocations(int numX, int numY) {
  ArrayList<PVector> results =  new ArrayList();
  int xSpacing = width / numX;
  int ySpacing = height / numY;
  for(int i = 0; i < numX * numY; i++) {
    PVector spaceIndexVector = indexToVec(i, numX);
    results.add(new PVector(spaceIndexVector.x * xSpacing, spaceIndexVector.y * ySpacing));
  }
  return results;
}

void drawVector(PVector location, PVector target) {
  stroke(0);
  PVector dest = PVector.sub(target, location);
  dest.setMag(30);
  line(location.x, location.y, location.x + dest.x, location.y + dest.y);
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

int indexOfMinNotZero(int[] list) {
  int result = 0;
  for(int i = 0; i < list.length; i++) {
    if(list[i] > 30 && list[i] < list[result]) {
      result = i;
    }
  }
  return result;
}

int vecToIndex(PVector vec, int bufWidth) {
  return ((int) vec.y * bufWidth) + (int) vec.x;
}

PVector indexToVec(int index, int bufWidth) {
  int x = index % bufWidth;
  int y = index / bufWidth;
  return new PVector(x, y);
}

int getDepthAtWindowPixel(int[] depthData, PVector pixel) {
  float normalizedX = pixel.x / width;
  float normalizedY = pixel.y / height;
  PVector depthLocation = new PVector(640.0 * normalizedX, 480.0 * normalizedY);
  return depthData[vecToIndex(depthLocation, 640)];
}

PVector getWindowPixelAtDepthIndex(int depthIndex) {
  PVector depthPixel = indexToVec(depthIndex, 640);
  depthPixel.normalize();
  return new PVector(width * depthPixel.x, height * depthPixel.y);
}
