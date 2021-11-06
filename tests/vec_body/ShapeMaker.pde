class ShapeMaker {
  LinkedList<PVector> vecs = new LinkedList<PVector>();
  
  ShapeMaker(PVector vec){
    vecs.add(vec);
  }
  
  PShape makeShape(int resolution){
   PShape shape = createShape();  
   shape.beginShape();
   //for(int i=0; i<vecs.size(); i+=resolution){
   //  PVector vec = vecs.get(i);
   //  shape.vertex(width * vec.x/640, height * vec.y/480);
   //}
   for(int i=0; i<3; i++){
     PVector vec = vecs.get(i*(vecs.size()/2) % vecs.size());
     shape.vertex(width * vec.x/640, height * vec.y/480);
   }
   shape.endShape(CLOSE);
   return shape;
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
