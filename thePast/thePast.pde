import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;
//PImage fullVideo;
PImage []past = new PImage[12];
static final int WIDTH = 1920;
static final int HEIGHT = 1440;
static final int[] COLORS = {#fbfc18, #f08e00, #ea599e, #b055a2, #37aae1, #52f460 };
int color_i = 0;
int past_i = 0;

void setup() {
  size(1920, 1440);
  //fullVideo = createImage(WIDTH, HEIGHT, ARGB);
  for(int i=0; i<past.length; i++)
    past[i] = createImage(WIDTH, HEIGHT, ARGB);
  kinect = new Kinect(this);
  kinect.initDepth();
  kinect.initVideo();
  kinect.setTilt(15);
}


void draw() {
  background(0);
  //PImage videoImg = kinect.getVideoImage();
    //videoImg.loadPixels();
    past[past_i].loadPixels();
  //fullVideo.loadPixels();
  int[] depth_data = kinect.getRawDepth();
  for(int i = 0; i < depth_data.length; i++) {
     int past_color = color(0,0,0,0);
     if(depth_data[i] < 900)
       past_color = COLORS[color_i];
     triple_pixels(past[past_i], i, past_color);   
     //triple_pixels(fullVideo, i, videoImg.pixels[i]);
  }
  //fullVideo.updatePixels();
  past[past_i].updatePixels();
  color_i = (color_i + 1) % COLORS.length;
  past_i = (past_i + 1) % past.length;
  //image(fullVideo, 0, 0);
  for(int i=0; i<past.length; i++)
    image(past[(i+past_i+1) % past.length], 0, 0);
}

void triple_pixels(PImage paintSurface, int pixel_index, int pixel_color){
  int i = (pixel_index % (paintSurface.width/3)) * 3 + paintSurface.width * 3 * (pixel_index/(paintSurface.width/3));
  for(int x=0; x < 3; x++)
    for(int y=0; y <3; y++)
       paintSurface.pixels[i + x + paintSurface.width*y] = pixel_color;
}
