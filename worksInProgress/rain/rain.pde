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
BlobDetection theBlobDetection;
ToxiclibsSupport gfx;
PolygonBlob poly;
Polygon2D toxiPoly;

// PImage to hold incoming imagery and smaller one for blob detection
PImage blobs;
int kinectWidth = 640;
int kinectHeight = 480;
PImage cam = createImage(640, 480, RGB);
int minThresh = 50;
int maxThresh = 900;
// to center and rescale from 640x480 to higher custom resolutions
float reScale;
float deg;

color bgColor, blobColor;
CustomShape[] polygons = new CustomShape[10];

Box2DProcessing box2d;

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
  size(1920, 1080, P3D);
  kinect = new Kinect(this);
  kinect.enableMirror(true);
  kinect.initDepth();
  reScale = (float) width / kinectWidth;
  // create a smaller blob image for speed and efficiency
  blobs = createImage(kinectWidth/3, kinectHeight/3, RGB);
  theBlobDetection = new BlobDetection(blobs.width, blobs.height);
  theBlobDetection.setThreshold(0.3);
  gfx = new ToxiclibsSupport(this);
  
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, -10);

  for(int i=0; i<polygons.length; i++)
    polygons[i] = new CustomShape(i * 640/10, random(20, 100), 10, BodyType.DYNAMIC);

}

void draw() {
  background(bgColor);
  
  cam.loadPixels();

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
  poly = new PolygonBlob(theBlobDetection);
  // create the polygon from the blobs (custom functionality, see class)
  poly.createPolygon();
  // create the box2d body from the polygon
  poly.createBody();
  // update and draw everything (see method)
  updateAndDrawBox2D();
  // destroy the person's body (important!)
  poly.destroyBody();

}

void updateAndDrawBox2D() {
  // take one step in the box2d physics world
  box2d.step();

  // center and reScale from Kinect to custom dimensions
  translate(0, (height-kinectHeight*reScale)/2);
  scale(reScale);

  // display the person's polygon  
  noStroke();
  fill(color(0,255,0));
  gfx.polygon2D(poly);
  
  for (int i=polygons.length-1; i>=0; i--) {
    CustomShape cs = polygons[i];
    cs.update();
    cs.display();
  }

}
