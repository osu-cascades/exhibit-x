import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;
PImage paintSurface;
static final int WIDTH = 640;
static final int HEIGHT = 520;
int n_max = 10;

void setup() {
  size(640, 480);
  //paintSurface = createImage(WIDTH, HIEGHT, ARGB);
  kinect = new Kinect(this);
  //kinect.initDepth();
  kinect.initVideo();
  kinect.setTilt(15);
}


void draw() {
  background(0);
  paintSurface = kinect.getVideoImage();
  paintSurface.loadPixels();
   for (int y = 0;  y < paintSurface.height; y += 1)
     for(int n =0; n < n_max; n++)
     for (int x = 1;  x < paintSurface.width; x += 1){
      int i = y*paintSurface.width + x;
      if(paintSurface.pixels[i] < paintSurface.pixels[i-1]){
        int tmp = paintSurface.pixels[i];
        paintSurface.pixels[i] = paintSurface.pixels[i-1];
        paintSurface.pixels[i-1] = tmp;
     }
    }
  paintSurface.updatePixels();
  image(paintSurface, 0, 0);
  fill(255);
  text("Sorting level: " + n_max, 10, 400);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      n_max++;
    } else if (keyCode == DOWN) {
      n_max--;
    }
  }
}
