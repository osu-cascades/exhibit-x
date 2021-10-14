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
  paintSurface = createImage(640, 480, ARGB);
  size(640, 480);
  angle = kinect.getTilt();
}

void draw() {
  background(0);
  int[] depth_data = kinect.getRawDepth();
  paintSurface.loadPixels();
  
  for(int i = 0; i < depth_data.length; i++) {
    if(depth_data[i] < 600 && depth_data[i] != 0) {
      paintSurface.pixels[i] = color(#006699, 191);
    }
    int alpha = (int) alpha(paintSurface.pixels[i]);
    if(alpha > 0) {
      alpha -= 1;    
    }
    paintSurface.pixels[i] &= 0xFFFFFF;
    paintSurface.pixels[i] |= alpha << 24;
    
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
