

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ambulance_hailer/pages/home/home_controller.dart';
import 'package:get/get.dart';

import 'CustomTextStyle.dart';

class BottomSheetContent extends GetView<HomeController> {
  bool isDismissible;
  DatabaseReference rideRequestRef;
  BottomSheetContent({this.isDismissible});

  @override
  Widget build(BuildContext context) {
    return
      Align(
        alignment: Alignment.bottomCenter,
        child:
        Container(
          width: double.infinity,
          height: 240,
          child: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      topLeft: Radius.circular(16)),
                  color: Colors.white,
                ),
                margin: EdgeInsets.only(top: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 70,
                    ),
                    SpinKitThreeBounce(
                      color: Colors.redAccent,
                      size: 50.0,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 4, right: 4, top: 2),
                      child: Text(
                        "Requesting your ride please wait...",
                        style: CustomTextStyle.regularTextStyle
                            .copyWith(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Flexible(
                        child:
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 16),
                          child: RaisedButton(
                            onPressed: () {
                              print("closed");
                              rideRequestRef.remove();
                            },
                            color: Colors.red,
                            child: Text(
                              "Cancel Trip",
                              style: CustomTextStyle.mediumTextStyleWhite,
                            ),
                          ),
                        )
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/taxi.png")),
                      borderRadius:
                      BorderRadius.all(Radius.circular(10)),color: Colors.white),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child:
                Container(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 100,
                    margin: EdgeInsets.only(top: 70),
                    height: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        color: Colors.black.withOpacity(0.5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "4.5",
                          style: CustomTextStyle.boldTextStyle.copyWith(
                              color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellowAccent.shade700,
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
  }

  void cancelRideRequest(){
    rideRequestRef.remove();
  }
}
