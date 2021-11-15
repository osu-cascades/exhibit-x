class Bucket {
  
  Boundary[] boundries = { new Boundary(0,0,10,10),new Boundary(100,0,10,10), new Boundary(0,100,10,10) };
  
  int w, h;
  final int THICKNESS = 30;
  
  Bucket(int w, int h){
    this.w = w;
    this.h = h;
  }
  
  void update(int x, int y){
    
    fill(color(0,255,0));
    circle(x,y, 10);
    for(Boundary b : boundries)
      b.killBody();
      
    x-= w/2;
    y+= h/2;
    
    boundries[0] = new Boundary(x+w/2, y-h/2, w, THICKNESS);
    boundries[1] = new Boundary(x, y-h, THICKNESS, h);
    boundries[2] = new Boundary(x+w, y-h, THICKNESS, h);
  }
  
 void draw(){
  for (Boundary wall: boundries) {
    wall.display();
  } 
 }
}
