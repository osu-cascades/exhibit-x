import processing.video.*;
Movie myMovie;
PImage paintSurface;

void setup() {
  size(1920, 1800);
  myMovie = new Movie(this, "Serial Experiments Lain Trailer.mp4");
  myMovie.loop();
  paintSurface = createImage(width, height, ARGB);
}

void draw() {
  tint(255, 20);
  myMovie.loadPixels();
  paintSurface.loadPixels();
  for(int i=0; i<myMovie.pixels.length; i++)
    triple_pixels(paintSurface, i, myMovie.pixels[0]); 
  paintSurface.updatePixels();
  image(paintSurface, 0, 0, width, height);
  //System.out.println(myMovie.width);
}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
}

void triple_pixels(PImage paintSurface, int pixel_index, int pixel_color){
  int i = (pixel_index % (paintSurface.width/3)) * 3 + paintSurface.width * 3 * (pixel_index/(paintSurface.width/3));
  for(int x=0; x < 3; x++)
    for(int y=0; y <3; y++)
       paintSurface.pixels[i + x + paintSurface.width*y] = pixel_color;
}
