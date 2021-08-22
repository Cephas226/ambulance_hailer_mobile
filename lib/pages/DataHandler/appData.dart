import 'package:flutter/cupertino.dart';
import 'package:ambulance_hailer/models/addresse.dart';

class AppData extends ChangeNotifier
{
  Address pickUpLocation;
  Address dropOffLocation;
   void updatePickupLocationAddress(Address pickAddress){
     pickUpLocation=pickAddress;
     notifyListeners();
   }
  void updateDropOffLocationAddress(Address pickAddress){
    dropOffLocation=pickAddress;
    notifyListeners();
  }
}
