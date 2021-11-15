import java.util.*;

void aStar(PVector start, PVector end, int blocks){
   LinkedList<Cell> open = new ArrayList<PVector>();
   LinkedList<PVector> closed = new ArrayList<PVector>();
   open.add(new Cell(start, 0));
   
   while(open.size() > 0){
      for() 
   }
   
}

class Cell {
  PVector vec;
  int f;
  
  Cell(PVector vec, int f){
    this.vec = vec;
    this.f = f;
  }
  
}
