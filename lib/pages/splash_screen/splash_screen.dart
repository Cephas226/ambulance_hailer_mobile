import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ambulance_hailer/utils/CustomTextStyle.dart';
import 'splash_screen_controller.dart';

class SplashScreen extends GetView<SplashScreenController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: GetBuilder<SplashScreenController>(builder: (_) {
          return
            MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                resizeToAvoidBottomInset: false,
                body: Builder(builder: (context){
                  return Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 400,
                          decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage("images/ic_logo.png"),)
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            );
        }),
      ),
    );
  }
}
