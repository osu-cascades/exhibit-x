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
  
  OrbitProperties(double trueAnomaly, double meanMotion) {
    this.trueAnomaly = trueAnomaly;
    this.meanMotion = meanMotion;
  }
  
  public double getTrueAnomaly() {
    return this.trueAnomaly;
  }
  
  public double getMeanMotion() {
    return this.meanMotion;
  }
}

public class PlanetPositionPropagator {
  private HashMap<Planet, OrbitProperties> planetStatistics;
  private LocalDateTime initialDateTime;

  PlanetPositionPropagator() {
    initialDateTime = LocalDate.of(2021, 10, 21).atStartOfDay();
    planetStatistics = new HashMap<Planet, OrbitProperties>();
    
    planetStatistics.put(Planet.MERCURY, new OrbitProperties(Double.valueOf("6.352734960971400E+00"), Double.valueOf("4.736504722869127E-05")));
    planetStatistics.put(Planet.VENUS, new OrbitProperties(Double.valueOf("2.083971624835224E+02"), Double.valueOf("1.854322546920433E-05")));
    planetStatistics.put(Planet.EARTH, new OrbitProperties(Double.valueOf("2.817002767741549E+02"), Double.valueOf("1.142235839791856E-05")));
    planetStatistics.put(Planet.MARS, new OrbitProperties(Double.valueOf("2.244758776974479E+02"), Double.valueOf("6.065462916501094E-06")));
    planetStatistics.put(Planet.JUPITER, new OrbitProperties(Double.valueOf("3.186529983264427E+02"), Double.valueOf("9.612871409182281E-07")));
    planetStatistics.put(Planet.SATURN, new OrbitProperties(Double.valueOf("2.231005450020635E+02"), Double.valueOf("3.847914495623070E-07")));
    planetStatistics.put(Planet.URANUS, new OrbitProperties(Double.valueOf("2.328562044321201E+02"), Double.valueOf("1.351289243051856E-07")));
    planetStatistics.put(Planet.NEPTUNE, new OrbitProperties(Double.valueOf("3.327526623625908E+02"), Double.valueOf("6.843504783397153E-08")));
    
  }
  
  public float getPlanetTrueAnomaly(Planet planet, LocalDateTime datetime) {
    if(this.planetStatistics.containsKey(planet)) {
      OrbitProperties planetStats = this.planetStatistics.get(planet);
      return (float) (planetStats.getTrueAnomaly() + (planetStats.getMeanMotion() * ChronoUnit.SECONDS.between(this.initialDateTime, datetime)));
    } else {
      return 0.0; //TODO throw a real exception
    }
    
  }
}
