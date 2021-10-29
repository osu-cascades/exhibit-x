final static float MAX_VELOCITY = 20;
final static int DEPTH_THRESHOLD = 900;

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
     applyGravity();
     bounce_off_sides();
     update_position();
   }
   
  void bounce_off_sides(){
     if (left() <= 0 || width <= right()) {
          this.velocity[0] *= -1.0; 
      }
      if (height <= top()) {
          this.velocity[1] *= -0.9; 
      }
   }
   
  void applyGravity(){
   this.velocity[1] += 0.2;
  }
   
   void update_position(){
     this.position[0] += constrain(this.velocity[0], MAX_VELOCITY*-1, MAX_VELOCITY);
     this.position[1] += constrain(this.velocity[1], MAX_VELOCITY*-1, MAX_VELOCITY);
   }
   
   void collideWithDepth(int[] depth){
     for(int i=0; i<depth.length; i++)
       if(depth[i] < DEPTH_THRESHOLD && within((i % 640)*3, 3*(i/640))){
         //float[] d_pos =  {this.position[0] - (i % 640), this.position[1] - (i/640)};
         //this.velocity[0] -= ((this.velocity[0] * d_pos[0])/ (d_pos[0] * d_pos[0])) * d_pos[0];
         //this.velocity[1] -= ((this.velocity[1] * d_pos[1])/ (d_pos[1] * d_pos[1])) * d_pos[1];;
         this.velocity[1] *= -0.9; 
          this.velocity[0] *= -0.9; 
          update_position();
         break;
       }
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
   
   boolean within(int x, int y){
     return left() <= x &&  x <= right() &&
       y <= top() && y >= bottom();
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
