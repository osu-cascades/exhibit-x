Ball[] balls;

float ball_radius = 20;
float dvd_width = 189;
float dvd_height = 107;
PImage dvd_tex;

class Ball {
  float x_pos, y_pos, x_vel, y_vel;
  
  Ball() {
    x_pos = random(0, width - dvd_width);
    y_pos = random(0, height - dvd_height);
    x_vel = random(-6, 6);
    y_vel = random(-6, 6);
  }
  
  void update() {
    if (x_pos > width - dvd_width || x_pos < 0) {
      x_vel *= -1;
    } 
  
    if (y_pos > height - dvd_height || y_pos < 0) {
      y_vel *= -1;
    }
  
    x_pos += x_vel;
    y_pos += y_vel;
  }
  
  void draw() {
    fill(255);
    image(dvd_tex, x_pos, y_pos);
  }
}

void setup() {
  size(1920, 1080);
  balls = new Ball[50];
  dvd_tex = loadImage("dvd.png");
  dvd_tex.resize((int) dvd_width, (int) dvd_height);
  
  for (int i = 0; i < balls.length; i++) {
    balls[i] = new Ball();
  }
}

void draw() {
  background(0);
  for (int i = 0; i < balls.length; i++) {
    balls[i].update();
    balls[i].draw();
  }
}
