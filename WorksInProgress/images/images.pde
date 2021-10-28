import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;
static final int WIDTH = 1920;
static final int HEIGHT = 1080;
static final int DEPTH_THRESHOLD = 900;
static final int IMG_WIDTH = 640/5;
static final int IMG_HEIGHT = 480/5;
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
  //frameRate(3);
}


void draw() {  
  //tint(255, 20);
  PImage img = kinect.getVideoImage();
  //int[] depth_data = kinect.getRawDepth();
  //for(int i=0; i<depth_data.length; i++)
  //  if(depth_data[i] > DEPTH_THRESHOLD)
  //    img.set(i%640,i/640, color(255));
  x++;
  if(x > WIDTH/IMG_WIDTH){
   x=0;
   y++;
   if(y > HEIGHT/IMG_HEIGHT) y=0;
  }
  image(img, x*IMG_WIDTH, y*IMG_HEIGHT, IMG_WIDTH, IMG_HEIGHT);
}
