import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ambulance_hailer/utils/CustomColors.dart';
import 'package:ambulance_hailer/utils/CustomTextStyle.dart';
import 'package:ambulance_hailer/utils/DottedLine.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body:
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 24,
            ),
            Stack(
              key: Key("AppBar"),
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.keyboard_backspace),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: Colors.black,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(top: 16),
                    alignment: Alignment.center,
                    child: Text(
                      "Profile",
                      style: CustomTextStyle.mediumTextStyle.copyWith(fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      "CONTACT DETAILS",
                      style: CustomTextStyle.mediumTextStyle
                          .copyWith(color: Colors.red),
                    ),
                    margin: EdgeInsets.only(left: 16, top: 12),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16, top: 12),
                    child: Text(
                      "Name",
                      style: CustomTextStyle.regularTextStyle
                          .copyWith(color: Colors.red),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 16),
                        child: Text("Cephas ZOUBGA",
                            style: CustomTextStyle.mediumTextStyle),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16, top: 16),
                    child: Text(
                      "Mobile Number",
                      style: CustomTextStyle.regularTextStyle
                          .copyWith(color: Colors.red),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 16),
                        child: Text("+233 71 87 86 729",
                            style: CustomTextStyle.mediumTextStyle),
                      ),
                    ],
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 16, top: 12),
                    child: Text(
                      "Email",
                      style: CustomTextStyle.regularTextStyle
                          .copyWith(color: Colors.red),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16, top: 4),
                    child: Text("cephaszoubga@gmail.com",
                        style: CustomTextStyle.mediumTextStyle),
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
                          borderRadius: BorderRadius.all(Radius.circular(24))),
                      color: CustomColors.COLOR_GOOGLE,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child:
                    Padding(
                      padding: const EdgeInsets.only(top: 400.0),
                      child: InkWell(
                        onTap: (){},
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(FontAwesomeIcons.userLock,
                                      color: Colors.redAccent),
                                  SizedBox(width: 10),
                                  Text(
                                    "Modify password",
                                    style: CustomTextStyle.mediumTextStyle.copyWith(
                                        color: Colors.black, fontSize: 20),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(FontAwesomeIcons.signOutAlt,
                                      color: Colors.redAccent),
                                  SizedBox(width: 10),
                                  Text(
                                    "Log out",
                                    style: CustomTextStyle.mediumTextStyle.copyWith(
                                        color: Colors.black, fontSize: 20),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ],
                          )
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
