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
}

void draw() {
  opencv = new OpenCV(this, kinect.getVideoImage());
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  faces = opencv.detect();
  image(opencv.getInput(), 0, 0);

  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  for (int i = 0; i < faces.length; i++) {
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
  }
}
