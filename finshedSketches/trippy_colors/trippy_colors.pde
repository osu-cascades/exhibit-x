import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;
PImage paintSurface;
static final int WIDTH = 1920;
static final int HEIGHT = 1440;
static final int[] COLORS = {#EF7C8E, #FAE8E0, #B6E2D3, #D8A7B1};
static final int STRIP_SIZE = 5;
int offset = 0;

void setup() {
  size(1920, 1440);
  paintSurface = createImage(WIDTH, HEIGHT, ARGB);
  kinect = new Kinect(this);
  kinect.initDepth();
  kinect.initVideo();
  kinect.setTilt(15);
}


void draw() {
  background(0);
  PImage videoImg = kinect.getVideoImage();
  videoImg.loadPixels();
  paintSurface.loadPixels();
  int[] depth_data = kinect.getRawDepth();
  for(int i = 0; i < depth_data.length; i++) {
     int pixel_color = videoImg.pixels[i];
     //int pixel_color = 0;
     if(depth_data[i] < 900)
       pixel_color = COLORS[((depth_data[i] + offset) % (COLORS.length * COLORS.length))/COLORS.length];
     triple_pixels(paintSurface, i, pixel_color);
  }
  paintSurface.updatePixels();
  image(paintSurface, 0, 0);
  //offset = offset + 1 % COLORS.length;
}

void triple_pixels(PImage paintSurface, int pixel_index, int pixel_color){
  int i = (pixel_index % (paintSurface.width/3)) * 3 + paintSurface.width * 3 * (pixel_index/(paintSurface.width/3));
  for(int x=0; x < 3; x++)
    for(int y=0; y <3; y++)
       paintSurface.pixels[i + x + paintSurface.width*y] = pixel_color;
}
