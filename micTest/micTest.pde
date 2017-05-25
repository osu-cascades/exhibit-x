import processing.sound.*;
import ddf.minim.*;
import ddf.minim.ugens.*;

AudioIn in;
Amplitude amp;
float y;
float ypos = 100;
float xpos = 100;
int direction = 1;
Frequency test;

void setup() {
  size(640, 360);
  amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  in.start();
  amp.input(in);
}      

void draw() {
  y = amp.analyze();
  ypos = y * 1000;
  println(y);
  background(0);
  if (y > .01){
    xpos = (xpos + 10) * direction;
  }
  if (xpos > width || xpos < 0){
    direction *= -1;
  }
  fill(247, 0, 0);
  ellipse(xpos, -ypos + 200, 100, 100);
  
}