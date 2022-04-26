import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;
PImage paintSurface;
static final int WIDTH = 1920;
static final int HEIGHT = 1440;
static final int STRIP_SIZE = 5;
static final int DEPTH_THRESHOLD = 50;
int LINE_SIZE = 2;
int color_range = 50;
static final int OFFSET_INCREASE = 0;
int offset = 0;
float angle;


void setup() {
  size(1920, 1080);
  paintSurface = createImage(WIDTH, HEIGHT, ARGB);
  kinect = new Kinect(this);
  kinect.initDepth();
  angle = kinect.getTilt();
}


void draw() {
  background(0);
  draw_background();
  draw_forground();
}

void draw_background(){
   colorMode(HSB, color_range, 1.0, 1.0);
  paintSurface.loadPixels();
  int[] depth_data = kinect.getRawDepth();
  for(int i = 0; i < depth_data.length; i++) {
     triple_pixels(paintSurface, i, color((depth_data[i] + offset) % color_range, 1.0, 1.0));
  }
  paintSurface.updatePixels();
  image(paintSurface, 0, 0);
  offset = offset + OFFSET_INCREASE % color_range;
}

void draw_forground() {
  colorMode(RGB, 255, 255,255,255);
  paintSurface.loadPixels();
  int[] depth_data = kinect.getRawDepth();
  for (int i = 0; i < depth_data.length; i+=LINE_SIZE) {
    int a = depth_data[i] % 3 != 0 ? 255 : 0; 
    int c = (((i+offset)/LINE_SIZE) % 2 == 0 ? color(0, 0, 0, a) : color(255,255,255, a));
    if(depth_data[i] > DEPTH_THRESHOLD)
      c = (((i+offset)/LINE_SIZE) % 2 == 0 ? color(0, 0, 0, 255) : color(255,255,255, 255));
    for(int l=0; l<LINE_SIZE; l++)
      triple_pixels(paintSurface, i+l, c);
  }
  paintSurface.updatePixels();
  image(paintSurface, 0, 0);
}


void triple_pixels(PImage paintSurface, int pixel_index, int pixel_color){
  int i = (pixel_index % (paintSurface.width/3)) * 3 + paintSurface.width * 3 * (pixel_index/(paintSurface.width/3));
  for(int x=0; x < 3; x++)
    for(int y=0; y <3; y++)
       paintSurface.pixels[i + x + paintSurface.width*y] = pixel_color;
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      angle++;
    } else if (keyCode == DOWN) {
      angle--;
    }else if (keyCode == LEFT) {
      color_range--;
    } else if (keyCode == RIGHT) {
      color_range++;
    }
    
    angle = constrain(angle, 0, 30);
    kinect.setTilt(angle);
  }
}
