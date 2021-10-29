class Balls {
  Ball[] balls;
  
  Balls(Ball[] balls){
    this.balls = balls;
  }
  
  Balls(){
    this.balls = new Ball[100];
    for(int x=0; x<10; x++)
     for(int y=0; y<10; y++){
       float[] position = {(x+1)*(width/12), (y+1)*(height/12)};
       float[] velocity = {0,0};
       this.balls[x*10 + y] = new Ball(position,velocity, 20, color(255));
     }
  }
  
  void draw(){
    for(Ball ball : this.balls){
      ball.draw();
    }
  }
  
  void update(){
    ballsCollide();
    for(Ball ball : this.balls){
      ball.update();
    }    
  }
  
  void ballsCollide(){
    for(int i=0; i<this.balls.length; i++)
      for(int rest=i+1; rest<this.balls.length; rest++)
        this.balls[i].collideWithBall(this.balls[rest]);
  }
  
  void applyGravity(Attractors attr){
    for(Ball ball : this.balls){
      attr.attract(ball);
    }
  }
}
