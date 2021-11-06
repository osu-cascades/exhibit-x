// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2012
// Box2DProcessing example

// A fixed boundary class

class Boundary {

  // A boundary is a simple rectangle with x,y,width,and height
  float x;
  float y;
  float w;
  float h;
  
  // But we also have to make a body for box2d to know about it
  Body b;

  Boundary(float x_,float y_) {
    //x = x_;
    //y = y_;
    //w = w_;
    //h = h_;

    //// Define the polygon
    //PolygonShape sd = new PolygonShape();
    //// Figure out the box2d coordinates
    //float box2dW = box2d.scalarPixelsToWorld(w/2);
    //float box2dH = box2d.scalarPixelsToWorld(h/2);
    //// We're just a box
    //sd.setAsBox(box2dW, box2dH);


    //// Create the body
    //BodyDef bd = new BodyDef();
    //bd.type = BodyType.STATIC;
    //bd.position.set(box2d.coordPixelsToWorld(x,y));
    //b = box2d.createBody(bd);
    
    //// Attached the shape to the body using a Fixture
    //b.createFixture(sd,1);
        // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();

    Vec2[] vertices = new Vec2[4];
    vertices[0] = box2d.vectorPixelsToWorld(new Vec2(-15, 25));
    vertices[1] = box2d.vectorPixelsToWorld(new Vec2(15, 0));
    vertices[2] = box2d.vectorPixelsToWorld(new Vec2(20, -15));
    vertices[3] = box2d.vectorPixelsToWorld(new Vec2(-10, -10));

    sd.set(vertices, vertices.length);

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(x_, y_));
    b = box2d.createBody(bd);

    b.createFixture(sd, 1.0);
  }

  // Draw the boundary, if it were at an angle we'd have to do something fancier
  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(b);
    // Get its angle of rotation
    float a = b.getAngle();

    Fixture f = b.getFixtureList();
    PolygonShape ps = (PolygonShape) f.getShape();


    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    fill(175);
    stroke(0);
    beginShape();
    //println(vertices.length);
    // For every vertex, convert to pixel vector
    for (int i = 0; i < ps.getVertexCount(); i++) {
      Vec2 v = box2d.vectorWorldToPixels(ps.getVertex(i));
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
    popMatrix();
  }

}
