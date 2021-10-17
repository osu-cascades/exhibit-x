import org.openkinect.freenect.*;
import org.openkinect.processing.*;

// two modes, one where color moves across the past frames
static final boolean MOVE_MODE = true; 

Kinect kinect;
static final int DEPTH_THRESHOLD = 900;
static final int WIDTH = 1920;
static final int HEIGHT = 1440;
static final int[] COLORS = {#fbfc18, #f08e00, #ea599e, #b055a2, #37aae1, #52f460};
PImage []past = new PImage[COLORS.length];
int color_i = 0;
int past_i = 0;
float angle;

void setup() {
  size(1920, 1440);
  for(int i=0; i<past.length; i++)
    past[i] = createImage(WIDTH, HEIGHT, ARGB);
  kinect = new Kinect(this);
  kinect.initDepth();
  angle = kinect.getTilt();
}


void draw() {
  background(0);
  past[past_i].loadPixels();
  int[] depth_data = kinect.getRawDepth();
  for(int i = 0; i < depth_data.length; i++) {
     int past_color = 0;
     if(depth_data[i] < DEPTH_THRESHOLD)
       past_color = COLORS[color_i];
     triple_pixels(past[past_i], i, past_color);   
  }
  past[past_i].updatePixels();
  color_i = (color_i + 1) % COLORS.length;
  past_i = (past_i + 1) % past.length;
  if(MOVE_MODE) move_color();
  for(int i=0; i<past.length; i++)
    image(past[(i+past_i+1) % past.length], 0, 0);
}

void triple_pixels(PImage paintSurface, int pixel_index, int pixel_color){
  int i = (pixel_index % (paintSurface.width/3)) * 3 + paintSurface.width * 3 * (pixel_index/(paintSurface.width/3));
  for(int x=0; x < 3; x++)
    for(int y=0; y <3; y++)
       paintSurface.pixels[i + x + paintSurface.width*y] = pixel_color;
}

void move_color(){
 for(int i=0; i<past.length; i++){
    PImage p = past[(i+past_i+1) % past.length];
    p.loadPixels();
    for(int c = 0; c < p.pixels.length; c++)
      if(p.pixels[c] != 0)
        p.pixels[c] = COLORS[i % COLORS.length];
    p.updatePixels();
  }
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
