import 'package:ambulance_hailer/library/configMaps.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {

  DatabaseReference rideRequestRef;
  @override
  void dispose() {
    super.dispose();
  }
  @override
  onInit() async {
    super.onInit();
  }

  void cancelRideRequest(){
    rideRequestRef.remove();
  }
  void makeDriverOfflineNow(){
    Geofire.removeLocation(currentfirebaseUser.uid);
    rideRequestRef.onDisconnect();
    rideRequestRef.remove();
    rideRequestRef=null;
  }
}