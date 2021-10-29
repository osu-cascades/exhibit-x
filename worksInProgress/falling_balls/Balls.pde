class Balls {
  Ball[] balls;
  
  Balls(Ball[] balls){
    this.balls = balls;
  }
  
  Balls(){
    this.balls = new Ball[50];
    for(int x=0; x<this.balls.length; x++){
       float[] position = {(x+1)*(width/12), 0};
       float[] velocity = {random(-2,2),random(-20,0)};
       this.balls[x] = new Ball(position,velocity, 20, color(255));
     }
  }
  
  void draw(){
    for(Ball ball : this.balls){
      ball.draw();
    }
  }
  
  void update(int[] depth){
    ballsCollide();
    collideWithDepth(depth);
    for(Ball ball : this.balls){
      ball.update();
    }    
  }
  
  void ballsCollide(){
    for(int i=0; i<this.balls.length; i++)
      for(int rest=i+1; rest<this.balls.length; rest++)
        this.balls[i].collideWithBall(this.balls[rest]);
  }
  
  void collideWithDepth(int[] depth){
    for(Ball ball : this.balls){
      ball.collideWithDepth(depth);
    }  
  }
  
}
