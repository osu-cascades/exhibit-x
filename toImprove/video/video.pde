import processing.video.*;
import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Movie[] movies = new Movie[3];
color[] colors = {#ffffff, #ffff00, #00ffff, #00ff00, #ff00ff, #ff0000, #0000ff};
Kinect kinect;
PImage paintSurface;
static final int DEPTH_THRESHOLD = 300;

void setup() {
  size(1920, 1080);
  for(int i=0; i<movies.length; i++){
    movies[i] = new Movie(this, movies.length - 1- i + ".mp4");
    movies[i].loop();
  }
  kinect = new Kinect(this);
  kinect.initDepth();
  paintSurface = createImage(width, height, ARGB);
}

void draw() {
  int[] depthData = kinect.getRawDepth();
  paintSurface.loadPixels();
  for(Movie m: movies)
    m.loadPixels();
  for(int i=0; i<paintSurface.pixels.length; i++){
    float x = ((float)(i%paintSurface.width))/paintSurface.width;
    float y = ((float)(i/paintSurface.width))/paintSurface.height;
    int depth = depthData[(int)(x*640) + 640 * ((int) (y * 480))];
    paintSurface.pixels[i] = (int)random(0,2) == 0 ? color(255) : color(0);
    for(int m=movies.length-1; m>=0; m--)
      if(depth < 300 + (m+1)*DEPTH_THRESHOLD)
         paintSurface.pixels[i] = lerpColor(colors[(int)((x + random(-0.05, 0.05))*colors.length) % colors.length], movies[m].pixels[((int)(x * movies[m].width) + ((int)(y * movies[m].height)) * movies[m].width)], 0.8);  
  }
  paintSurface.updatePixels();
  image(paintSurface, 0, 0);
}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
}
