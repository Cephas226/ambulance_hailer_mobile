import 'package:ambulance_hailer/Notifications/notification.dart';
import 'package:ambulance_hailer/library/configMaps.dart';
import 'package:ambulance_hailer/models/rideDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io' show Platform;

import '../main.dart';

class PushNotificationService{
  final FirebaseMessaging firebaseMessaging=FirebaseMessaging();

  Future initialize(context) async {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage");
        retrieveRideRequestInfo(getRideRequestId(message),context);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch");
        retrieveRideRequestInfo(getRideRequestId(message),context);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume");
        retrieveRideRequestInfo(getRideRequestId(message),context);
      },
    );
  }
  Future <String> getToken(User userDriver) async {
    String token = await firebaseMessaging.getToken();
    print("this is token : "+token);
    driversRef.child(userDriver.uid).child("token").set(token);
    firebaseMessaging.subscribeToTopic("alldrivers");
    firebaseMessaging.subscribeToTopic("allusers");
  }
  void retrieveRideRequestInfo (String rideRequestId,context)
  {
    newRequestRef.child(rideRequestId)
        .once()
        .then((DataSnapshot dataSnapshot){
      if (dataSnapshot.value!=null)
      {
        double pickupLocationLat = double.parse(dataSnapshot.value['pickup']['latitude'].toString());
        double pickupLocationLong = double.parse(dataSnapshot.value['pickup']['longitude'].toString());
        String pickupAddress =dataSnapshot.value['pickup_address'].toString();

        double dropLocationLat = double.parse(dataSnapshot.value['drop']['latitude'].toString());
        double dropLocationLong = double.parse(dataSnapshot.value['drop']['longitude'].toString());
        String dropAddress =dataSnapshot.value['dropoff_address'].toString();

        String payementMethod = dataSnapshot.value["payment_method"].toString();
        String rider_name = dataSnapshot.value["rider_name"];
        String rider_phone = dataSnapshot.value["rider_phone"];




        RideDetails rideDetails  = RideDetails(null,null, null, null, null, null, null,"");
        rideDetails.ride_request_id =rideRequestId;
        rideDetails.pick_address = pickupAddress;
        rideDetails.drop_address = dropAddress;
        rideDetails.pickup = LatLng(pickupLocationLat, pickupLocationLong);
        rideDetails.drop = LatLng(dropLocationLat, dropLocationLong);
        rideDetails.payment_method =payementMethod;
        rideDetails.rider_name =rider_name;
        rideDetails.rider_phone = rider_phone;

        print('Information ::');
        print(rideDetails.pick_address);
        print(rideDetails.drop_address);

        showDialog(
            context: context,
            barrierDismissible:true,
            builder: (BuildContext context)=>NotificationDialog(rideDetails:rideDetails));
      }
    });
  }

  String getRideRequestId(Map<String,dynamic> message)
   {
     String rideRequestId = "";
     if (Platform.isAndroid){
        rideRequestId = message["data"]["ride_request_id"];
        print("this is Ride Request Id"+rideRequestId);
     }
     else {
       rideRequestId = message["ride_request_id"];
       print("this is Ride Request Id"+rideRequestId);
     }
     return rideRequestId;
  }
}