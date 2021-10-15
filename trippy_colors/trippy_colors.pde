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
     int pixel_color = 0;
     if(depth_data[i] < 900)
       pixel_color = COLORS[((depth_data[i] + offset) % (COLORS.length * COLORS.length))/COLORS.length];
     double_pixels(paintSurface, i, pixel_color);
  }
  paintSurface.updatePixels();
  image(paintSurface, 0, 0);
  fill(255);
  //offset = offset + 1 % COLORS.length;
}

void double_pixels(PImage paintSurface, int pixel_index, int pixel_color){
  int i = (pixel_index % (paintSurface.width/2)) * 2 + paintSurface.width * 2 * (pixel_index/(paintSurface.width/2));
   paintSurface.pixels[i] = pixel_color;
   paintSurface.pixels[i + 1] = pixel_color;
   paintSurface.pixels[i + paintSurface.width] = pixel_color;
   paintSurface.pixels[i + paintSurface.width + 1] = pixel_color;
}
