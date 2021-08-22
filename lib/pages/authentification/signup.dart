import 'package:ambulance_hailer/driver/dashboard/dashboard_page.dart';
import 'package:ambulance_hailer/library/configMaps.dart';
import 'package:ambulance_hailer/pages/home/home_controller.dart';
import 'package:ambulance_hailer/pages/home/home_page.dart';
import 'package:ambulance_hailer/utils/CustomTextStyle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import 'authentification_controller.dart';
import 'package:get/get.dart';
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var selectedItem;
  bool isTextWritten = false;
  var selectedValue = "+233";
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final AuthentificationController authentificationController = Get.put(AuthentificationController());
  createCountryCodeList() {
    List<DropdownMenuItem<String>> countryCodeList = new List();
    countryCodeList.add(createDropdownItem("+91"));
    countryCodeList.add(createDropdownItem("+92"));
    countryCodeList.add(createDropdownItem("+93"));
    countryCodeList.add(createDropdownItem("+94"));
    countryCodeList.add(createDropdownItem("+95"));
    countryCodeList.add(createDropdownItem("+96"));
    countryCodeList.add(createDropdownItem("+97"));
    return countryCodeList;
  }

  createDropdownItem(String code) {
    return DropdownMenuItem(
      value: code,
      child: Text(code),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = Get.size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Builder(
            builder: (context) {
              return Card(
                elevation: 4,
                borderOnForeground: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16))),
                margin: EdgeInsets.only(left: 0, right: 0, bottom: 4),
                child:
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(16),
                          bottomLeft: Radius.circular(16)),
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade50, blurRadius: 5),
                      ]),
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child: Image(
                          image: AssetImage("images/ic_logo.png"),
                          width: 150,
                          height: 150,
                        ),
                      ),
                      SizedBox(height: 14),
                      Container(
                        margin: EdgeInsets.only(left: 16, top: 4),
                        child: Text(
                          "Enter your mobile number to Login or Register",
                          style: CustomTextStyle.mediumTextStyle.copyWith(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(height: 14),
                      Container(
                        margin: EdgeInsets.only(right: 14, left: 14),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    TextField(
                                      decoration: InputDecoration(
                                        border: border,
                                        enabledBorder: border,
                                        focusedBorder: border,
                                        contentPadding: EdgeInsets.only(
                                            left: 8, right: 32, top: 6, bottom: 6),
                                        hintText: "Your name",
                                        hasFloatingPlaceholder: true,
                                        hintStyle: CustomTextStyle.regularTextStyle
                                            .copyWith(
                                            color: Colors.grey, fontSize: 12),
                                        labelStyle: CustomTextStyle.regularTextStyle
                                            .copyWith(
                                            color: Colors.black, fontSize: 12),
                                      ),
                                      controller: authentificationController.nameController,
                                      keyboardType: TextInputType.text,
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                    border: Border.all(
                                        width: 1, color: Colors.grey.shade400)),
                              ),
                              flex: 100,
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 14),
                      Container(
                        margin: EdgeInsets.only(right: 14, left: 14),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    TextField(
                                      decoration: InputDecoration(
                                        border: border,
                                        enabledBorder: border,
                                        focusedBorder: border,
                                        contentPadding: EdgeInsets.only(
                                            left: 8, right: 32, top: 6, bottom: 6),
                                        hintText: "Your email",
                                        hasFloatingPlaceholder: true,
                                        hintStyle: CustomTextStyle.regularTextStyle
                                            .copyWith(
                                            color: Colors.grey, fontSize: 12),
                                        labelStyle: CustomTextStyle.regularTextStyle
                                            .copyWith(
                                            color: Colors.black, fontSize: 12),
                                      ),
                                      controller: authentificationController.emailController,
                                      keyboardType: TextInputType.text,
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                    border: Border.all(
                                        width: 1, color: Colors.grey.shade400)),
                              ),
                              flex: 100,
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 14),
                      Container(
                        margin: EdgeInsets.only(right: 14, left: 14),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    TextFormField(
                                      initialValue: '+233',
                                      readOnly:true,
                                      decoration: InputDecoration(
                                        border: border,
                                        enabledBorder: border,
                                        focusedBorder: border,
                                        contentPadding: EdgeInsets.only(
                                            left: 8,
                                            right: 32,
                                            top: 6,
                                            bottom: 6),
                                        hintText: "Mobile Number",
                                        hasFloatingPlaceholder: true,
                                        hintStyle: CustomTextStyle
                                            .regularTextStyle
                                            .copyWith(
                                            color: Colors.grey, fontSize: 12),
                                        labelStyle: CustomTextStyle
                                            .regularTextStyle
                                            .copyWith(
                                            color: Colors.black,
                                            fontSize: 12),
                                      ),
                                      onChanged: (value) {
                                        if (value.trim().length > 0) {
                                          setState(() {
                                            this.isTextWritten = true;
                                          });
                                        } else {
                                          this.isTextWritten = false;
                                        }
                                      },
                                      //controller: _mobileIndicatifController,
                                      keyboardType: TextInputType.phone,
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                    border: Border.all(
                                        width: 1, color: Colors.grey.shade400)),
                              ),
                              flex: 30,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Container(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    TextField(
                                      decoration: InputDecoration(
                                        border: border,
                                        enabledBorder: border,
                                        focusedBorder: border,
                                        contentPadding: EdgeInsets.only(
                                            left: 8,
                                            right: 32,
                                            top: 6,
                                            bottom: 6),
                                        hintText: "00 00 00 00 00",
                                        hasFloatingPlaceholder: true,
                                        hintStyle: CustomTextStyle
                                            .regularTextStyle
                                            .copyWith(
                                            color: Colors.grey, fontSize: 12),
                                        labelStyle: CustomTextStyle
                                            .regularTextStyle
                                            .copyWith(
                                            color: Colors.black,
                                            fontSize: 12),
                                      ),
                                      onChanged: (value) {
                                        if (value.trim().length > 0) {
                                          setState(() {
                                            this.isTextWritten = true;
                                          });
                                        } else {
                                          this.isTextWritten = false;
                                        }
                                      },
                                      controller: authentificationController.phoneController,
                                      keyboardType: TextInputType.phone,
                                    ),
                                    //createClearText()
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                    border: Border.all(
                                        width: 1, color: Colors.grey.shade400)),
                              ),
                              flex: 100,
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 14),
                      Container(
                        margin: EdgeInsets.only(right: 14, left: 14),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    TextField(
                                      decoration: InputDecoration(
                                        border: border,
                                        enabledBorder: border,
                                        focusedBorder: border,
                                        contentPadding: EdgeInsets.only(
                                            left: 8, right: 32, top: 6, bottom: 6),
                                        hintText: "Enter your password",
                                        hasFloatingPlaceholder: true,
                                        hintStyle: CustomTextStyle.regularTextStyle
                                            .copyWith(
                                            color: Colors.grey, fontSize: 12),
                                        labelStyle: CustomTextStyle.regularTextStyle
                                            .copyWith(
                                            color: Colors.black, fontSize: 12),
                                      ),
                                      controller: authentificationController.passwordController,
                                      keyboardType: TextInputType.text,
                                      obscureText: isTextWritten,
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                    border: Border.all(
                                        width: 1, color: Colors.grey.shade400)),
                              ),
                              flex: 100,
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 14),
                      Align(
                        alignment: Alignment.center,
                        child:  GetBuilder<HomeController>(
                          id: "5",
                          builder: (_) => ToggleButtons(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                child:
                                Image(image: AssetImage('images/ambulance.png')),
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                child:
                                Image(image: AssetImage('images/avatar.png')),
                              )
                            ],
                            //borderRadius: BorderRadius.circular(50),
                            color: Color(0xffeeeeee),
                            renderBorder: false,
                            fillColor: Colors.red.shade400,
                            splashColor: Color(0xffffc045),
                            constraints: BoxConstraints.expand(
                                height: size.width * 0.14, width: size.width * 0.14),
                            isSelected: authentificationController.selectedToggleUserType,
                            onPressed: onToggledGender,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(height: 20),
                      Visibility(
                          visible: authentificationController.selectedToggleUserType.first ? true : false,
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 14, left: 14),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: <Widget>[
                                            TextField(
                                              decoration: InputDecoration(
                                                border: border,
                                                enabledBorder: border,
                                                focusedBorder: border,
                                                contentPadding: EdgeInsets.only(
                                                    left: 8, right: 32, top: 6, bottom: 6),
                                                hintText: "Your Car Model",
                                                hasFloatingPlaceholder: true,
                                                hintStyle: CustomTextStyle.regularTextStyle
                                                    .copyWith(
                                                    color: Colors.grey, fontSize: 12),
                                                labelStyle: CustomTextStyle.regularTextStyle
                                                    .copyWith(
                                                    color: Colors.black, fontSize: 12),
                                              ),
                                              controller: authentificationController.carModelController,
                                              keyboardType: TextInputType.text,
                                            ),
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(4)),
                                            border: Border.all(
                                                width: 1, color: Colors.grey.shade400)),
                                      ),
                                      flex: 100,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 14),
                              Container(
                                margin: EdgeInsets.only(right: 14, left: 14),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: <Widget>[
                                            TextField(
                                              decoration: InputDecoration(
                                                border: border,
                                                enabledBorder: border,
                                                focusedBorder: border,
                                                contentPadding: EdgeInsets.only(
                                                    left: 8, right: 32, top: 6, bottom: 6),
                                                hintText: "Car Number",
                                                hasFloatingPlaceholder: true,
                                                hintStyle: CustomTextStyle.regularTextStyle
                                                    .copyWith(
                                                    color: Colors.grey, fontSize: 12),
                                                labelStyle: CustomTextStyle.regularTextStyle
                                                    .copyWith(
                                                    color: Colors.black, fontSize: 12),
                                              ),
                                              controller: authentificationController.carNumberController,
                                              keyboardType: TextInputType.text,
                                            ),
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(4)),
                                            border: Border.all(
                                                width: 1, color: Colors.grey.shade400)),
                                      ),
                                      flex: 100,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(right: 16, left: 16),
                        child: RaisedButton(
                          onPressed: () {registerNewUser();
                            // Get.to(HomePage());
                          },
                          child: Text(
                            "Sign Up",
                            style: CustomTextStyle.mediumTextStyle
                                .copyWith(color: Colors.white, fontSize: 14),
                          ),
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  onToggledGender(int index) {
    if (index == 0) {
      authentificationController.selectedToggleUserType[index] = !authentificationController.selectedToggleUserType[index];
      if (authentificationController.selectedToggleUserType[index] == true) {
        setState(() {
          authentificationController.selectedToggleUserType[1] = false;
        });
      }
    }
    if (index == 1) {
      authentificationController.selectedToggleUserType[index] = !authentificationController.selectedToggleUserType[index];
      if (authentificationController.selectedToggleUserType[index] == true) {
        setState(() {
          authentificationController.selectedToggleUserType[0] = false;
        });
      }
    }
  }
/*  createClearText() {
    if (isTextWritten) {
      return Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
          onTap: () {
            _mobileNumberController.clear();
            setState(() {
              isTextWritten = false;
            });
          },
          child: Container(
            margin: EdgeInsets.only(right: 8),
            width: 16,
            height: 16,
            decoration: BoxDecoration(
                color: Colors.grey.shade400, shape: BoxShape.circle),
            child: Icon(
              Icons.close,
              size: 14,
              color: Colors.white,
            ),
            alignment: Alignment.center,
          ),
        ),
      );
    } else {
      return Align(
        alignment: Alignment.topRight,
        child: Container(),
      );
    }
  }*/
  void registerNewUser() async{
    final UserCredential authResult = (await firebaseAuth.createUserWithEmailAndPassword(email: authentificationController.emailController.text, password: authentificationController.passwordController.text));
    final User firebaseUser = authResult.user;
    if (firebaseUser != null){
      if (authentificationController.selectedToggleUserType.first){
        Map userDataMap ={
          "name":authentificationController.nameController.text.trim(),
          "email":authentificationController.emailController.text.trim(),
          "phone":authentificationController.phoneController.text.trim(),
          "userType":authentificationController.selectedToggleUserType.first?"Driver":"Rider",
        };
        Map carDataMap ={
          "carModel":authentificationController.carModelController.text,
          "carNumber":authentificationController.carNumberController.text
        };
        currentfirebaseDriver = firebaseUser;
        driversRef.child(firebaseUser.uid).set(userDataMap).onError((error, stackTrace) => print(error));
        driversRef.child(firebaseUser.uid).child("car_details").set(carDataMap).onError((error, stackTrace) => print(error));
        Get.off(DashboardDriverPage());
      }
      else {
        Map userDataMap ={
          "name":authentificationController.nameController.text.trim(),
          "email":authentificationController.emailController.text.trim(),
          "phone":authentificationController.phoneController.text.trim(),
          "userType":authentificationController.selectedToggleUserType.first?"Driver":"Rider",
        };
        currentfirebaseUser = firebaseUser;
        usersRef.child(firebaseUser.uid).set(userDataMap).onError((error, stackTrace) => print(error));
        Get.off(HomePage());
      }
      authentificationController.controllerReset();
    }
    else {
      print("error");
    }
    /*if (authentificationController.validateCreds()) {
      final UserCredential authResult = (await firebaseAuth.createUserWithEmailAndPassword(email: authentificationController.emailController.text, password: authentificationController.passwordController.text)
          .catchError((errMsg){
        print(errMsg);
      }));
      print(authResult);

    }*/
  }
  var border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      borderSide: BorderSide(color: Colors.white, width: 1));
}
