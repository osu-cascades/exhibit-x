// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2011
import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;
PImage paintSurface;
static final int DEPTH_THRESHOLD = 900;
static final int ATTR_COUNT = 5;

// A reference to our box2d world
Box2DProcessing box2d;

// Movers, jsut like before!
Mover[] movers = new Mover[50];

// Attractor, just like before!

Attractor[] attrs = new Attractor[ATTR_COUNT * ATTR_COUNT];

void setup() {
  size(1920,1080);
  smooth();
  kinect = new Kinect(this);
  kinect.initDepth();
  paintSurface = createImage(width, height, ARGB);

  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  // No global gravity force
  box2d.setGravity(0,0);

  for (int i = 0; i < movers.length; i++) {
    movers[i] = new Mover(random(20,40),random(width),random(height));
  }
  for(int x=0; x< ATTR_COUNT; x++)
    for(int y=0; y< ATTR_COUNT; y++)
      attrs[x + y*ATTR_COUNT] = new Attractor(x*(width/ATTR_COUNT), y*(height/ATTR_COUNT));
}

void draw() {
  background(255);
  // We must always step through time!
  box2d.step();
  
  int[] depthData = kinect.getRawDepth();
 // paintSurface.loadPixels();
 //for(int i=0; i<depthData.length; i+=1000){
 //  int x = (int)((((float)(i%640))/640) * width);
 //  int y = (int)((((float)(i/640))/480) * height);
 //  paintSurface.pixels[x + y*width] = color(0,0,0, 0);
 //  if(depthData[i] < DEPTH_THRESHOLD){
 //    paintSurface.pixels[x + y*width] = color(255,0,0, 100);
 //  }
 //}
 //paintSurface.updatePixels();
 
 for (int i = 0; i < movers.length; i++) {
    // Look, this is just like what we had before!
    for(Attractor a : attrs){
      int x = (int)((a.x/width)*640);
      int y = (int)((a.y/height)*480);
      if(depthData[x + y*640] < DEPTH_THRESHOLD){
        Vec2 force = a.attract(movers[i]);
        movers[i].applyForce(force);
        a.display();
      }
      movers[i].display();
    }
  }
  
  //image(paintSurface, 0, 0);
}
