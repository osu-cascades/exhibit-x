class ShapeMaker {
  LinkedList<PVector> vecs = new LinkedList<PVector>();
  
  ShapeMaker(PVector vec){
    vecs.add(vec);
  }
  
  Body makeShape(int resolution){
   PolygonShape sd = new PolygonShape();

   //Vec2[] vertices = new Vec2[(vecs.size()/resolution)];

   Vec2[] vertices = new Vec2[4];
   
   //for(int i=0; i<vecs.size()/resolution; i++){
   //  PVector vec = vecs.get(i*resolution);
   //  vertices[i] = box2d.vectorPixelsToWorld(new Vec2((width * vec.x/640) - width/2, (height * vec.y/480) - height/2);
   //}
   //for(int i=0; i<3; i++){
   //  PVector vec = vecs.get(i*vecs.size()/2 % vecs.size());
   //  vertices[i] = box2d.vectorPixelsToWorld(new Vec2((int)((width * vec.x/640) - width/2), (int)((height * vec.y/480) - height/2) ));
   // for(int n=0; n<i; n++){
   //    if(vertices[n].x == vertices[i].x)
   //      vertices[i].x += 1;
   //    if(vertices[n].y == vertices[i].y)
   //      vertices[i].y += 1;
   //  }
   //  System.out.println("x: " + vertices[i].x + " y: " + vertices[i].y);
   //} 
   vertices[0] = box2d.vectorPixelsToWorld(new Vec2((width * vecs.peekFirst().x/640) - width/2, (height * vecs.peekFirst().y/480) - height/2));
   vertices[1] = new Vec2(vertices[0].x + 2,  vertices[0].y + 2);
   vertices[2] = box2d.vectorPixelsToWorld(new Vec2((width * vecs.peekLast().x/640) - width/2, (height * vecs.peekLast().y/480) - height/2));
   vertices[3] = new Vec2(vertices[2].x + 2,  vertices[2].y + 2);
    for(int i=0; i<4; i++)
     System.out.println("x: " + vertices[i].x + " y: " + vertices[i].y);
   sd.set(vertices, vertices.length);
    
   BodyDef bd = new BodyDef();
   bd.type = BodyType.STATIC;
   bd.position.set(box2d.coordPixelsToWorld(0,0));
   Body body =  box2d.createBody(bd);
   body.createFixture(sd, 1.0);
   return body;
  }

  void merge(PVector vec, ShapeMaker other){
    if(validDist(vec, vecs.peekFirst())){
       if(other.isFirst(vec))
         reverseMergeFirst(other);
       else 
         vecs.addAll(0, other.vecs);
    } else {
      if(other.isLast(vec))
         reverseMergeLast(other);
      else
         vecs.addAll(other.vecs);
    }
  }
  
  void reverseMergeFirst(ShapeMaker other){
   Iterator<PVector> reverseEdges = other.vecs.descendingIterator();
   while(reverseEdges.hasNext())
     vecs.addFirst(reverseEdges.next());
  }
  
  void reverseMergeLast(ShapeMaker other){
   Iterator<PVector> reverseEdges = other.vecs.descendingIterator();
   while(reverseEdges.hasNext())
     vecs.addLast(reverseEdges.next());
  }
  
  void addVec(PVector vec){
    if(validDist(vec, vecs.peekFirst()))
      vecs.addFirst(vec); 
    else
      vecs.addLast(vec);
  }
  
  boolean canAdd(PVector vec){
    return (validDist(vec, vecs.peekFirst()) || validDist(vec, vecs.peekLast()));
  }
  
  boolean isFirst(PVector vec){
   return vec == vecs.peekFirst(); 
  }
  
  boolean isLast(PVector vec){
   return vec == vecs.peekLast(); 
  }
  
  boolean validDist(PVector vec1, PVector vec2){
    float dist = vec1.dist(vec2);
    return 0 < dist && dist < 1.45; // 1.45 is about sqrt of 2 
  }
}
