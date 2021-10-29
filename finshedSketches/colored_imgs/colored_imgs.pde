import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;
static final int WIDTH = 1920;
static final int HEIGHT = 1080;
static final int DEPTH_THRESHOLD = 900;
static final int IMG_WIDTH = 640/12;
static final int IMG_HEIGHT = 480/12;
PImage colorImg;
int x = 0;
int y = 0;

void setup() {
  size(1920, 1080);
  kinect = new Kinect(this);
  kinect.enableMirror(true);
  kinect.initVideo();
  kinect.initDepth();
  kinect.setTilt(15);
  background(255);
  //colorImg = loadImage("beav2.jpeg");
  colorImg = loadImage("osu.png");
  //frameRate(3);
}


void draw() {  
  PImage img = kinect.getVideoImage();
  x++;
  if(x > WIDTH/IMG_WIDTH){
   x=0;
   y++;
   if(y > HEIGHT/IMG_HEIGHT) y=0;
  }
  //for(x=0; x<WIDTH/IMG_WIDTH; x++)
  //  for(y=0; y<HEIGHT/IMG_HEIGHT; y++){
      tint(colorImg.get((int)((((float)x*IMG_WIDTH)/WIDTH)*colorImg.width),(int)((((float)y*IMG_HEIGHT)/HEIGHT)*colorImg.height)), 255);
       image(img, x*IMG_WIDTH, y*IMG_HEIGHT, IMG_WIDTH, IMG_HEIGHT);
    //}
}
