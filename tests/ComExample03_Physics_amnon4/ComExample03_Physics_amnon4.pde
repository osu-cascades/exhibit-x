// Kinect Physics Example by Amnon Owed (15/09/12)
//edited by Arindam Sen
//updated for openProcessing library and Processing 3 by Erik Nauman 9/16
// import libraries
import org.openkinect.processing.*;
import blobDetection.*; // blobs
import toxi.geom.*; // toxiclibs shapes and vectors
import toxi.processing.*; // toxiclibs display
import shiffman.box2d.*; // shiffman's jbox2d helper library
import org.jbox2d.collision.shapes.*; // jbox2d
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.common.*; // jbox2d
import org.jbox2d.dynamics.*; // jbox2d

Kinect kinect;
// declare BlobDetection object
BlobDetection theBlobDetection;
// ToxiclibsSupport for displaying polygons
ToxiclibsSupport gfx;
// declare custom PolygonBlob object (see class for more info)
PolygonBlob poly;
// to hold the Toxiclibs polygon shape
Polygon2D toxiPoly;
//BODY?! BODY!! >:(
Body body;
Body body2;
Body body3;
Body body4;

// PImage to hold incoming imagery and smaller one for blob detection
PImage blobs;
// the kinect's dimensions to be used later on for calculations
int kinectWidth = 640;
int kinectHeight = 480;
PImage cam = createImage(640, 480, RGB);
int minThresh = 600;
int maxThresh = 900;
// to center and rescale from 640x480 to higher custom resolutions
float reScale;
float deg;

// background and blob color
color bgColor, blobColor;
// three color palettes (artifact from me storingmany interesting color palettes as strings in an external data file ;-)
String[] palettes = {
  "-1117720,-13683658,-8410437,-9998215,-1849945,-5517090,-4250587,-14178341,-5804972,-3498634", 
  "-67879,-9633503,-8858441,-144382,-4996094,-16604779,-588031", 
  "-1978728,-724510,-15131349,-13932461,-4741770,-9232823,-3195858,-8989771,-2850983,-10314372"
};
color[] colorPalette;

// the main PBox2D object in which all the physics-based stuff is happening
Box2DProcessing box2d;

//Keeping track of fixed objects, yo!
ArrayList<Boundary> boundaries;

// list to hold all the custom shapes (circles, polygons)
ArrayList<CustomShape> polygons = new ArrayList<CustomShape>();

void keyPressed() {
    if (keyCode == UP) {
      deg++;
    } else if (keyCode == DOWN) {
      deg--;
    }
    deg = constrain(deg, 0, 30);
    kinect.setTilt(deg);
  }

void setup() {
  println("SET UP");
  // it's possible to customize this, for example 1920x1080
  size(1280, 800, P3D);
  kinect = new Kinect(this);
  // mirror the image to be more intuitive
  kinect.enableMirror(true);
  kinect.initDepth();
  // calculate the reScale value
  // currently it's rescaled to fill the complete width (cuts of top-bottom)
  // it's also possible to fill the complete height (leaves empty sides)
  reScale = (float) width / kinectWidth;
  // create a smaller blob image for speed and efficiency
  blobs = createImage(kinectWidth/3, kinectHeight/3, RGB);
  // initialize blob detection object to the blob image dimensions
  theBlobDetection = new BlobDetection(blobs.width, blobs.height);
  theBlobDetection.setThreshold(0.3);
  // initialize ToxiclibsSupport object
  gfx = new ToxiclibsSupport(this);
  // setup box2d, create world, set gravity
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, -5);
  // set random colors (background, blob)
  setRandomColors(1);

  float gap = kinectWidth / 21;
  for (int i=0; i<20; i++)
  {
    drawString(gap * (i+1), 2, 10);
  }
  
  //////// CREATING ARRAYLISTS FOR BOUNDARIES
boundaries = new ArrayList<Boundary>();

  
}


void drawString(float x, float size, int cards) {

  float gap = kinectHeight/cards;
  // anchor card
  CustomShape s1 = new CustomShape(x, -40, size, BodyType.DYNAMIC);
  polygons.add(s1);

  CustomShape last_shape = s1;
  CustomShape next_shape;
  for (int i=0; i<cards; i++)
  {
    float y = -20 + gap * (i+1);
    next_shape = new CustomShape(x, -20 + gap * (i+1), size, BodyType.DYNAMIC);
    DistanceJointDef jd = new DistanceJointDef();

    Vec2 c1 = last_shape.body.getWorldCenter();
    Vec2 c2 = next_shape.body.getWorldCenter();
    // offset the anchors so the cards hang vertically
    c1.y = c1.y + size / 5;
    c2.y = c2.y - size / 5;
    jd.initialize(last_shape.body, next_shape.body, c1, c2);
    jd.length = box2d.scalarPixelsToWorld(gap - 1);
    box2d.createJoint(jd);
    polygons.add(next_shape);
    last_shape = next_shape;
  }
}

void draw() {
  background(bgColor);
  // update the kinect object
  cam.loadPixels();

  // Get the raw depth as array of integers
  int[] depth = kinect.getRawDepth();
  for (int x = 0; x < kinect.width; x++) {
    for (int y = 0; y < kinect.height; y++) {
      int offset = x + y * kinect.width;
      int d = depth[offset];

      if (d > minThresh && d < maxThresh) {
        cam.pixels[offset] = color(255);
      } else {
        cam.pixels[offset] = color(0);
      }
    }
  }

  cam.updatePixels();
  //image(cam, 0, 0); skip displaying depth image
  // copy the image into the smaller blob image
  blobs.copy(cam, 0, 0, cam.width, cam.height, 0, 0, blobs.width, blobs.height);
  // blur the blob image, otherwise too many blog segments
  blobs.filter(BLUR, 1);
  // detect the blobs
  theBlobDetection.computeBlobs(blobs.pixels);
  // initialize a new polygon
  poly = new PolygonBlob();
  // create the polygon from the blobs (custom functionality, see class)
  poly.createPolygon();
  // create the box2d body from the polygon
  poly.createBody();
  // update and draw everything (see method)
  updateAndDrawBox2D();
  // destroy the person's body (important!)
  poly.destroyBody();
  // set the colors randomly every 240th frame
  setRandomColors(240);}

void updateAndDrawBox2D() {
  // if frameRate is sufficient, add a polygon and a circle with a random radius
  // x, y, r, HOW MANY SIDES
  toxiPoly = new Circle(width/2,height/2-80,100).toPolygon2D(int(12));
  gfx.polygon2D(toxiPoly);
  
  // define a dynamic body positioned at xy in box2d world coordinates,
    // create it and set the initial values for this box2d body's speed and angle
    //INVISIBLE FORCE FIELD IN THE MIDDLE LOL
    
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(new Vec2(width/4, height/4)));
    body = box2d.createBody(bd);
    //body.setLinearVelocity(new Vec2(random(-8, 8), random(2, 8)));
    //body.setAngularVelocity(random(-5, 5));
    
    // box2d circle shape of radius r
     CircleShape cs2 = new CircleShape();
     cs2.m_radius = box2d.scalarPixelsToWorld(50);
      // tweak the circle's fixture def a little bit
     FixtureDef fd = new FixtureDef();
     fd.shape = cs2;
     fd.density = 1;
     fd.friction = 0.01;
     fd.restitution = 0.3;
      // create the fixture from the shape's fixture def (deflect things based on the actual circle shape)
     body.createFixture(fd);
    
    //MENGSI MOUSE FACE
    BodyDef mmF = new BodyDef();
    mmF.type = BodyType.STATIC;
    mmF.position.set(box2d.coordPixelsToWorld(new Vec2(width/4, height/2 + 50)));
    body2 = box2d.createBody(mmF);
    //body2.setLinearVelocity(new Vec2(random(-8, 8), random(2, 8)));
    //body2.setAngularVelocity(random(-5, 5));
    
     // Mengsi face ACTUAL physics ????
      CircleShape cs3 = new CircleShape();
      cs3.m_radius = box2d.scalarPixelsToWorld(50);
      // tweak the circle's fixture def a little bit
      FixtureDef fd2 = new FixtureDef();
      fd2.shape = cs3;
      fd2.density = 1;
      fd2.friction = 0.01;
      fd2.restitution = 0.3;
      // create the fixture from the shape's fixture def (deflect things based on the actual circle shape)
      body2.createFixture(fd2);
      
     //MENGSI MOUSE LEFT
    BodyDef mmL = new BodyDef();
    mmL.type = BodyType.STATIC;
    mmL.position.set(box2d.coordPixelsToWorld(new Vec2(width/4 - 75, height/2 -10  )));
    body3 = box2d.createBody(mmL);
    //body2.setLinearVelocity(new Vec2(random(-8, 8), random(2, 8)));
    //body2.setAngularVelocity(random(-5, 5));
    
     // Mengsi LEFT ACTUAL physics ????
      CircleShape cs4 = new CircleShape();
      cs4.m_radius = box2d.scalarPixelsToWorld(50);
      // tweak the circle's fixture def a little bit
      FixtureDef fd3 = new FixtureDef();
      fd3.shape = cs4;
      fd3.density = 1;
      fd3.friction = 0.01;
      fd3.restitution = 0.3;
      // create the fixture from the shape's fixture def (deflect things based on the actual circle shape)
      body3.createFixture(fd3);
      
      //MENGSI MOUSE RIGHT
    BodyDef mmR = new BodyDef();
    mmR.type = BodyType.STATIC;
    mmR.position.set(box2d.coordPixelsToWorld(new Vec2(width/4 + 75, height/2 -10 )));
    body4 = box2d.createBody(mmR);
    //body2.setLinearVelocity(new Vec2(random(-8, 8), random(2, 8)));
    //body2.setAngularVelocity(random(-5, 5));
    
     // Mengsi RIGHT AHHHHHHH ACTUAL physics ????
      CircleShape cs5 = new CircleShape();
      cs5.m_radius = box2d.scalarPixelsToWorld(50);
      // tweak the circle's fixture def a little bit
      FixtureDef fd4 = new FixtureDef();
      fd4.shape = cs5;
      fd4.density = 1;
      fd4.friction = 0.01;
      fd4.restitution = 0.3;
      // create the fixture from the shape's fixture def (deflect things based on the actual circle shape)
      body4.createFixture(fd4);
      

  if (frameRate > 30) {
    CustomShape shape1 = new CustomShape(kinectWidth/2, -50, random(2, 5), BodyType.DYNAMIC) ;
    CustomShape shape2 = new CustomShape(kinectWidth/2, -50, random(2, 5), BodyType.DYNAMIC);
    polygons.add(shape1);
    polygons.add(shape2);
  }
  // take one step in the box2d physics world
  box2d.step();

  // center and reScale from Kinect to custom dimensions
  translate(0, (height-kinectHeight*reScale)/2);
  scale(reScale);

  // display the person's polygon  
  noStroke();
  fill(blobColor);
  gfx.polygon2D(poly);

  // display all the shapes  (circles, polygons)
  // go backwards to allow removal of shapes
  for (int i=polygons.size()-1; i>=0; i--) {
    CustomShape cs = polygons.get(i);
    // if the shape is off-screen remove it (see class for more info)

    if (cs.done()) {
      polygons.remove(i);
      // otherwise update (keep shape outside person) and display polygon
    } else {
      cs.update();
      cs.display();
    }
  }
}


// sets the colors every nth frame
void setRandomColors(int nthFrame) {
  if (frameCount % nthFrame == 0) {
    // turn a palette into a series of strings
    String[] paletteStrings = split(palettes[int(random(palettes.length))], ",");
    // turn strings into colors
    colorPalette = new color[paletteStrings.length];
    for (int i=0; i<paletteStrings.length; i++) {
      colorPalette[i] = int(paletteStrings[i]);
    }
    // set background color to first color from palette
    bgColor = colorPalette[0];
    // set blob color to second color from palette
    blobColor = colorPalette[1];
    // set all shape colors randomly
    for (CustomShape cs : polygons) { 
      cs.col = getRandomColor();
    }
  }
}

// returns a random color from the palette (excluding first aka background color)
color getRandomColor() {
  return colorPalette[int(random(1, colorPalette.length))];
}