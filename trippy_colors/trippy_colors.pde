import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;
PImage paintSurface;

static final int WIDTH = 1280;
static final int HEIGHT = 960;
static final int[] COLORS = {#FF0000, #00FF00, #0000FF};
static final int STRIP_SIZE = 5;
int offset = 0;

void setup() {
  size(1280, 960);
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
     int c = COLORS[((depth_data[i] + offset) % (COLORS.length * COLORS.length))/COLORS.length];
     int pi = (i % (WIDTH/2)) * 2 + WIDTH * 2 * (i/(WIDTH/2));
     paintSurface.pixels[pi] = c;
     paintSurface.pixels[pi + 1] = c;
     paintSurface.pixels[pi + WIDTH] = c;
     paintSurface.pixels[pi + WIDTH + 1] = c;
  }
  paintSurface.updatePixels();
  image(paintSurface, 0, 0);
  fill(255);
  //offset = offset + 1 % COLORS.length;
}
