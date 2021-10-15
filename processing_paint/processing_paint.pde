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
  paintSurface = createImage(1280, 960, ARGB);
  size(1280, 960);
  angle = kinect.getTilt();
}

void draw() {
  background(0);
  int[] depth_data = kinect.getRawDepth();
  paintSurface.loadPixels();
  
  for(int i = 0; i < depth_data.length; i++) {
    int pixel_color = color_at_doubled(paintSurface, i);
    if(depth_data[i] < 600 && depth_data[i] != 0) {
      pixel_color = color(#006699, 191);
    }
    int alpha = (int) alpha(pixel_color);
    if(alpha > 0) {
      alpha -= 1;    
    }
    pixel_color &= 0xFFFFFF;
    pixel_color |= alpha << 24;
    double_pixels(paintSurface, i, pixel_color);
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

int color_at_doubled(PImage paintSurface, int pixel_index){
  return paintSurface.pixels[(pixel_index % (paintSurface.width/2)) * 2 + paintSurface.width * 2 * (pixel_index/(paintSurface.width/2))];
}

void double_pixels(PImage paintSurface, int pixel_index, int pixel_color){
  int i = (pixel_index % (paintSurface.width/2)) * 2 + paintSurface.width * 2 * (pixel_index/(paintSurface.width/2));
   paintSurface.pixels[i] = pixel_color;
   paintSurface.pixels[i + 1] = pixel_color;
   paintSurface.pixels[i + paintSurface.width] = pixel_color;
   paintSurface.pixels[i + paintSurface.width + 1] = pixel_color;
}
