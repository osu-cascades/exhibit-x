import processing.sound.*;
AudioIn in;
Amplitude amp;

static final int maxSize = 800;

int c = 0;
int rectSize = maxSize;
float r = 0;
float rChange = 0.1;
int rectSizeChange = 10;
int dir = -1;

void setup(){
  size(1920, 1080);
  background(0);
  fill(0);
  strokeWeight(2);
  colorMode(HSB, 100);
  rectMode(CENTER);
  in = new AudioIn(this, 0);
  amp = new Amplitude(this);
  amp.input(in);
}

void draw(){
  stroke(c, 100, 100);
  float n = amp.analyze();
 
  translate(width/2, height/2);
  rotate(r);
  rect(0, 0 ,rectSize,rectSize);

  c = (c + 1) % 100;
  rectSize += rectSizeChange * dir;
  if(rectSize < 0 || rectSize > maxSize){
    dir *= -1;
    rChange = random(0.05, 0.5);
    rectSize = constrain(rectSize, 0, maxSize);
    rectSizeChange = (int)random(1, 20);
  }
  r+= n;
}
