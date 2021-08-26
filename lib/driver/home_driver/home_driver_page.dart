import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:ambulance_hailer/Notifications/pushNotificationService.dart';
import 'package:ambulance_hailer/main.dart';
import 'package:ambulance_hailer/models/allUsers.dart';
import 'package:ambulance_hailer/models/drivers.dart';
import 'package:ambulance_hailer/pages/home/home_controller.dart';
import 'package:ambulance_hailer/utils/CustomTextStyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:get/get.dart';
import 'package:ambulance_hailer/assistant/assistantMethods.dart';
import 'package:ambulance_hailer/library/configMaps.dart';
import 'package:ambulance_hailer/library/place_request.dart';
import 'package:ambulance_hailer/pages/DataHandler/appData.dart';
import 'package:ambulance_hailer/pages/components/menu.dart';
import 'package:ambulance_hailer/pages/components/menu1.dart';
import 'package:ambulance_hailer/pages/trip/request_driver_trip.dart';
import 'package:ambulance_hailer/pages/trip/payment_dialog.dart';
import 'package:ambulance_hailer/utils/bottom_sheet.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';
import 'home_driver_controller.dart';
import 'package:provider/provider.dart';

class HomeDriverPage extends StatefulWidget {
  @override
  _HomeDriverPageState createState() => _HomeDriverPageState();
}

class _HomeDriverPageState extends State<HomeDriverPage> {
  Set<Marker> markers = new Set();
  HomeController hController = Get.put(HomeController());
  String _placeDistance;
  CameraPosition initialLocation = CameraPosition(target: LatLng(33.609434051916494, -7.623460799015407),zoom: 14.4746);
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  LatLng initialPosition = LatLng(33.609434051916494, -7.623460799015407);
  //GoogleMapController mapController;
  BitmapDescriptor bitmapDescriptor;
  String placeDistancex;
  String startAddress = '';
  String destinationAddress = '';
  RxString currentAddress = ''.obs;
  PolylinePoints polylinePoints;
  TextEditingController startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();
  final startAddressFocusNode = FocusNode();
  final destinationAddressFocusNode = FocusNode();
  final firestore = FirebaseFirestore.instance;
  Geoflutterfire geo = Geoflutterfire();
  BehaviorSubject<double> radius = BehaviorSubject.seeded(100.0);
  Stream<dynamic> query;

  // Subscription
  StreamSubscription subscription;
  Color driverStatusColor=Colors.black;
  String driversStatusText='Offline Now - Go online';
  bool isDriverAvailable=false;
  //----
  GoogleMapController newGoogleMapController;
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    GoogleMapsServices.getCurrentOnLineUserInfo();
    String pathToReference = "availableDriver";
    Geofire.initialize(pathToReference);
    getCurrentDriverInfo();
  }
  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
          print(position);
      setState(() {
        currentPosition = position;
      newGoogleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 14.0,
            ),
          ),
        );
      });
      await _getAddress();
    }).catchError((e) {
      print(e);
    });
  }
  _getAddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);

      Placemark place = p[0];

      setState(() {currentAddress.value =
            "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        startAddressController.text = currentAddress.value ;
        startAddress = currentAddress.value ;
      });
    } catch (e) {
      print(e);
    }
  }
  void getCurrentDriverInfo() async {
    currentfirebaseDriver = await FirebaseAuth.instance.currentUser;

    driversRef.child(currentfirebaseDriver.uid).once().then((DataSnapshot dataSnapshot){
      if (dataSnapshot.value!=null){
        driversInformation = Drivers.fromSnapshot(dataSnapshot);
      }
    });
    PushNotificationService pushNotificationService =  PushNotificationService();
    pushNotificationService.initialize(context);
    pushNotificationService.getToken(currentfirebaseDriver);
  }
  @override
  Widget build(BuildContext context) {
    Size size = Get.size;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            child: GetBuilder<HomeController>(
              builder: (controller) {
                return Container(
                    child:
                  Stack(
         children: <Widget>[
                  Container(
                      height: double.infinity,
                      child:
                      GoogleMap(
                        //markers: Set<Marker>.of(markers),
                        initialCameraPosition: initialLocation,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        mapType: MapType.normal,
                        onMapCreated: (GoogleMapController controller) {
                          newGoogleMapController = controller;
                          _getCurrentLocation();
                        },
                      )),
                      SafeArea(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child:
                      Container(
                        color: Colors.black12,
                        width:double.infinity,
                        height: size.height*0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: ()async {
                                if (isDriverAvailable!=true){
                                  print('Online Now');
                                  makeDriverOnlineNow();
                                  getLocationLiveUpdates();
                                  setState(() {
                                    driverStatusColor = Colors.green;
                                    driversStatusText="Online Now";
                                    isDriverAvailable=true;
                                  });
                                }
                                else {
                                  print('Offline Now - Go online');
                                  setState(() {
                                    driverStatusColor = Colors.black;
                                    driversStatusText="Offline Now - Go online";
                                    isDriverAvailable=false;
                                  });
                                  hController.makeDriverOfflineNow();
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      driversStatusText,
                                      style: CustomTextStyle.mediumTextStyle.copyWith(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Icon(
                                      Icons.phone_android,
                                      color: Colors.white,
                                    )
                                  ],
                                )
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: driverStatusColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            )],
                        )
                      ),
                    ),
                  ),
                      SafeArea(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(right: 10.0, bottom: 120.0),
                        child: ClipOval(
                          child: Material(
                            color: Colors.orange.shade100, // button color
                            child: InkWell(
                              splashColor: Colors.orange, // inkwell color
                              child: SizedBox(
                                width: 56,
                                height: 56,
                                child: Icon(Icons.my_location),
                              ),
                              onTap: () {newGoogleMapController.animateCamera(
                                  CameraUpdate.newCameraPosition(
                                    CameraPosition(
                                      target: LatLng(
                                        currentPosition.latitude,
                                        currentPosition.longitude,
                                      ),
                                      zoom: 18.0,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]));
              },
            ),
          ),
        ));
  }
  void makeDriverOnlineNow() async {
 Position position =await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
   currentPosition=position;
    print(currentfirebaseDriver.uid);

   Geofire.setLocation( currentfirebaseDriver.uid,position.latitude, position.longitude);
 myrideRequestRef.set("searching");
 myrideRequestRef.onValue.listen((event) {
    });
  }
  void getLocationLiveUpdates(){
     homeDriverStreamSubcription = Geolocator.getPositionStream()
         .listen((Position position) {
          currentPosition = position;
         if (isDriverAvailable==true){
           Geofire.setLocation( currentfirebaseDriver.uid,position.latitude, position.longitude);
         }
          //LatLng latLong = LatLng(position.latitude, position.longitude);
          newGoogleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 14.0,
              ),
            ),
          );
     });
  }
}
