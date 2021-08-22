import 'package:ambulance_hailer/driver/dashboard/dashboard_page.dart';
import 'package:ambulance_hailer/library/configMaps.dart';
import 'package:ambulance_hailer/pages/authentification/signup.dart';
import 'package:ambulance_hailer/pages/home/home_page.dart';
import 'package:ambulance_hailer/utils/CustomColors.dart';
import 'package:ambulance_hailer/utils/CustomTextStyle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';
import 'authentification_controller.dart';
import 'forgot_password.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var selectedItem;
  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _mobileIndicatifController;
  bool isTextWritten = false;
  var selectedValue = "+233";
  AuthentificationController authentificationController =
      Get.put(AuthentificationController());
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
                child: Container(
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
                  padding: EdgeInsets.only(top: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child: Image(
                          image: AssetImage("images/ic_logo.png"),
                          width: 250,
                          height: 250,
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
                                            left: 8,
                                            right: 32,
                                            top: 6,
                                            bottom: 6),
                                        hintText: "Your email",
                                        hasFloatingPlaceholder: true,
                                        hintStyle: CustomTextStyle
                                            .regularTextStyle
                                            .copyWith(
                                                color: Colors.grey,
                                                fontSize: 12),
                                        labelStyle: CustomTextStyle
                                            .regularTextStyle
                                            .copyWith(
                                                color: Colors.black,
                                                fontSize: 12),
                                      ),
                                      controller: authentificationController
                                          .emailController,
                                      keyboardType: TextInputType.text,
                                    ),
                                    createClearText()
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
                      SizedBox(height: 20),
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
                                            left: 8,
                                            right: 32,
                                            top: 6,
                                            bottom: 6),
                                        hintText: "Enter your password",
                                        hasFloatingPlaceholder: true,
                                        hintStyle: CustomTextStyle
                                            .regularTextStyle
                                            .copyWith(
                                                color: Colors.grey,
                                                fontSize: 12),
                                        labelStyle: CustomTextStyle
                                            .regularTextStyle
                                            .copyWith(
                                                color: Colors.black,
                                                fontSize: 12),
                                      ),
                                      controller: authentificationController
                                          .passwordController,
                                      keyboardType: TextInputType.text,
                                      obscureText: true,
                                    ),
                                    createClearText()
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
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(right: 16, left: 16),
                        child: RaisedButton(
                          onPressed: () {
                            loginAndAuthentificationUser();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Sign In",
                                style: CustomTextStyle.mediumTextStyle.copyWith(
                                    color: Colors.white, fontSize: 14),
                              ),
                              Visibility(
                                  visible:
                                      authentificationController.snapValue ==""
                                          ? false
                                          : true,
                                  child: SpinKitThreeBounce(
                                    color: Colors.white,
                                    size: 20.0,
                                  ))
                            ],
                          ),
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          color: Colors.red,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "or",
                              style: CustomTextStyle.mediumTextStyle.copyWith(
                                  color: Colors.grey.shade600, fontSize: 12),
                            ),
                            margin: EdgeInsets.only(left: 18),
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(right: 16, left: 16),
                        child: RaisedButton(
                          onPressed: () {},
                          child: Text(
                            "Connect with Google Account",
                            style: CustomTextStyle.mediumTextStyle
                                .copyWith(color: Colors.white, fontSize: 14),
                          ),
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24))),
                          color: CustomColors.COLOR_GOOGLE,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(right: 16, left: 16),
                        child: RaisedButton(
                          onPressed: () {},
                          child: Text(
                            "Connect with Facebook Account",
                            style: CustomTextStyle.mediumTextStyle
                                .copyWith(color: Colors.white, fontSize: 14),
                          ),
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24))),
                          color: CustomColors.COLOR_FACEBOOK,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Get.to(ForgotPassword());
                                },
                                child: Container(
                                  child: Text(
                                    "I forgot my password",
                                    style: CustomTextStyle.mediumTextStyle
                                        .copyWith(
                                            color: Colors.grey.shade600,
                                            fontSize: 12),
                                  ),
                                  margin: EdgeInsets.only(left: 18),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(ForgotPassword());
                            },
                            child: Container(
                              width: 40,
                              margin: EdgeInsets.only(right: 10),
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.red, shape: BoxShape.circle),
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      Align(
                          alignment: Alignment.center,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account ? "),
                              GestureDetector(
                                  onTap: () => {Get.to(SignUpPage())},
                                  child: Text("SignUp",
                                      style: GoogleFonts.nunito(
                                        textStyle: TextStyle(
                                            color: Colors.red,
                                            letterSpacing: .1),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      )))
                            ],
                          )),
                      SizedBox(height: 20)
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

  createClearText() {
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
  }

  void loginAndAuthentificationUser() async {
    UserCredential loginResult = (await firebaseAuth
        .signInWithEmailAndPassword(
            email: authentificationController.emailController.text,
            password: authentificationController.passwordController.text)
        .catchError((onError) {
      print(onError.toString());
    }));
    print(loginResult);
    User firebaseUser = loginResult.user;
    print(firebaseUser);
    if (firebaseUser != null) {

      FirebaseAuth.instance.currentUser.uid;
      usersRef.child(FirebaseAuth.instance.currentUser.uid).once().then((snapshot) => {
        snapshot.value["userType"] == "Driver"
            ? Get.off(DashboardDriverPage())
            : Get.off(HomePage()),
      });
      driversRef.child(FirebaseAuth.instance.currentUser.uid).once().then((snapshot) => {
        snapshot.value["userType"] == "Driver"
            ? Get.off(DashboardDriverPage())
            : Get.off(HomePage()),
      });
    }
    authentificationController.controllerReset();
  }

  var border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      borderSide: BorderSide(color: Colors.white, width: 1));
}
