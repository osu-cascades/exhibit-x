import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;

Box2DProcessing box2d;

ArrayList<Boundary> boundaries;
ArrayList<Box> boxes;

PImage background;

final static int BOX_SIZE = 15;
final static int DEPTH_MAX = 900;
final static int RESET_INTERVAL = 20000; //in millsecs

float kinectToBackgroundWidth, kinectToBackgroundHieght, angle;
int prevTime = second();

void setup() {
  size(1920,1080);
  smooth();

  box2d = new Box2DProcessing(this);
  box2d.createWorld();

  box2d.setGravity(0, -100);

  boxes = new ArrayList<Box>();
  boundaries = new ArrayList<Boundary>();

  boundaries.add(new Boundary(width/2,height+10,width,10));
  
  kinect = new Kinect(this);
  angle = kinect.getTilt();
  kinect.initVideo();
  kinect.initDepth();
  
  background = createImage(width, height, ARGB);
  kinectToBackgroundWidth = width/kinect.width;
  kinectToBackgroundHieght = height/kinect.height;
  textSize(104);
}

void draw() {
  PImage kinectImg = kinect.getVideoImage();
  
  kinectImg.loadPixels();
  background.loadPixels();
  
  for(int x=0; x<width; x++){
   for(int y=0; y<height; y++){
     int xx = (int) (( ((float)x)/width) * kinect.width);
     int yy = (int)((((float)y)/height) * kinect.height);
     background.pixels[x + y*width] = kinectImg.pixels[xx + yy * kinect.width];
   }
  }
  
  background.updatePixels();
  
  imageMode(CORNER);
  image(background, 0, 0);
  
  // We must always step through time!
  box2d.step();

  // Display all the boundaries
  for (Boundary wall: boundaries) {
    wall.display();
  }

  // Display all the boxes
  for (Box b: boxes) {
    b.display();
  }
  
  if(millis() - prevTime > RESET_INTERVAL - 5000){
    fill(color(255,0,0));
    text((millis() - prevTime - RESET_INTERVAL)/1000 * -1 ,width/2, height/2); 
  }
  if(millis() - prevTime > RESET_INTERVAL){
    makeBoxes();
    prevTime = millis();
  } //<>//
}

void keyPressed() {
  if(key == ' ')
    makeBoxes();
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

void makeBoxes() {
  for (int i = boxes.size()-1; i >= 0; i--) {
    Box b = boxes.get(i);
    b.killBody();
    boxes.remove(i);
  }
  
  PImage kinectImg = kinect.getVideoImage();
  kinectImg.loadPixels();
  
  int[] depthData = kinect.getRawDepth();
  for(int x=0; x<kinect.width; x+=BOX_SIZE){
    for(int y=0; y<kinect.height; y+=BOX_SIZE){
        int  i = x + y*kinect.width;
        if(depthData[i] < DEPTH_MAX){
          int boxWidth = (int)(BOX_SIZE * kinectToBackgroundWidth);
          int boxHeight = (int)(BOX_SIZE * kinectToBackgroundHieght);
          int xx = (int)(x * kinectToBackgroundWidth);
          int yy = (int)(y * kinectToBackgroundHieght);
          PImage img = createImage(boxWidth, boxHeight, ARGB);
          img.loadPixels();
          background.loadPixels();
          for(int xxx=0; xxx<boxWidth; xxx++){
           for(int yyy=0; yyy<boxHeight; yyy++){
               img.pixels[xxx + yyy*boxWidth] = background.pixels[xx + xxx + (yy + yyy)*width];
           }
          }
          
          boxes.add(new Box(
            xx,
            yy,
            boxWidth,
            boxHeight,
            img
          ));
      }
    }
  }
  
}
