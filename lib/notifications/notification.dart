import 'package:ambulance_hailer/assistant/assistantMethods.dart';
import 'package:ambulance_hailer/driver/driver_screen/newRideScreen.dart';
import 'package:ambulance_hailer/main.dart';
import 'package:ambulance_hailer/models/rideDetails.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class NotificationDialog extends StatelessWidget{
  final RideDetails rideDetails;
 NotificationDialog({this.rideDetails});

  @override
  Widget build(BuildContext context)
  {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.transparent,
      elevation: 1.0,
      child: Container(
        margin: EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
         mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height:30.0),
            Image.asset("images/car.png",width: 120.0),
            SizedBox(height:30.0),
            Text("New Ride Request",style: TextStyle(fontFamily: "Brand-Bold",fontSize:18.0),),
            SizedBox(height:30.0),
            Padding(
              padding: EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("images/car.png",height: 16.0,width: 16.0),
                      SizedBox(height:20.0),
                      Expanded(child: Container(child: Text(rideDetails.pick_address,style: TextStyle(fontSize:18.0),),))
                    ],
                  ),
                  SizedBox(height:15.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("images/car.png",height: 16.0,width: 16.0),
                      SizedBox(height:20.0),
                      Expanded(child: Container(child: Text(rideDetails.drop_address,style: TextStyle(fontSize:18.0),),))
                    ],
                  ),
                  SizedBox(height:15.0),
                ],
              ),
            ),
            SizedBox(height:20.0),
            Divider(height:15.0,color:Colors.black,thickness: 2.0),
            SizedBox(height:8),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(onPressed:()=>{},
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color:Colors.red)),
                           color:Colors.white,
                           textColor: Colors.black,
                           padding: EdgeInsets.all(8.0),
                           child: Text("Cancel".toUpperCase(),style: TextStyle(fontSize: 14.0))),
                      SizedBox(height:8),
                      RaisedButton(onPressed:()=>{
                        checkAvailabilityChek(),
                      }, shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color:Colors.green)),
                          color:Colors.white,
                          textColor: Colors.black,
                          padding: EdgeInsets.all(8.0),
                          child: Text("Accept".toUpperCase(),style: TextStyle(fontSize: 14.0))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void checkAvailabilityChek(){

    rideRequestRef.once().then((DataSnapshot dataSnapshot){
     Get.back();
      String theRideId = "";
      if (dataSnapshot.value !=null){
        theRideId =dataSnapshot.value.toString();
    }
      else {
        print("Ride not exist");
      }
      if(theRideId == rideDetails.ride_request_id){
          rideRequestRef.set("accepted");
          AssistantMethods.disableHomeDriveLiveLocationUpdates();
          Get.to(NewRidePage(rideDetails: rideDetails));
      }
      else if (theRideId == "canceled"){
        print("Ride has been cancelled");
      }
      else if (theRideId == "timeout"){
        print("Ride has been cancelled");
      }
      else {
        print("Ride not exist");
      }
    });
  }
}