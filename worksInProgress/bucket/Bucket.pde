class Bucket {
  
  Boundary[] boundries = { new Boundary(0,0,10,10),new Boundary(100,0,10,10), new Boundary(0,100,10,10) };
  
  int w, h;
  final int THICKNESS = 30;
  
  Bucket(int w, int h){
    this.w = w;
    this.h = h;
    boundries[0] = new Boundary(width/2+w/2, height/2-h/2, w, THICKNESS);
    boundries[1] = new Boundary(width/2, height/2-h, THICKNESS, h);
    boundries[2] = new Boundary(width/2+w, height/2-h, THICKNESS, h);
  }
  
  void update(int x, int y){
    
    fill(color(0,255,0));
    circle(x,y, 10);
    x-= w/2;
    y+= h/2;
    boundries[0].update(x+w/2, y-h/2);
    boundries[1].update(x, y-h);
    boundries[2].update(x+w, y-h);
  }
  
 void draw(){
  for (Boundary wall: boundries) {
    wall.display();
  } 
 }
}
