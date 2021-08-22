import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:ambulance_hailer/assistant/requestAssistant.dart';
import 'package:ambulance_hailer/library/place_request.dart';
import 'package:ambulance_hailer/models/addresse.dart';
import 'package:ambulance_hailer/pages/DataHandler/appData.dart';
import 'package:provider/provider.dart';
class AssistantMethods {
  static Future<String> searchCoordinateAddress(Position position,context)
  async
  {
    String placeAddress = "";
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey";

    var response= await RequestAssistant.getRequest(url);
    print(response);
    if (response!="failed"){
        placeAddress = response["results"][0]["formatted_address"];
        Address userPickLocation;
        userPickLocation.longitude=position.longitude;
        userPickLocation.latitude=position.latitude;
        userPickLocation.placeName=placeAddress;
        Provider.of<AppData>(context,listen:false).updatePickupLocationAddress(userPickLocation);
    }
    return placeAddress;
  }
  static double createRadomNumber(int num)
  {
    var randomNumber = Random().nextInt(num);
    return  randomNumber.toDouble();
  }
}