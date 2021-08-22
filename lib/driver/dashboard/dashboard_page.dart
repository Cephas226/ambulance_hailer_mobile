import 'dart:convert';

import 'package:ambulance_hailer/driver/home_driver/home_driver_page.dart';
import 'package:ambulance_hailer/library/configMaps.dart';
import 'package:ambulance_hailer/pages/authentification/login.dart';
import 'package:ambulance_hailer/pages/home/home_page.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:get/get.dart";
class DashboardDriverPage extends StatefulWidget {

  @override
  _DashboardDriverPageState createState() => _DashboardDriverPageState();
}

class _DashboardDriverPageState extends State<DashboardDriverPage> {
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();

  }
  changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Theme.of(context).primaryColor,
      body: Scaffold(
        body: Stack(
          children: <Widget>[
            Align(child: _buildBottomBar(),
              alignment: Alignment.bottomCenter,
            ),
          ],

        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return
      Scaffold(
        backgroundColor: Colors.grey[100],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Get.off(LoginPage());
          },
          child: Icon(Icons.power_settings_new),
          backgroundColor: Colors.red,
        ),
        floatingActionButtonLocation:
        FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BubbleBottomBar(
          opacity: 0.2,
          backgroundColor: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.0),
          ),
          currentIndex: currentIndex,
          hasInk: true,
          inkColor: Colors.black12,
          hasNotch: true,
          fabLocation: BubbleBottomBarFabLocation.end,
          onTap: changePage,
          items: [
            BubbleBottomBarItem(
              backgroundColor: Colors.red,
              icon: Icon(
                Icons.dashboard,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.dashboard,
                color: Colors.red,
              ),
              title: Text('Home'),
            ),
            BubbleBottomBarItem(
              backgroundColor: Colors.indigo,
              icon: Icon(
                Icons.credit_card,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.credit_card,
                color: Colors.indigo,
              ),
              title: Text('Earning'),
            ),
            BubbleBottomBarItem(
              backgroundColor: Colors.deepPurple,
              icon: Icon(
                Icons.star_rate_outlined,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.star_rate_outlined,
                color: Colors.deepPurple,
              ),
              title: Text('Rating'),
            ),
            BubbleBottomBarItem(
              backgroundColor: Colors.deepPurple,
              icon: Icon(
                Icons.person_pin_sharp,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.person_pin_sharp,
                color: Colors.deepPurple,
              ),
              title: Text('Account'),
            ),
          ],
        ),
        body: (currentIndex == 0)
            ?  Center(
          child: Container(
            child: HomeDriverPage(),
          ),
        )
            : (currentIndex == 1)
            ? Center(
          child: Container(
            child: Text("Earning page"),
          ),
        )
            : (currentIndex == 2)
            ? Center(
          child: Container(
            child: Text("Rating page"),
          ),
        )
            : Center(
          child: Container(
            child: Text("Account page"),
          ),
        ),

      );
  }

}

