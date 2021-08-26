import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:ambulance_hailer/allWidget/noDriverAvailableDialog.dart';
import 'package:ambulance_hailer/assistant/assistantMethods.dart';
import 'package:ambulance_hailer/assistant/geoFireAssistant.dart';
import 'package:ambulance_hailer/library/configMaps.dart';
import 'package:ambulance_hailer/library/place_request.dart';
import 'package:ambulance_hailer/models/nearbyAvailableDriver.dart';
import 'package:ambulance_hailer/pages/DataHandler/appData.dart';
import 'package:ambulance_hailer/pages/components/menu1.dart';
import 'package:ambulance_hailer/utils/CustomTextStyle.dart';
import 'package:ambulance_hailer/utils/bottom_sheet.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:geolocator/geolocator.dart';

//import '../../main.dart';
import '../../main.dart';
import 'home_controller.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<HomePage> {
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  GoogleMapController mapController;
  LatLng initialPosition = LatLng(33.609434051916494, -7.623460799015407);
  Position currentPosition;
  String _currentAddress = '';

  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  final startAddressFocusNode = FocusNode();
  final desrinationAddressFocusNode = FocusNode();

  String startAddress = '';
  String destinationAddress = '';
  String placeDistance;

  Set<Marker> markers = {};

   PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  BitmapDescriptor nearByIcon;
  List<NearbyAvailableDrivers> availableDriver;
  String token;
  DatabaseReference rideRequestRef;
  String rideRequestKey;
  String state = "normal";
  Widget _textField({
     TextEditingController controller,
     FocusNode focusNode,
     String label,
     String hint,
     double width,
     Icon prefixIcon,
    Widget suffixIcon,
     Function(String) locationCallback,
  }) {
    return Container(
      width: width * 0.8,
      child: TextField(
        onChanged: (value) {
          locationCallback(value);
        },
        controller: controller,
        focusNode: focusNode,
        decoration: new InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.blue.shade300,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }

  // Method for retrieving the current location
  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        currentPosition = position;
        print('CURRENT POS: $currentPosition');
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
      await _getAddress();
    }).catchError((e) {
      print(e);
    });
    initGeoFireListener();
  }

  // Method for retrieving the address
  _getAddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
        "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        startAddressController.text = _currentAddress;
        startAddress = _currentAddress;
      });
    } catch (e) {
      print(e);
    }
  }

  // Method for calculating the distance between two places
  Future<bool> _calculateDistance() async {
    try {
      // Retrieving placemarks from addresses
      List<Location> startPlacemark = await locationFromAddress(startAddress);
      List<Location> destinationPlacemark =
      await locationFromAddress(destinationAddress);

      // Use the retrieved coordinates of the current position,
      // instead of the address if the start position is user's
      // current position, as it results in better accuracy.
      double startLatitude = startAddress == _currentAddress
          ? currentPosition.latitude
          : startPlacemark[0].latitude;

      double startLongitude = startAddress == _currentAddress
          ? currentPosition.longitude
          : startPlacemark[0].longitude;

      double destinationLatitude = destinationPlacemark[0].latitude;
      double destinationLongitude = destinationPlacemark[0].longitude;

      String startCoordinatesString = '($startLatitude, $startLongitude)';
      String destinationCoordinatesString =
          '($destinationLatitude, $destinationLongitude)';

      // Start Location Marker
      Marker startMarker = Marker(
        markerId: MarkerId(startCoordinatesString),
        position: LatLng(startLatitude, startLongitude),
        infoWindow: InfoWindow(
          title: 'Start $startCoordinatesString',
          snippet: startAddress,
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      // Destination Location Marker
      Marker destinationMarker = Marker(
        markerId: MarkerId(destinationCoordinatesString),
        position: LatLng(destinationLatitude, destinationLongitude),
        infoWindow: InfoWindow(
          title: 'Destination $destinationCoordinatesString',
          snippet:destinationAddressController.text,
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      // Adding the markers to the list
      markers.add(startMarker);
      markers.add(destinationMarker);

      print(
        'START COORDINATES: ($startLatitude, $startLongitude)',
      );
      print(
        'DESTINATION COORDINATES: ($destinationLatitude, $destinationLongitude)',
      );

      // Calculating to check that the position relative
      // to the frame, and pan & zoom the camera accordingly.
      double miny = (startLatitude <= destinationLatitude)
          ? startLatitude
          : destinationLatitude;
      double minx = (startLongitude <= destinationLongitude)
          ? startLongitude
          : destinationLongitude;
      double maxy = (startLatitude <= destinationLatitude)
          ? destinationLatitude
          : startLatitude;
      double maxx = (startLongitude <= destinationLongitude)
          ? destinationLongitude
          : startLongitude;

      double southWestLatitude = miny;
      double southWestLongitude = minx;

      double northEastLatitude = maxy;
      double northEastLongitude = maxx;

      // Accommodate the two locations within the
      // camera view of the map
      mapController.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            northeast: LatLng(northEastLatitude, northEastLongitude),
            southwest: LatLng(southWestLatitude, southWestLongitude),
          ),
          100.0,
        ),
      );

      // Calculating the distance between the start and the end positions
      // with a straight path, without considering any route
      // double distanceInMeters = await Geolocator.bearingBetween(
      //   startLatitude,
      //   startLongitude,
      //   destinationLatitude,
      //   destinationLongitude,
      // );

      await _createPolylines(startLatitude, startLongitude, destinationLatitude,
          destinationLongitude);

      double totalDistance = 0.0;

      // Calculating the total distance by adding the distance
      // between small segments
      for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        totalDistance += _coordinateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude,
        );
      }

      setState(() {
        placeDistance = totalDistance.toStringAsFixed(2);
        print('DISTANCE: $placeDistance km');
      });

      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  // Formula for calculating distance between two coordinates
  // https://stackoverflow.com/a/54138876/11910277
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  // Create the polylines for showing the route between two places
  _createPolylines(
      double startLatitude,
      double startLongitude,
      double destinationLatitude,
      double destinationLongitude,
      ) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      myApiKey, // Google Maps API Key
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: TravelMode.transit,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    GoogleMapsServices.getCurrentOnLineUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    Size size = Get.size;
    createIconMarker();
    return Container(
      height: height,
      width: width,
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            // Map View
            GoogleMap(
              markers: Set<Marker>.from(markers),
              initialCameraPosition: _initialLocation,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              polylines: Set<Polyline>.of(polylines.values),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
                _getCurrentLocation();
              },
            ),
            // Show zoom buttons
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                      child: Material(
                        color: Colors.blue.shade100, // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.add),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomIn(),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ClipOval(
                      child: Material(
                        color: Colors.blue.shade100, // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.remove),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomOut(),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Show the place input fields & button for
            // showing the route
          /*  SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    width: width * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Places',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          SizedBox(height: 10),
                          _textField(
                              label: 'Start',
                              hint: 'Choose starting point',
                              prefixIcon: Icon(Icons.looks_one),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.my_location),
                                onPressed: () {
                                  startAddressController.text = _currentAddress;
                                  _startAddress = _currentAddress;
                                },
                              ),
                              controller: startAddressController,
                              focusNode: startAddressFocusNode,
                              width: width,
                              locationCallback: (String value) {
                                setState(() {
                                  _startAddress = value;
                                });
                              }),
                          SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(5),
                          child:
                          TextFormField(
                            style: GoogleFonts.nunito(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  letterSpacing: .1),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            controller:destinationAddressController,
                            readOnly: true,
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlacePicker(
                                    apiKey:myApiKey, // Put YOUR OWN KEY here.
                                    onPlacePicked: (result) {
                                      startAddressFocusNode.unfocus();
                                      desrinationAddressFocusNode.unfocus();
                                      setState(() {
                                        if (markers.isNotEmpty)
                                          markers.clear();
                                        if (polylines.isNotEmpty)
                                          polylines.clear();
                                        if (polylineCoordinates
                                            .isNotEmpty)polylineCoordinates.clear();
                                        _placeDistance = null;
                                      });

                                      _calculateDistance()
                                          .then((isCalculated) {
                                        if (isCalculated) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Distance Calculated Sucessfully'),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Error Calculating Distance'),
                                            ),
                                          );
                                        }
                                      });
                                      Navigator.of(context).pop();
                                      destinationAddressController
                                          .text =
                                          result.formattedAddress;_destinationAddress =destinationAddressController
                                          .toString();
                                    },
                                    initialPosition: initialPosition,
                                    useCurrentLocation: true,
                                    selectInitialPosition: true,
                                  ),
                                ),
                              );
                            },
                            decoration: const InputDecoration(
                              labelStyle:
                              TextStyle(color: Colors.black),
                              icon: FaIcon(FontAwesomeIcons.search,
                                  color: Colors.black),
                              labelText: 'Choose a destination',
                            ),
                            onChanged: (value) {_destinationAddress = value;
                            },
                          ),
                        ),
                          SizedBox(height: 10),
                          Visibility(
                            visible: _placeDistance == null ? false : true,
                            child: Text(
                              'DISTANCE: $_placeDistance km',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          ElevatedButton(
                            onPressed: (_startAddress != '' &&
                                _destinationAddress != '')
                                ? () async {
                              startAddressFocusNode.unfocus();
                              desrinationAddressFocusNode.unfocus();
                              setState(() {
                                if (markers.isNotEmpty) markers.clear();
                                if (polylines.isNotEmpty)
                                  polylines.clear();
                                if (polylineCoordinates.isNotEmpty)
                                  polylineCoordinates.clear();
                                _placeDistance = null;
                              });

                              _calculateDistance().then((isCalculated) {
                                if (isCalculated) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Distance Calculated Sucessfully'),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Error Calculating Distance'),
                                    ),
                                  );
                                }
                              });
                            }
                                : null,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Show Route'.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),*/
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    width: size.width * 0.9,
                    child: Padding(
                      padding:
                      const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text("WHERE ARE YOU GOING ?",
                              style: GoogleFonts.nunito(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    letterSpacing: .1),
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              )),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.all(5),
                            child: TextFormField(
                              style: GoogleFonts.nunito(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    letterSpacing: .1),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              controller:startAddressController,
                              focusNode:startAddressFocusNode,
                              readOnly: true,
                              onTap: () async {

                              },
                              decoration: const InputDecoration(
                                labelStyle:
                                TextStyle(color: Colors.black),
                                icon: FaIcon(
                                    FontAwesomeIcons.locationArrow,
                                    color: Colors.black),
                                labelText: 'Actual position',
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            child:
                            TextFormField(
                              style: GoogleFonts.nunito(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    letterSpacing: .1),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              controller:destinationAddressController,
                              readOnly: true,
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlacePicker(
                                      apiKey:myApiKey, // Put YOUR OWN KEY here.
                                      onPlacePicked: (result) {
                                        startAddressFocusNode.unfocus();
                                        desrinationAddressFocusNode.unfocus();
                                        setState(() {
                                          if (markers.isNotEmpty)
                                            markers.clear();
                                          if (polylines.isNotEmpty)
                                            polylines.clear();
                                          if (polylineCoordinates
                                              .isNotEmpty)polylineCoordinates.clear();
                                          placeDistance = null;
                                        });

                                        _calculateDistance()
                                            .then((isCalculated) {
                                          if (isCalculated) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Distance Calculated Sucessfully'),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Error Calculating Distance'),
                                              ),
                                            );
                                          }
                                        });
                                        Navigator.of(context).pop();
                                        destinationAddressController
                                            .text =
                                            result.formattedAddress;
                                            destinationAddress =destinationAddressController
                                            .toString();
                                      },
                                      initialPosition: initialPosition,
                                      useCurrentLocation: true,
                                      selectInitialPosition: true,
                                    ),
                                  ),
                                );
                              },
                              decoration: const InputDecoration(
                                labelStyle:
                                TextStyle(color: Colors.black),
                                icon: FaIcon(FontAwesomeIcons.search,
                                    color: Colors.black),
                                labelText: 'Choose a destination',
                              ),
                              onChanged: (value) {destinationAddress = value;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                          child:

                          IconButton(
                              icon: Icon(Icons.menu,color: Colors.white),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return MenuOnePage();
                                    });
                              }),
                        ),
                      ),
                    ),
                    Spacer(),
                    Visibility(
                      visible: destinationAddress == '' ? false : true,
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.white),
                          height: 150,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: SingleChildScrollView(
                                  physics: BouncingScrollPhysics(),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: Row(children: [
                                          Text("👋 Hi Cephas ZOUBGA",
                                              style: GoogleFonts.nunito(
                                                textStyle: TextStyle(
                                                    color: Colors.black,
                                                    letterSpacing: .1),
                                                fontSize: 20,
                                                fontWeight: FontWeight.w900,
                                              ))
                                        ]),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                            padding:
                                            const EdgeInsets.all(32.0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft:
                                                  Radius.circular(20.0),
                                                  topRight:
                                                  Radius.circular(20.0)),
                                              color: Colors.grey.shade900,
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: <Widget>[
                                                    Text('DISTANCE: $placeDistance km',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 18.0),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                      "Price :" + " \$35.99",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 18.0),
                                                    ),
                                                    Spacer(),
                                                    RaisedButton(
                                                      padding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 8.0,
                                                          horizontal:
                                                          16.0),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              10.0)),
                                                      onPressed: () {
                                                        /*  showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return RequestTripPage();
                                                              });*/
                                                        /* showDialog(
                                                           context: context,
                                                           builder: (context) {
                                                             return RequestTripPage();
                                                           });*/
                                                        setState((){
                                                          state ="requesting";
                                                        });
                                                        saveRideRequest();
                                                        availableDriver = GeoFireAssistant.nearbyAvailableList;
                                                        showModalBottomSheet(
                                                          backgroundColor: Colors.transparent,
                                                          isScrollControlled: true,
                                                          context: context,
                                                          builder: (context) {
                                                            return Align(
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
                                                                                    cancelRideRequest();
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
                                                          },
                                                        );

                                                      },
                                                      color: Colors.red,
                                                      textColor: Colors.white,
                                                      child: Row(
                                                        mainAxisSize:
                                                        MainAxisSize.min,
                                                        children: <Widget>[
                                                          Text(
                                                            "Validate",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize:
                                                                16.0),
                                                          ),
                                                          const SizedBox(
                                                              width: 20.0),
                                                          Container(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                            child: Icon(
                                                              Icons
                                                                  .arrow_forward_ios,
                                                              color:
                                                              Colors.red,
                                                              size: 16.0,
                                                            ),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    10.0)),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )),
                    )
                  ],
                )),
            SafeArea(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0, bottom: 120.0),
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
                        onTap: () {
                          mapController.animateCamera(
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
          ],
        ),
      ),
    );
  }
  void initGeoFireListener() {
    Geofire.initialize("availableDriver");

    Geofire.queryAtLocation(currentPosition.latitude, currentPosition.longitude, 100).listen((map) {
      if (map["key"] != null) {
        var callBack = map['callBack'];
        switch (callBack) {
          case Geofire.onKeyEntered:
            NearbyAvailableDrivers nearbyAvailableDrivers=new NearbyAvailableDrivers("", 0, 0);
            nearbyAvailableDrivers.key = map["key"];
            nearbyAvailableDrivers.latitude = map["latitude"];
            nearbyAvailableDrivers.longitude = map["longitude"];
            GeoFireAssistant.nearbyAvailableList.add(nearbyAvailableDrivers);
            updateAvailableDriverOnMap();
            break;

          case Geofire.onKeyExited:
            GeoFireAssistant.removeFromList(map["key"]);
            updateAvailableDriverOnMap();
            break;

          case Geofire.onKeyMoved:
            NearbyAvailableDrivers nearbyAvailableDrivers=new NearbyAvailableDrivers("", 0, 0);
            nearbyAvailableDrivers.key = map["key"];
            nearbyAvailableDrivers.latitude = map["latitude"];
            nearbyAvailableDrivers.longitude = map["longitude"];
            GeoFireAssistant.updateDriverNearbyLocation(nearbyAvailableDrivers);
            updateAvailableDriverOnMap();
            break;

          case Geofire.onGeoQueryReady:
            updateAvailableDriverOnMap();
            break;
        }
      }

      setState(() {});
    });
  }
  void printFirebase(){
    rideRequestRef =FirebaseDatabase.instance.reference().child("Ride Requests");
    rideRequestRef.once().then((DataSnapshot snapshot) {
      print('${snapshot.value}');
      //rideRequestKey =snapshot.key;
    });
  }
  void saveRideRequest() async {
    rideRequestRef =FirebaseDatabase.instance.reference().child("Ride Requests");

    var pickUp  = Provider.of<AppData>(context,listen: false).pickUpLocation;
    var dropOff  = Provider.of<AppData>(context,listen: false).dropOffLocation;

    List<Location> startPlacemark = await locationFromAddress(startAddress);
    List<Location> destinationPlacemark = await locationFromAddress(destinationAddress);

    double startLatitude = startAddress == _currentAddress
        ? currentPosition.latitude
        : startPlacemark[0].latitude;

    double startLongitude = startAddress == _currentAddress
        ? currentPosition.longitude
        : startPlacemark[0].longitude;

    double destinationLatitude = destinationPlacemark[0].latitude;
    double destinationLongitude = destinationPlacemark[0].longitude;

    Map pickUpLocMap = {
      "latitude": startLatitude,
      "longitude": startLongitude,
    };
    Map dropOffMap = {
      "latitude": destinationLatitude,
      "longitude": destinationLongitude,
    };
    Map rideInfoMap = {
      "driver_in": "waiting",
      "payment_method":"cash",
      "pickup":pickUpLocMap,
      "drop":dropOffMap,
      "created_at":DateTime.now().toString(),
      "rider_name":"Cephas",
      "rider_phone":"0639607953",
      "pickup_address":startAddress,
      "dropoff_address":destinationAddressController.text
    };
    var orderRef =rideRequestRef
        .push();
   setState(() {
     orderRef.set(rideInfoMap);
     rideRequestKey=orderRef.key;
     print(orderRef.key);
     searchNearestDriver();
   });
  }
  void updateAvailableDriverOnMap()
  {
    setState(() {
      markers.clear();
    });
    Set<Marker> tMarkers = Set<Marker>();
    for(NearbyAvailableDrivers drivers in GeoFireAssistant.nearbyAvailableList){
      LatLng driverAvailablePosition = LatLng(drivers.latitude,drivers.longitude);
      Marker marker = Marker(
          markerId: MarkerId("driver${drivers.key}"),
          position: driverAvailablePosition,
          icon:nearByIcon,
          rotation :AssistantMethods.createRadomNumber(60)
      );
      tMarkers.add(marker);
      setState(() {
        markers=tMarkers;
      });
    }
  }
  void createIconMarker(){
    if (nearByIcon==null){
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context,size:Size( 2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/car_driving.png")
          .then((value){
        nearByIcon = value;
      })
      ;
    }
  }
  void cancelRideRequest(){
    rideRequestRef.remove();
    setState(() {
      state = "normal";
      print("removed");
      Get.back();
    });
  }
  void searchNearestDriver()
  {
    if (availableDriver.length==0)
    {
      cancelRideRequest();
      noDriverFound();
      return;
    }
    var driver = availableDriver[0];
    notifyDriver(driver);
    availableDriver.removeAt(0);
  }
  void noDriverFound(){
    showDialog(context: context, builder: (BuildContext context)=>NoDriverAvailableDialog());
  }
  notifyDriver(NearbyAvailableDrivers driver)
  {
    //rideRequestRef =FirebaseDatabase.instance.reference().child("Ride Requests");
    //print(FirebaseDatabase.instance.reference().child("Ride Requests"));
    //rideRequestRef =FirebaseDatabase.instance.reference().child("Ride Requests");

    driversRef.child(driver.key)
        .child("newRide")
        .set(rideRequestKey);

    driversRef.child(driver.key)
        .child("token")
        .once().then((DataSnapshot snapshot)
    {
      if (snapshot.value!=null)
      {
        String token = snapshot.value.toString();
        AssistantMethods.sendNotificationToDriver(token, context,rideRequestKey);
      }
      else
        {
          return;
        }
      const oneSecondPassed = Duration(seconds : 1);
      var timer = Timer.periodic(oneSecondPassed,(timer){

        if (state!="requesting")
        {

        }

        driverRequestTimeOut = driverRequestTimeOut-1;
        driversRef.child(driver.key)
            .child("newRide")
            .onValue.listen((event) {
          if (event.snapshot.value.toString()=="accepted")
          {
            driversRef.child(driver.key)
                .child("newRide")
                .onDisconnect();
            driverRequestTimeOut = 40;
            timer.cancel();
          }
        });
        if (driverRequestTimeOut==0)
        {
          driversRef.child(driver.key)
              .child("newRide")
              .set("timeout");

          driversRef.child(driver.key)
              .child("newRide")
              .onDisconnect();
          driverRequestTimeOut = 40;
          timer.cancel();
          searchNearestDriver();
        }
    });});
  }

}