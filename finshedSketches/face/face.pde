import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;
PImage paintSurface;
static final int WIDTH = 1920;
static final int HEIGHT = 1080;
static final int DEPTH_THRESHOLD = 900;
static final int DIAMETER = 120;
static final int FACE_WIDTH = DIAMETER*3;
//static final int[] COLORS = {#fbfc18, #f08e00, #ea599e, #b055a2, #37aae1, #52f460};
static final int[] COLORS = {#BCECE0, #36EEE0, #F652A0, #4C5270};
static final int EYE_NUM = COLORS.length;
//static final int EYE_NUM = 25;

void setup() {
  size(1920, 1080);
  paintSurface = createImage(WIDTH, HEIGHT, ARGB);
  kinect = new Kinect(this);
  kinect.enableMirror(true);
  kinect.initDepth();
  kinect.setTilt(15);
}


void draw() {
  background(255);
  int[] depth_data = kinect.getRawDepth();
  int[] target = centroid(depth_data);
  //int[] target = {mouseX, mouseY};
  for(int x=0; x < WIDTH/FACE_WIDTH; x++)
    for(int y=0; y < HEIGHT/FACE_WIDTH; y++)
      face((x+0.25*x)*FACE_WIDTH, (y+0.25)*FACE_WIDTH, target);
  //imgDisp(depth_data);
}

void imgDisp(int[] depth_data){
  paintSurface.loadPixels();
  for(int i = 0; i < depth_data.length - 120*640; i++) {
     int pixel_color = color(0,0,0,0);
     if(depth_data[i] < DEPTH_THRESHOLD){
       pixel_color = color(0,255,0,100);
     }
     triple_pixels(paintSurface, i, pixel_color);
  }
  paintSurface.updatePixels();
  image(paintSurface, 0, 0);
}

void face(float x, float y, int[] target){
    eye(x, y, target);
    eye(x+DIAMETER*2, y, target);
    fill(color(255,0,0));
    arc(x+DIAMETER, y+DIAMETER , DIAMETER*3, DIAMETER*(2 - dist(x+DIAMETER, y+DIAMETER, target)/500), 0, PI);
}

float dist(float x, float y, int[] p){
  return (float) Math.sqrt(Math.pow(x - p[0], 2) + Math.pow(y - p[1], 2));
}

void eye(float x, float y, int[] target){
  //fill(255);
  for(int i=0; i<EYE_NUM; i++){
    float d = i*(DIAMETER/EYE_NUM);
    fill(COLORS[i]);
    circle(constrain(target[0], x-d/2, x+d/2), constrain(target[1], y-d/2, y+d/2), DIAMETER - d);
  }
}

int[] centroid(int[] depth_data){
  int[] pos = {0,0};
  int total = 0;
   for(int i = 0; i < depth_data.length; i++) {
     if(depth_data[i] < DEPTH_THRESHOLD){
       total++;
       pos[0] += i%640;
       pos[1] += i/640;
     }
  }
  if(total == 0){
    pos[0] = 0;
    pos[1] = 0;
    return pos;
  }
  pos[0] = pos[0]*3/total;
  pos[1] = pos[1]*3/total;
  return pos;
}

void triple_pixels(PImage paintSurface, int pixel_index, int pixel_color){
  int i = (pixel_index % (paintSurface.width/3)) * 3 + paintSurface.width * 3 * (pixel_index/(paintSurface.width/3));
  for(int x=0; x < 3; x++)
    for(int y=0; y <3; y++)
       paintSurface.pixels[i + x + paintSurface.width*y] = pixel_color;
}
