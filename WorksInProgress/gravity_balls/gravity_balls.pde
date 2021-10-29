import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;
Balls balls; 
Attractors attrs;

void setup() {
  size(1920, 1080);
  kinect = new Kinect(this);
  kinect.initDepth();
  balls = new Balls();
  attrs = new Attractors(kinect.getRawDepth());
}

void draw() {
  background(0);
  attrs.update(kinect.getRawDepth());
  balls.applyGravity(attrs);
  balls.update();
  balls.draw();
  attrs.draw();
}
