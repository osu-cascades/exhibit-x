import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import java.util.*;

static final int DEPTH_THRESHOLD = 900;

Box2DProcessing box2d;

ShapesMaker shapesMaker;
Kinect kinect;
ArrayList<Particale> particles;
ArrayList<Body> bodies;

void setup() {
  size(1920,1080);
  smooth();

  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, -10);
	
  particles = new ArrayList<Particale>();
  bodies = new ArrayList<Body>();
  kinect = new Kinect(this);
  kinect.enableMirror(true);
  kinect.initDepth();
  shapesMaker = new ShapesMaker(kinect, 3, 60);
}

void draw() {
  background(255);

  box2d.step();
  for(Body b : bodies)
      box2d.destroyBody(b);
  
  bodies = shapesMaker.makeShapes();
  
  if (random(1) < 0.2) {
    Particale p = new Particale(width/2,30);
    particles.add(p);
  }

  for (Particale p: particles) {
    p.display();
  }

  for (int i = particles.size()-1; i >= 0; i--) {
    Particale b = particles.get(i);
    if (b.done()) {
      particles.remove(i);
    }
  }
}
