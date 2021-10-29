  
import gab.opencv.*;
import java.awt.Rectangle;
import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;

OpenCV opencv;
Rectangle[] faces;
Kinect kinect;

void setup() {
  opencv = new OpenCV(this, 640, 480);
  size(640, 480, P3D);
  
  kinect = new Kinect(this);
  kinect.initVideo();

  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  faces = opencv.detect();
}

void draw() {
  opencv.loadImage(kinect.getVideoImage());
  //image(opencv.getInput(), 0, 0);
  
  faces = opencv.detect();
  
  if(faces.length > 0) {
    background(0);
    int face = 640 - (faces[0].x) * 2;
    camera(face, height/2, (height/2) / tan(PI/6), face, height/2, 0, 0, 1, 0);
    translate(width/2, height/2, -100);
    stroke(255);
    noFill();
    box(200);
  }
  
  //noFill();
  //stroke(0, 255, 0);
  //strokeWeight(3);
  //for (int i = 0; i < faces.length; i++) {
  //  rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
  //}
}
