import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;
import java.awt.event.KeyEvent;

Kinect kinect;
PImage paintSurface;
float angle;

void setup() {
  kinect = new Kinect(this);
  kinect.initDepth();
  size(1920, 1080);
  paintSurface = createImage(width, height, ARGB);
  angle = kinect.getTilt();
}

void draw() {
  background(0);
  int[] depth_data = kinect.getRawDepth();

  paintSurface.loadPixels();
  
  for(int i = 0; i < paintSurface.pixels.length; i++) {
    PVector currentPixel = indexToVec(i, width);
    int depthPoint = getDepthAtWindowPixel(depth_data, currentPixel);
    if(depthPoint < 600 && depthPoint != 0) {
      paintSurface.pixels[i] = color(#006699, 191);
    }
    int alpha = (int) alpha(paintSurface.pixels[i]);
    if(alpha > 0) {
      alpha -= 1;    
    }
    paintSurface.pixels[i] &= 0xFFFFFF;
    paintSurface.pixels[i] |= alpha << 24;
  }
  paintSurface.updatePixels();
  image(paintSurface, 0, 0);
 
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
