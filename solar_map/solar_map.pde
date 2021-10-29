import java.time.*;

PlanetPositionPropagator planetPropagator;

void setup() {
  
  planetPropagator = new PlanetPositionPropagator();
  
  float div_size = ((width) * 0.6) / 8;
  
  size(640,480);
  background(0);
  
  translate(width/2, height/2);
  
  int i = 1;
  for (Planet p : Planet.values()) {
    
    noFill();
    stroke(255, 100);
    circle(0,0,i * div_size);
    
    
    PVector pos = polarToCartesian(radians(planetPropagator.getPlanetTrueAnomaly(p, LocalDateTime.now())), i * (div_size / 2));
    fill(planetColor(p), 255);
    noStroke();
    circle(pos.x, pos.y, 10.0);
    i++;
  }
  fill(#fcba03);
  circle(0, 0, 20.0);
}

PVector polarToCartesian(float theta, float radius) {
    return new PVector(radius * cos(theta), radius * sin(theta));
}

color planetColor(Planet p) {
  switch(p) {
  case MERCURY:
    return color(212, 156, 99);
  case VENUS:
    return color(255, 146, 36);
  case EARTH:
    return color(31, 110, 237);
  case MARS:
    return color(235, 21, 21);
  case JUPITER:
    return color(255, 157, 0);
  case SATURN:
    return color(194, 143, 62);
  default:
    return color(0);
  }
}
