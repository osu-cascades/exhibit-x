import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import queasycam.*;

QueasyCam cam;
Kinect kinect;
final static int BOX_SIZE = 6;
final static int DISPLAY_WEIGTH = 4;
float deg;

void settings(){
    System.setProperty("jogl.disable.openglcore", "true");
    size(1920, 1080, P3D);
}

void setup() {
  kinect = new Kinect(this);
  kinect.initDepth();
  kinect.initVideo();
  cam = new QueasyCam(this);
  cam.speed = 10;   
  cam.position = new PVector(width/2,height/2,200); 
  perspective(PI/3, (float)width/height, 0.01, 10000);
  rectMode(CORNERS);
  deg = kinect.getTilt();
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
      //box(BOX_SIZE*DISPLAY_WEIGTH);
      translate(x*DISPLAY_WEIGTH * -1, y*DISPLAY_WEIGTH * -1, depth * -1);
    }
  }
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
