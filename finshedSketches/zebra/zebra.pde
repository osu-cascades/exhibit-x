import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;
PImage paintSurface;
static final int WIDTH = 1920;
static final int HEIGHT = 1440;
int LINE_SIZE = 8;
static final int DEPTH_THRESHOLD = 900;
int offset = 0;

void setup() {
  size(1920, 1440);
  paintSurface = createImage(WIDTH, HEIGHT, ARGB);
  kinect = new Kinect(this);
  kinect.initDepth();
  kinect.setTilt(15);
  stroke(0);
}


void draw() {
  strokeWeight(LINE_SIZE*3);
  draw_background();
  draw_forground();
  offset = (offset + 3) ;
}

void draw_background(){
  background(255);
  for (int x = 0; x < paintSurface.height; x+= LINE_SIZE*2*3){
    int xx = (x + offset) % paintSurface.height;
    line(0,xx, paintSurface.width, xx);
  }
}

void draw_forground() {
  int[] depth_data = kinect.getRawDepth();
  paintSurface.loadPixels();
  for (int i = 0; i < depth_data.length; i+=LINE_SIZE) {
    int c = color(0, 0, 0, 0);
    if(depth_data[i] < DEPTH_THRESHOLD)
      c = ((i/LINE_SIZE) % 2 == 0 ? color(0, 0, 0, 255) : color(255,255,255, 255));
    for(int l=0; l<LINE_SIZE; l++)
      triple_pixels(paintSurface, i+l, c);
  }
  paintSurface.updatePixels();
  image(paintSurface, 0, 0);
}

void set_pixel(PImage img, int x, int y, int c){
  img.pixels[x + y*img.width ] = c;
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      LINE_SIZE++;
    } else if (keyCode == DOWN) {
      LINE_SIZE--;
    }
  }
}

void triple_pixels(PImage paintSurface, int pixel_index, int pixel_color){
  int i = (pixel_index % (paintSurface.width/3)) * 3 + paintSurface.width * 3 * (pixel_index/(paintSurface.width/3));
  for(int x=0; x < 3; x++)
    for(int y=0; y <3; y++)
       paintSurface.pixels[i + x + paintSurface.width*y] = pixel_color;
}
