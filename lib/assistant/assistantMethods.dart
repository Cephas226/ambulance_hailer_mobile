import 'dart:convert';
import 'dart:math';

import 'package:ambulance_hailer/library/configMaps.dart';
import 'package:ambulance_hailer/models/directionDetails.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ambulance_hailer/assistant/requestAssistant.dart';
import 'package:ambulance_hailer/library/place_request.dart';
import 'package:ambulance_hailer/models/addresse.dart';
import 'package:ambulance_hailer/pages/DataHandler/appData.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import "package:http/http.dart" as http;
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

 static Future <DirectionDetails> obtainPlaceDirectionDetails(LatLng initialPosition,LatLng finalPosition) async
  {

    String directionUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$apiKey";

    var res= await RequestAssistant.getRequest(directionUrl);
    print(res);
    if (res=="failed"){
     return null;
    }
    DirectionDetails directionDetails =DirectionDetails(0, 0, 0, "", "", "", "");
    directionDetails.encodePoints=res["routes"][0]["overview_polyline"]["points"];
    directionDetails.distanceText=res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.directionValue=res["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.durationText=res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue=res["routes"][0]["legs"][0]["duration"]["value"];

  return directionDetails;
  }


  static double createRadomNumber(int num)
  {
    var randomNumber = Random().nextInt(num);
    return  randomNumber.toDouble();
  }
  static void disableHomeDriveLiveLocationUpdates()
  {
    homeDriverStreamSubcription.pause();
    Geofire.removeLocation(currentfirebaseDriver.uid);
  }
  static void enableHomeDriveLiveLocationUpdates()
  {
    homeDriverStreamSubcription.resume();
    Geofire.setLocation
      (
        currentfirebaseDriver.uid,
        currentPosition.latitude,
        currentPosition.longitude
    );
  }
  static int calculateFares(DirectionDetails directionDetails)
  {
    double timeTravelFare = (directionDetails.durationValue/60)*0.20;
    double distancTravelFare = (directionDetails.distanceValue/100)*0.20;
    double totalFareAmount = timeTravelFare + distancTravelFare;

    return totalFareAmount.truncate();
  }

  static sendNotificationToDriver(String token,context,String rideRequestId)
  async {
    var destination = Provider.of<AppData>(context,listen: false).dropOffLocation;
     Map<String,String>headerMap =
     {
       'Content-Type': 'application/json',
       'Authorization': serverToken,
     };
     Map notificationMap =
     {
       'body': 'DropOff Address',
       'title': 'New Ride Request'
     };
     Map dataMap =

     {
       'click_action': 'FLUTTER_NOTIFICATION_CLICK',
       'id': '1',
       'status': 'done',
       'ride_request_id':rideRequestId
     };
     Map sendNotification =
     {
       "notification":notificationMap,
       "data" : dataMap,
       "priority" :"high",
       "to" :token,
     };
     var res = await http.post(
       "https://fcm.googleapis.com/fcm/send",
        headers: headerMap,
        body: jsonEncode(sendNotification),
     );
     print(res);
  }
}