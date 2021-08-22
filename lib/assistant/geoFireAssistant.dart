import 'package:ambulance_hailer/models/nearbyAvailableDriver.dart';

class GeoFireAssistant {
  static List<NearbyAvailableDrivers> nearbyAvailableList = [];

  static void removeFromList(String key){
    int index=nearbyAvailableList.indexWhere((element) => element.key==key);
    nearbyAvailableList.removeAt(index);
  }
  static void updateDriverNearbyLocation(NearbyAvailableDrivers driver){
    int index = nearbyAvailableList.indexWhere((element) => element.key==driver.key);
    nearbyAvailableList[index].latitude=driver.latitude;
    nearbyAvailableList[index].longitude=driver.longitude;
  }
}