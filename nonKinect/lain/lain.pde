import org.openkinect.freenect.*;
import org.openkinect.processing.*;


Kinect kinect;
PImage[] eyes = new PImage[15];
int eyeOpenMin = 5;
int eyeOpenMax= 12;
boolean opening = false;
boolean closing = false;
boolean open = false;
int currentFrame = 0;

void setup(){
  size(1920, 1080);
  frameRate(20);
  kinect = new Kinect(this);
  kinect.initDepth();
  for(int i=0; i<eyes.length; i++){
      eyes[i] = loadImage("eyes_" + (i+1) + ".gif");
  }
  imageMode(CENTER);
}

void draw(){
  background(0);
  textSize(128);
  fill(255, 0, 0);
  if(opening){
     eyesOpening();
  } else if(open){
    eyesOpen();
  } else if (closing){
     eyesClose();
  }
  
  if(!(opening || closing)){
    if (present()){
        if(!open){
          opening = true; 
        }
    } else if (open) {
      closing = true;
      open = false;
    }
  }
  pushMatrix();
  translate(width/2, height/2);
  rotate(PI*1.5);
  image(eyes[currentFrame], 0, 500);
  popMatrix();
  translate(width/2, height/2);
  rotate(PI*1.5);
  scale(1,-1);
  image(eyes[currentFrame], 0, 500);
}

boolean present(){
  int[] depthData = kinect.getRawDepth();
  int total = 0;
  for(int depth : depthData){
    if(depth < 950){
       total++; 
    }
  }
  fill(255,0,0);
  text(total, 200, 200);
  return total > 90000;
}

void eyesOpening(){
  currentFrame++;
  if(currentFrame > eyeOpenMin){
    opening = false;
    open = true;
  }
}

void eyesOpen(){
  currentFrame++;
  if(currentFrame > eyeOpenMax){
    currentFrame = eyeOpenMin;
  }
}

void eyesClose(){
  currentFrame++;
  if(currentFrame >= eyes.length){
    currentFrame = 0;
    closing = false;
  }
}
