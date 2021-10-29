import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;
PImage paintSurface;
static final int WIDTH = 1920;
static final int HEIGHT = 1440;
static final int STRIP_SIZE = 5;
static final int DEPTH_THRESHOLD = 9000;
int color_range = 500;
static final int OFFSET_INCREASE = 0;
int offset = 0;
float angle;


void setup() {
  size(1920, 1440);
  paintSurface = createImage(WIDTH, HEIGHT, ARGB);
  kinect = new Kinect(this);
  kinect.initDepth();
  kinect.initVideo();
  angle = kinect.getTilt();
  colorMode(HSB, color_range, 1.0, 1.0);
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
     if(depth_data[i] < DEPTH_THRESHOLD)
       pixel_color = color((depth_data[i] + offset) % color_range, 1.0, 1.0);
     triple_pixels(paintSurface, i, pixel_color);
  }
  paintSurface.updatePixels();
  image(paintSurface, 0, 0);
  offset = offset + OFFSET_INCREASE % color_range;
  text("color range: " + color_range, 10, 10);
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
