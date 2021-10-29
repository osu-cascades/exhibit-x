import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;
static final int WIDTH = 1920;
static final int HEIGHT = 1440;
static final int BALL_DAIMETER = 20;
float angle;


void setup() {
  size(1920, 1440);
  kinect = new Kinect(this);
  angle = kinect.getTilt();
  kinect.initVideo();
  kinect.initDepth();
}

void draw() {
  background(0);
  PImage img = kinect.getVideoImage();
  int[] depthData = kinect.getRawDepth();
  img.loadPixels();
  for(int x=0; x<(WIDTH/3)/BALL_DAIMETER; x++)
     for(int y=0; y<(HEIGHT/3)/BALL_DAIMETER; y++){
       fill(adv_color_sq(img, x*BALL_DAIMETER, y*BALL_DAIMETER, BALL_DAIMETER));
       //fill(img.get((int)((x + 0.5)*BALL_DAIMETER), (int)((y + 0.5)*BALL_DAIMETER)));
       circle((x + 0.5)*3*BALL_DAIMETER, (y + 0.5)*3*BALL_DAIMETER, BALL_DAIMETER*3*depthDaimeter(depthData, x*BALL_DAIMETER, y*BALL_DAIMETER, BALL_DAIMETER));
       //rect(x*3*BALL_DAIMETER, y*3*BALL_DAIMETER, 3*BALL_DAIMETER, 3*BALL_DAIMETER);
     }
}

float depthDaimeter(int[] depthData, int x, int y, int size){
  int depthTotal = 0;
  for(int xi=0; xi<size; xi++)
     for(int yi=0; yi<size; yi++)
       depthTotal += depthData[(x+xi) + (y+yi)*640];
  //System.out.println(((float)depthTotal) / (size*size));
  return constrain(1 - (((float)depthTotal) / (size*size))/1200, 0, 1);
}

int adv_color_sq(PImage img, int x, int y, int size){
   int r,g,b;
   r=0;g=0;b=0;
   for(int xi=0; xi<size; xi++)
     for(int yi=0; yi<size; yi++){
       int imgColor = img.pixels[(x+xi) + (y+yi)*640];
       r+=red(imgColor);
       g+=green(imgColor);
       b+=blue(imgColor);
     }
   size *= size;
   return color(r/size, g/size, b/size);
}

void keyPressed() {
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
