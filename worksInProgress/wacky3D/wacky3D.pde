final static int SHAPE_SIZE = 100;
final static int[] COLORS = {#0C6170, #37BEB0, #A4E5E0, #DBF5F0};
PShape[] shapes = new PShape[COLORS.length];
int tmp = 0;

void setup() {
  size(1000, 1000, P3D); 
  fill(COLORS[tmp]);
  for(int i=0; i<shapes.length; i++)
    shapes[i] = polygon(3+i,SHAPE_SIZE); 
}

void draw() {
  background(250);
  fill(COLORS[tmp]);
  for(int x=0; x<width/SHAPE_SIZE; x++)
    for(int y=0; y<height/SHAPE_SIZE; y++)
       shape(shapes[tmp], (x+0.5)*SHAPE_SIZE, (y+0.5)*SHAPE_SIZE);
}

PShape polygon(int sides, int size){
  float x = 0;
  float y = size;
  float rad = PI*2/sides;
  PShape s = createShape();
  s.beginShape();
  for(int i=0; i<sides; i++){
    float tmp = x * cos(rad) + y * sin(rad);
    y = y * cos(rad) - x * sin(rad);
    x = tmp;
    s.vertex(x,y);
  }
  s.endShape(CLOSE);
  return s;
}

void keyPressed() {
  if (key == CODED) {
      if (keyCode == UP) {
        tmp++;
      } else if (keyCode == DOWN) {
        tmp--;
      }
  }
}
