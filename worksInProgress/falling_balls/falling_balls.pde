import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;
Balls balls; 
PImage paintSurface;

void setup() {
  size(1920, 1080);
  paintSurface = createImage(1920, 1080, ARGB);
  kinect = new Kinect(this);
  kinect.enableMirror(true);
  kinect.initDepth();
  balls = new Balls();
}

void draw() {
  background(0);
  int[] depth = kinect.getRawDepth();
  balls.update(depth);
  balls.draw();
  imgDisp(depth);
}

void imgDisp(int[] depth_data){
  paintSurface.loadPixels();
  for(int i = 0; i < depth_data.length - 120*640; i++) {
     int pixel_color = color(0,0,0,0);
     if(depth_data[i] < DEPTH_THRESHOLD){
       pixel_color = color(0,255,0,100);
     }
     triple_pixels(paintSurface, i, pixel_color);
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
