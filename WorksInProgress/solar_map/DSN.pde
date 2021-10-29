public class Signal {
  String spacecraftName;
  Float rxPower; // Measured in DBm
  
  Signal(String name, Float rxPower) {
    this.spacecraftName = name;
    this.rxPower = rxPower;
  }
  
  String getName() {
    return this.spacecraftName;
  }
  
  Float getRxPower() {
    return this.rxPower;
  }
}

public class DSNManager {
  XML config;
  
  DSNManager(String configFilePath) {
    this.config = loadXML(configFilePath);
  }
  
  String getSpacecraftName(String codename) {
    XML[] spacecraft = this.config.getChildren("spacecraftMap")[0].getChildren("spacecraft");
    for(int i = 0; i < spacecraft.length; i++) {
      if(spacecraft[i].getString("name").equals(codename.toLowerCase())) {
        return spacecraft[i].getString("friendlyName");
      }
    }
    // Nothing found
    return null;
  }
  
  ArrayList<Signal> getActiveSignals() {
    XML dsnData = loadXML("https://eyes.nasa.gov/dsn/data/dsn.xml");
    XML[] dishes = dsnData.getChildren("dish");
    
    ArrayList<Signal> result = new ArrayList<Signal>();
    
    for(XML dish : dishes) {
      XML[] signals = dish.getChildren("downSignal");
      
      for(XML signal : signals) {
        if(signal.getString("signalType").equals("data")) {
          String name = this.getSpacecraftName(signal.getString("spacecraft"));
          Float power = signal.getFloat("power");
          result.add(new Signal(name, power));
        }
      }
    }
    return result;
  }
}
