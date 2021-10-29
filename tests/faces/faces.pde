import gab.opencv.*;
import org.openkinect.freenect.*;
import org.openkinect.processing.*;

import java.awt.Rectangle;

OpenCV opencv;
Kinect kinect;
Rectangle[] faces;

void setup() {
  size(640, 480);
  kinect = new Kinect(this);
  kinect.initVideo();
  opencv = new OpenCV(this,640, 480);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE); 
}

void draw() {
  opencv.loadImage(kinect.getVideoImage());
  faces = opencv.detect();
  image(opencv.getInput(), 0, 0);

  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  for (int i = 0; i < faces.length; i++) {
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
  }
}
