import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;
PImage paintSurface;
static final int WIDTH = 1920;
static final int HEIGHT = 1440;
int LINE_SIZE = 3;
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
  strokeWeight(LINE_SIZE);
  draw_background();
  draw_forground();
  //offset = (offset + 1) ;
}

void draw_background(){
  background(255);
  for (int x = 0; x < paintSurface.width; x+= LINE_SIZE*2){
    int xx = (x + offset) % paintSurface.width;
    line(xx, 0, xx, paintSurface.height);
  }
}
void draw_forground() {
  int[] depth_data = kinect.getRawDepth();
  paintSurface.loadPixels();
  for (int i = 0; i < depth_data.length; i++) {
    int pi = (i % (paintSurface.width/3)) * 3 + paintSurface.width * 3 * (i/(paintSurface.width/3));
    int px = pi % paintSurface.width;
    int py = pi / paintSurface.width;
    for(int x=0; x<3; x++)
    for(int y=0; y <3; y++){
       int a = depth_data[i] < 900 ? 255 : 0; 
       int c = ((py+y+offset)/LINE_SIZE) % 2 == 0 ? color(0, 0, 0, a) : color(255,255,255, a);
       set_pixel(paintSurface, px+x, py+y, c);
    }
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
