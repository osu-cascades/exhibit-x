import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.time.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class solar_map extends PApplet {

float mars_true_anomaly = 238.1211488f;
float mercury_true_anomaly = 6.3527349609f;

public void setup() {
  
  arc(width/2, height/2, 200, 200, radians(270), radians(270 + mars_true_anomaly));
  fill(50,0,0);
  arc(width/2, height/2, 150, 150, radians(270), radians(270 + mercury_true_anomaly));
}


public enum Planet {
  MERCURY,
  VENUS,
  EARTH,
  MARS,
  JUPITER,
  SATURN,
  URANUS,
  NEPTUNE
}

class PlanetPositionPropagator {
  HashMap<Planet, Double> initialMeanAnomalies;
  LocalDate initialDate;
}
  public void settings() {  size(640,480); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "solar_map" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
