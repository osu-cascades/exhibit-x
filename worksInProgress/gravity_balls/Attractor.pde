final static float GRAVITATIONAL_CONSTANT = 9.807;

class Attractor {
  float mass; 
  float[] position;
  
  Attractor(float[]position, float mass){
   this.position = position;
   this.mass = mass; 
  }
  
  void draw(){
    fill(color(255,0,0));
    circle(this.position[0],this.position[1], 5);  
  }
  
  void update(int depth){
     float d = 1000 - depth;
     this.mass = d < 0 ? 0 : d/100;
  }
  
  void attract(Ball other){
    double distance = Math.pow(this.position[0] - other.position[0], 2) + Math.pow(this.position[0] - other.position[0], 2);

    // Prevents divide by zero when objects are on top of each other
    if(distance > 10.0){ 
      double force = ((this.mass * other.mass) / distance) * GRAVITATIONAL_CONSTANT;
      float[] direction = {
          this.position[0] - other.position[0],
          this.position[1] - other.position[1],
      };
      float distTotal = Math.abs(direction[0]) + Math.abs(direction[1]);
      other.velocity[0] += (direction[0]/distTotal) * force;
      other.velocity[1] += (direction[1]/distTotal) * force;
    }
  }
}
