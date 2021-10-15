import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;
import java.awt.event.KeyEvent;

Kinect kinect;
PImage paintSurface;
float angle;

void setup() {
  kinect = new Kinect(this);
  kinect.initDepth();
  paintSurface = createImage(1920, 1440, ARGB);
  size(1920, 1440);
  angle = kinect.getTilt();
}

void draw() {
  background(0);
  int[] depth_data = kinect.getRawDepth();
  paintSurface.loadPixels();
  
  for(int i = 0; i < depth_data.length; i++) {
    int pixel_color = color_at_tripled(paintSurface, i);
    if(depth_data[i] < 600 && depth_data[i] != 0) {
      pixel_color = color(#006699, 191);
    }
    int alpha = (int) alpha(pixel_color);
    if(alpha > 0) {
      alpha -= 1;    
    }
    pixel_color &= 0xFFFFFF;
    pixel_color |= alpha << 24;
    triple_pixels(paintSurface, i, pixel_color);
  }
  paintSurface.updatePixels();
  image(paintSurface, 0, 0);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      angle++;
    } else if (keyCode == DOWN) {
      angle--;
    }
    
    angle = constrain(angle, 0, 30);
    kinect.setTilt(angle);
  }
}

void triple_pixels(PImage paintSurface, int pixel_index, int pixel_color){
  int i = tripled_index(paintSurface, pixel_index);
  for(int x=0; x < 3; x++)
    for(int y=0; y <3; y++)
       paintSurface.pixels[i + x + paintSurface.width*y] = pixel_color;
}

int color_at_tripled(PImage paintSurface, int pixel_index){
  return paintSurface.pixels[tripled_index(paintSurface, pixel_index)];
}

int tripled_index(PImage paintSurface, int pixel_index){
  return (pixel_index % (paintSurface.width/3)) * 3 + paintSurface.width * 3 * (pixel_index/(paintSurface.width/3));
}
