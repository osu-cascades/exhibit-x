import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;
PImage paintSurface;
static final int WIDTH = 1920;
static final int HEIGHT = 1080;
static final int DEPTH_THRESHOLD = 900;

void setup() {
  size(1920, 1440);
  paintSurface = createImage(WIDTH, HEIGHT, ARGB);
  kinect = new Kinect(this);
  kinect.enableMirror(true);
  kinect.initDepth();
  kinect.setTilt(15);
}


void draw() {
  background(0);
  paintSurface.loadPixels();
  int[] depth_data = kinect.getRawDepth();
  int x = 0;
  int y = 0;
  int total = 0;
  for(int i = 0; i < depth_data.length - 120*640; i++) {
     int pixel_color = 0;
     if(depth_data[i] < DEPTH_THRESHOLD){
       pixel_color = #ffc0cb;
       total++;
       x += i%640;
       y += i/640;
     }
     triple_pixels(paintSurface, i, pixel_color);
  }
  paintSurface.updatePixels();
  image(paintSurface, 0, 0);
  if(total != 0){
    x /= total;
    y /= total;
    fill(#c0fff4);
    circle(x*3,y*3, 100);
  }
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
  pos[0] /= total;
  pos[1] /= total;
  return pos;
}

void triple_pixels(PImage paintSurface, int pixel_index, int pixel_color){
  int i = (pixel_index % (paintSurface.width/3)) * 3 + paintSurface.width * 3 * (pixel_index/(paintSurface.width/3));
  for(int x=0; x < 3; x++)
    for(int y=0; y <3; y++)
       paintSurface.pixels[i + x + paintSurface.width*y] = pixel_color;
}
