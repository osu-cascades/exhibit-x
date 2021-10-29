final static int AMOUNT = 50; 

class Attractors {
  Attractor[] attrs;
  
  Attractors(){
    this.attrs = new Attractor[81];
    for(int x=0; x<9; x++)
     for(int y=0; y<9; y++){
       float[] position = {(x+1)*(width/20), (y+1)*(height/20)};
       this.attrs[x*9 + y] = new Attractor(position, 1);
     }
  }
  
  Attractors(Attractor[] attrs){
    this.attrs = attrs;
  }
  
  Attractors(int[] depth){
    this.attrs = new Attractor[100];
    for(int i=0; i<attrs.length; i++){
      float[] position = {(i%10)*(width/12),(i/10)*(height/12)};
      this.attrs[i] = new Attractor(position, 0);
    }
    update(depth);
  }
  
  void draw(){
    for(Attractor attr : this.attrs)
      attr.draw();
  }
  
  void update(int[] depth){
     for(int x=0; x<10; x++)
       for(int y=0; y<10; y++)
         this.attrs[x+y*10].update(depth[x*(width/30) + y*(height/30)]);
  }
  
  void attract(Ball other){
    for(Attractor attr : this.attrs)
      attr.attract(other);
  }
}
