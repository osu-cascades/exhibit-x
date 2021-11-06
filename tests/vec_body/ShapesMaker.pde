class ShapesMaker {
  int resolution, minEdges;
  Kinect kinect;
  
  ShapesMaker(Kinect kinect, int resolution, int minEdges){
    this.resolution = resolution;
    this.minEdges = minEdges;
    this.kinect = kinect;
  }
  
  
ArrayList<PShape> makeShapes(){
  ArrayList<PShape> shapes = new ArrayList<PShape>();
  ArrayList<ShapeMaker> shapeMakers = new ArrayList<ShapeMaker>();
  for(PVector edge: findEdges()){
    ShapeMaker shapeMaker = null;
    for(ShapeMaker other:  shapeMakers){
      if(other.canAdd(edge)){
        if(shapeMaker == null){
         other.addVec(edge);
         shapeMaker = other;
         } else {
           other.merge(edge, shapeMaker);
           shapeMakers.remove(shapeMaker);
           break;
        }
      }
    }
    if(shapeMaker == null)
      shapeMakers.add(new ShapeMaker(edge));
  }
  
  for(ShapeMaker sm : shapeMakers)
    if(sm.vecs.size() > minEdges)
      shapes.add(sm.makeShape(resolution));
      
  return shapes;
}

ArrayList<PVector> findEdges(){
  int[] depthData = kinect.getRawDepth();
  ArrayList<PVector> edges = new ArrayList<PVector>();
  for(int x=1; x<639; x++){
    for(int y=1; y<479; y++){
       if(depthData[x + y*640] < DEPTH_THRESHOLD){
         int total = 0;
         for(int xx = -1; xx<2; xx++){
          for(int yy = -1; yy<2; yy++){
            if(depthData[(x+xx) + (y+yy)*640] < DEPTH_THRESHOLD){
              total++;
             }
           }
         }
         if(total < 9)
          edges.add(new PVector(x, y));
       }
    }
  }
  return edges;
}

}
