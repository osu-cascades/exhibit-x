import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;
PFont monoFont;
static final int WIDTH = 1920;
static final int HEIGHT = 1080;
static final int TEXT_HIEGHT = 25;
static final int TEXT_WIDTH = (int)(TEXT_HIEGHT * 0.6);
static final String DEPTH_CHARS = " .,-~:;!*=#$@";
static final int DEPTH_LEVELS = 50;
float angle;


void setup() {
  size(1920, 1080);
  kinect = new Kinect(this);
  kinect.initDepth();
  angle = kinect.getTilt();
  monoFont = createFont("VerilySerifMono.otf",TEXT_HIEGHT);
  fill(0);
  textFont(monoFont);
}


void draw() {
  background(255);
  int[] depthData = kinect.getRawDepth();
  for(int y=1; y<HEIGHT/TEXT_HIEGHT; y++){
    String str = "";
    for(int x=0; x<WIDTH/TEXT_WIDTH; x++){
       str+= DEPTH_CHARS.charAt(DEPTH_CHARS.length() - 1 - constrain((depthAt(depthData, x, y) - 500)/DEPTH_LEVELS, 0, DEPTH_CHARS.length() - 1));
    }
    text(str, 0, TEXT_HIEGHT*y);
  }
}

int depthAt(int []depthData, int x, int y){
    x = (int) (((float)x/(WIDTH/TEXT_WIDTH)) * 640);
    y = (int) (((float)y/(HEIGHT/TEXT_HIEGHT)) * 480);
    return depthData[x + y*640];
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
