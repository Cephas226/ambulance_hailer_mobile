import 'package:ambulance_hailer/driver/dashboard/dashboard_page.dart';
import 'package:ambulance_hailer/pages/authentification/login.dart';
import 'package:ambulance_hailer/pages/home/home_page.dart';
import 'package:ambulance_hailer/pages/home/home_pagex.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../main.dart';
class SplashScreenController extends GetxController {

  @override
  void onInit() async {
    super.onInit();
    Future.delayed(Duration(seconds: 5), () {
      print("After 5 seconds");
      if ( FirebaseAuth.instance.currentUser==null){
        Get.off(LoginPage());
      }
     else {
        FirebaseAuth.instance.currentUser.uid;
        usersRef.child(FirebaseAuth.instance.currentUser.uid).once().then((snapshot) => {
          snapshot.value["userType"] == "Driver"
              ? Get.off(DashboardDriverPage())
              : Get.off(MapView()),
        });
        driversRef.child(FirebaseAuth.instance.currentUser.uid).once().then((snapshot) => {
          snapshot.value["userType"] == "Driver"
              ? Get.off(DashboardDriverPage())
              : Get.off(MapView()),
        });
      }
      //Get.offNamedUntil('/login', (route) => false);
      /*usersRef.child(firebaseUser.uid).once().then((snapshot) => {
        snapshot.value["userType"] == "Driver"
            ? Get.to(DashboardDriverPage())
            : Get.to(HomePage()),
        authentificationController.snapValue = snapshot.value,
      });*/
    });
  }
}