import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import queasycam.*;
import java.awt.Robot;

Robot robot;

QueasyCam cam;
Kinect kinect;
final static int BOX_SIZE = 6;
final static int DISPLAY_WEIGTH = 4;
final static int MAX_ANGEL_SEGS = 1000;
int angleSeg = 0;
int angleSegDelta = 1;
float deg;
int circleSize = 2000;

void settings(){
    System.setProperty("jogl.disable.openglcore", "true");
    size(1920, 1080, P3D);
}

void setup() {
  noCursor();
  kinect = new Kinect(this);
  kinect.initDepth();
  kinect.initVideo();
  cam = new QueasyCam(this);
  cam.speed = 10;   
  cam.position = new PVector(2809.2893,-77.227715,-349.65762); 
  cam.tilt =0.4;
  cam.pan = 2.2;
   cam.controllable = true;
  perspective(PI/3, (float)width/height, 0.01, 10000);
  rectMode(CORNERS);
  try {
    robot = new Robot();
  } 
  catch (Throwable e) {
  }
  robot.mouseMove(width/2, height/2);
}

void draw() {
  int[] depthData = kinect.getRawDepth();
  PImage videoData = kinect.getVideoImage();
  videoData.loadPixels();
  
  background(255);
  noStroke();
  for(int x=0; x<640; x+=BOX_SIZE){
    for(int y=0; y<480; y+=BOX_SIZE){
      int i = x + y*640;
      int depth = depthData[i];
      translate(x*DISPLAY_WEIGTH, y*DISPLAY_WEIGTH, depth);
      fill(videoData.pixels[i]);
      rect3D(depth);
      translate(x*DISPLAY_WEIGTH * -1, y*DISPLAY_WEIGTH * -1, depth * -1);
    }
  }
  
  angleSeg += angleSegDelta;
  if(angleSeg > MAX_ANGEL_SEGS)
    angleSegDelta = -1;
  else if(angleSeg < 0)
    angleSegDelta = 1;
    
  System.out.println("pan: " + cam.pan + " tilt: " + cam.tilt);
  System.out.println(cam.position.x + "," + cam.position.y + "," + cam.position.z);
}

void rect3D(int size){
  
   int a = BOX_SIZE*DISPLAY_WEIGTH;

   rect(0,0,a,a);  
   
   translate(0,0,size);
   rect(0,0,a,a);
   translate(0, 0, -1 * size);
   
   rotateX(PI/2);
   
   rect(0,0,a,size);  
   
   translate(0,0,a * -1);
   rect(0,0,a,size);
   translate(0, 0, a);
   
   rotateY(PI/2);
   
   rect(0,0,a,size);
   
   translate(0,0,a);
   rect(0,0,a,size);
   translate(0, 0,-1 * a);
 
    rotateY(PI * -0.5);
     rotateX(PI * -0.5);
 }
 
 void keyPressed() {
  if (keyCode == UP) {
    deg++;
  } else if (keyCode == DOWN) {
    deg--;
  }
  deg = constrain(deg, 0, 30);
  kinect.setTilt(deg);
}
