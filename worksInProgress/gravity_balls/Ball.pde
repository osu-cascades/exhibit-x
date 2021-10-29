final static float MAX_VELOCITY = 20;

class Ball {
   float[] position, velocity;
   int radius, ballColor;
   float mass = 1.4;
   
   Ball(float []position, float []velocity, int radius, int ballColor){
     this.position = position;
     this.velocity = velocity;
     this.radius = radius;
     this.ballColor = ballColor;
   }
   
   void draw(){
     fill(this.ballColor);
     circle(this.position[0], this.position[1], this.daimeter());
   }
   
   void update(){
     bounce_off_sides();
     update_position();
   }
   
  void bounce_off_sides(){
     if (left() <= 0 || width <= right()) {
          this.velocity[0] *= -1.0; 
      }
      if (bottom() <= 0 || height <= top()) {
          this.velocity[1] *= -1.0; 
      }
   }
   
   void update_position(){
     this.position[0] += constrain(this.velocity[0], MAX_VELOCITY*-1, MAX_VELOCITY);
     this.position[1] += constrain(this.velocity[1], MAX_VELOCITY*-1, MAX_VELOCITY);
   }
   
   void collideWithBalls(Ball[] balls){
     for(Ball other : balls)
       collideWithBall(other);
   }
   
   void collideWithBall(Ball other){
     float[] d_pos =  {this.position[0] - other.position[0], this.position[1] - other.position[1]};
     double distance = Math.sqrt((double)(d_pos[0] * d_pos[0] + d_pos[1] * d_pos[1]));
     int min_dist = other.radius + this.radius;
     if ((distance < min_dist && this != other) && (d_pos[0] != 0.0 && d_pos[1] != 0.0)) {
        // maybe add mass at some point
        float xDelta = (((this.velocity[0] - other.velocity[0]) * d_pos[0])/ (d_pos[0] * d_pos[0])) * d_pos[0];
        float yDelta = (((this.velocity[1] - other.velocity[1]) * d_pos[1])/ (d_pos[1] * d_pos[1])) * d_pos[1];
        this.velocity[0] -= xDelta;
        this.velocity[1] -= yDelta;
        other.velocity[0] += xDelta;
        other.velocity[1] += yDelta;
     }
   }
   
   float left(){
      return this.position[0] - this.radius;
   }
   
   float right(){
      return this.position[0] + this.radius;
   }
   
   float bottom(){
      return this.position[1] - this.radius;
   }
   
   float top(){
      return this.position[1] + this.radius;
   }
   
   int daimeter(){
     return this.radius * 2;
   }
}
