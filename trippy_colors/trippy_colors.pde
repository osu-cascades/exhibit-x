import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;
PImage paintSurface;
static final int WIDTH = 640;
static final int HEIGHT = 520;
static final int[] COLORS = {#FF0000, #00FF00, #0000FF};
static final int STRIP_SIZE = 5;

void setup() {
  size(640, 480);
  paintSurface = createImage(WIDTH, HEIGHT, ARGB);
  kinect = new Kinect(this);
  kinect.initDepth();
  //kinect.initVideo();
  kinect.setTilt(15);
}


void draw() {
  background(0);
  paintSurface.loadPixels();
  int[] depth_data = kinect.getRawDepth();
  for(int i = 0; i < depth_data.length; i++) {
     paintSurface.pixels[i] = COLORS[(depth_data[i] % (COLORS.length * COLORS.length))/COLORS.length];
  }
  paintSurface.updatePixels();
  image(paintSurface, 0, 0);
  fill(255);
}
