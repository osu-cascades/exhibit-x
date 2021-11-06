import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import java.util.*;

Kinect kinect;
ShapesMaker shapesMaker;
static final int DEPTH_THRESHOLD = 900;

void setup(){
  size(1920, 1080);
  fill(0);
  kinect = new Kinect(this);
  kinect.enableMirror(true);
  kinect.initDepth();
  shapesMaker = new ShapesMaker(kinect, 10, 50);
}

void draw(){
   background(255);
  ArrayList<PShape> shapes =shapesMaker.makeShapes();
  for(PShape shape : shapes)
    shape(shape);
  text(shapes.size(), 100,100);
}
