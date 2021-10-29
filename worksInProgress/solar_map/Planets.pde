import java.time.*;
import java.time.temporal.ChronoUnit;

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

public class OrbitProperties {
  double trueAnomaly;
  double meanMotion;
  double longAscendingNode;
  double argOfPerifocus;
  
  OrbitProperties(double trueAnomaly, double meanMotion, double longAscendingNode, double argOfPerifocus) {
    this.trueAnomaly = trueAnomaly;
    this.meanMotion = meanMotion;
    this.longAscendingNode = longAscendingNode;
    this.argOfPerifocus = argOfPerifocus;
  }
  
  public double getTrueAnomaly() {
    return this.trueAnomaly;
  }
  
  public double getMeanMotion() {
    return this.meanMotion;
  }
  
  public double getLongAscendingNode() {
    return this.longAscendingNode;
  }
  
  public double getArgOfPerifocus() {
    return this.argOfPerifocus;
  }
}

public class PlanetPositionPropagator {
  private HashMap<Planet, OrbitProperties> planetStatistics;
  private LocalDateTime initialDateTime;

  PlanetPositionPropagator() {
    initialDateTime = LocalDate.of(2021, 10, 21).atStartOfDay();
    planetStatistics = new HashMap<Planet, OrbitProperties>();
    
    // Data from https://ssd.jpl.nasa.gov/horizons
    
    planetStatistics.put(Planet.MERCURY, new OrbitProperties(Double.valueOf("6.352734960971400E+00"), Double.valueOf("4.736504722869127E-05"), Double.valueOf("4.830297004329395E+01"), Double.valueOf("2.919012051388872E+01")));
    planetStatistics.put(Planet.VENUS, new OrbitProperties(Double.valueOf("2.083971624835224E+02"), Double.valueOf("1.854322546920433E-05"), Double.valueOf("7.662135112556078E+01"), Double.valueOf("5.516017500475255E+01")));
    planetStatistics.put(Planet.EARTH, new OrbitProperties(Double.valueOf("2.817002767741549E+02"), Double.valueOf("1.142235839791856E-05"), Double.valueOf("1.890040631169304E+02"), Double.valueOf("2.768104177851159E+02")));
    planetStatistics.put(Planet.MARS, new OrbitProperties(Double.valueOf("2.244758776974479E+02"), Double.valueOf("6.065462916501094E-06"), Double.valueOf("4.949035905669866E+01"), Double.valueOf("2.867247452567173E+02")));
    planetStatistics.put(Planet.JUPITER, new OrbitProperties(Double.valueOf("3.186529983264427E+02"), Double.valueOf("9.612871409182281E-07"), Double.valueOf("1.005089025822603E+02"), Double.valueOf("2.733065560181850E+02")));
    planetStatistics.put(Planet.SATURN, new OrbitProperties(Double.valueOf("2.231005450020635E+02"), Double.valueOf("3.847914495623070E-07"), Double.valueOf("1.135848687815919E+02"), Double.valueOf("3.356712715043411E+02")));
    planetStatistics.put(Planet.URANUS, new OrbitProperties(Double.valueOf("2.328562044321201E+02"), Double.valueOf("1.351289243051856E-07"), Double.valueOf("7.401268950205842E+01"), Double.valueOf("9.544161991059313E+01")));
    planetStatistics.put(Planet.NEPTUNE, new OrbitProperties(Double.valueOf("3.327526623625908E+02"), Double.valueOf("6.843504783397153E-08"), Double.valueOf("1.317174119813044E+02"), Double.valueOf("2.472475804058837E+02")));
    
  }
  
  public float getPlanetTrueAnomaly(Planet planet, LocalDateTime datetime) {
    if(this.planetStatistics.containsKey(planet)) {
      OrbitProperties planetStats = this.planetStatistics.get(planet);
      return (float) (360.0 - (planetStats.getLongAscendingNode() + planetStats.getArgOfPerifocus() + planetStats.getTrueAnomaly() + (planetStats.getMeanMotion() * ChronoUnit.SECONDS.between(this.initialDateTime, datetime))));
    } else {
      return 0.0; //TODO throw a real exception
    }
    
  }
}
