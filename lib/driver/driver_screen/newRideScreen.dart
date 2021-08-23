  import 'dart:async';
  import 'dart:convert';
import 'dart:math';

  import 'package:ambulance_hailer/assistant/assistantMethods.dart';
import 'package:ambulance_hailer/assistant/mapKitAssistant.dart';
import 'package:ambulance_hailer/driver/home_driver/home_driver_page.dart';
  import 'package:ambulance_hailer/library/configMaps.dart';
import 'package:ambulance_hailer/library/place_request.dart';
import 'package:ambulance_hailer/main.dart';
  import 'package:ambulance_hailer/models/rideDetails.dart';
  import 'package:ambulance_hailer/pages/authentification/login.dart';
  import 'package:ambulance_hailer/pages/home/home_page.dart';
  import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
  import "package:get/get.dart";
  import 'package:google_maps_flutter/google_maps_flutter.dart';

  class NewRidePage extends StatefulWidget {
    final RideDetails rideDetails;
    NewRidePage({this.rideDetails});

    @override
    _NewRidePageState createState() => _NewRidePageState();
  }

  class _NewRidePageState extends State<NewRidePage> {
    @override
    void initState() {
      super.initState();
      acceptRideRequest();
    }

    Completer<GoogleMapController> controllerGoogleMap = Completer();
    GoogleMapController newRideGooglemapController;
    Set<Marker> markersSet = Set<Marker>();
    Set<Circle> circleSet = Set<Circle>();
    Set<Polyline> polyLineSet = Set<Polyline>();
    List<LatLng>polylineCordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    Map<PolylineId, Polyline> polylines = {};
    String placeDistance;
    double mapPaddingFromBottom = 0;
    Position myPosition;
    BitmapDescriptor animatingMarerIcon;
    String status = "accepted";
    String durationRide ="";
    bool isResquestingDirection = false;
    static final CameraPosition _kGooglePlex = CameraPosition(
        target: LatLng(33.609434051916494, -7.623460799015407), zoom: 14.4746);

    @override
    Widget build(BuildContext context) {
      createIconMarker();
      return Scaffold(
          backgroundColor: Theme
              .of(context)
              .primaryColor,
          body: Stack(
            children: [
              GoogleMap(
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                tiltGesturesEnabled: true,
                compassEnabled: true,
                scrollGesturesEnabled: true,
                zoomGesturesEnabled: true,
                polylines: Set<Polyline>.of(polylines.values),
                markers: Set<Marker>.of(markersSet),
                onMapCreated: (GoogleMapController controller) async {
                  setState(() {
                    mapPaddingFromBottom = 265.0;
                  });
                  newRideGooglemapController = controller;
                  var currentLatLong =
                  LatLng(currentPosition.latitude, currentPosition.longitude);
                  var pickupLatLng = widget.rideDetails.pickup;
                  _getPolyline(currentLatLong, pickupLatLng);
                  getRideLiveLocationUpdates();
                },
              ),
              Positioned(
                left: 0.0,
                right: 0.0,
                bottom: 0.0,
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 16.0,
                          spreadRadius: 0.5,
                          offset: Offset(0.7, 0.7),
                        ),
                      ],
                    ),
                    height: 270.0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 18.0),
                      child:
                      Column(
                        children: [
                          Text(durationRide, style: TextStyle(
                              fontSize: 14.0, color: Colors.deepPurple),),
                          SizedBox(height: 6.0,),
                          Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Cephas ZOUBGA"),
                              Padding(padding: EdgeInsets.only(right: 10.0),
                                child: Icon(Icons.phone_android),
                              )
                            ],
                          ),
                          SizedBox(height: 6.0,),
                          Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                  "images/car.png", height: 16.0, width: 16.0),
                              Expanded(child: Container(child: Text(
                                "Street##4,Casablanca",
                                overflow: TextOverflow.ellipsis,
                              ),))
                            ],
                          ),
                          SizedBox(height: 6.0,),
                          Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                  "images/car.png", height: 16.0, width: 16.0),
                              Expanded(child: Container(child: Text(
                                "Street##4,Casablanca",
                                overflow: TextOverflow.ellipsis,
                              ),))
                            ],
                          ),
                          SizedBox(height: 6.0,),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 18.0),
                              child: RaisedButton(
                                onPressed: () {},
                                color: Theme
                                    .of(context)
                                    .accentColor,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Text("Arrived"), Icon(Icons.directions_car)
                                  ],
                                ),
                              )
                          )
                        ],
                      ),
                    )
                ),),

            ],
          ));
    }

    _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
      MarkerId markerId = MarkerId(id);
      Marker marker =
      Marker(markerId: markerId, icon: descriptor, position: position);
      //a revoir
      markersSet.add(marker);
    }
    _addPolyLine(List<LatLng> polylineCoordinates) {
      PolylineId id = PolylineId("poly");
      Polyline polyline = Polyline(
        polylineId: id,
        points: polylineCoordinates,
        width: 8,
      );
      polylines[id] = polyline;
      setState(() {});
    }

    void _getPolyline(LatLng pickUpLatLng, LatLng dropOffLatLng) async {
      List<LatLng> polylineCoordinates = [];

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        myApiKey,
        PointLatLng(pickUpLatLng.latitude, pickUpLatLng.longitude),
        PointLatLng(dropOffLatLng.latitude, dropOffLatLng.longitude),
        travelMode: TravelMode.driving,
      );
      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      } else {
        print(result.errorMessage);
      }
     // _addMarker(pickUpLatLng, "pickUpId", BitmapDescriptor.defaultMarker);
      _addMarker(dropOffLatLng, "dropOffUpId", BitmapDescriptor.defaultMarker);
      _addPolyLine(polylineCoordinates);



      double miny = (pickUpLatLng.latitude <= dropOffLatLng.latitude)
          ? pickUpLatLng.latitude
          : dropOffLatLng.latitude;
      double minx = (pickUpLatLng.longitude <= dropOffLatLng.longitude)
          ? pickUpLatLng.longitude
          : dropOffLatLng.longitude;
      double maxy = (pickUpLatLng.latitude <= dropOffLatLng.latitude)
          ? dropOffLatLng.latitude
          : pickUpLatLng.latitude;
      double maxx = (pickUpLatLng.longitude <= dropOffLatLng.longitude)
          ? dropOffLatLng.longitude
          : pickUpLatLng.longitude;

      double southWestLatitude = miny;
      double southWestLongitude = minx;

      double northEastLatitude = maxy;
      double northEastLongitude = maxx;

      // Accommodate the two locations within the
      // camera view of the map
      newRideGooglemapController.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            northeast: LatLng(northEastLatitude, northEastLongitude),
            southwest: LatLng(southWestLatitude, southWestLongitude),
          ),
          100.0,
        ),
      );




    }

    void acceptRideRequest() {
      String rideRequestId = widget.rideDetails.ride_request_id;
      print(driversInformation);
      newRequestRef.child(rideRequestId).child("status").set("accepted");
      newRequestRef.child(rideRequestId).child("driver_name").set(
          driversInformation.name);
      newRequestRef.child(rideRequestId).child("driver_phone").set(
          driversInformation.phone);
      newRequestRef.child(rideRequestId).child("driver_id").set(
          driversInformation.id);
      newRequestRef.child(rideRequestId).child("car_details").set(
          '${driversInformation.carModel}-${driversInformation.carNumber}');

      Map locMap = {
        "latitude": currentPosition.latitude.toString(),
        "longitude": currentPosition.longitude.toString()};
      newRequestRef.child(rideRequestId).child("driver_location").set(locMap);
    }
    void createIconMarker() {
      if (animatingMarerIcon == null) {
        ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: Size(2, 2));
        BitmapDescriptor.fromAssetImage(
            imageConfiguration, "images/car_driving.png")
            .then((value) {
          animatingMarerIcon = value;
        });
      }
    }
    void getRideLiveLocationUpdates() {
      LatLng oldPos = LatLng(0, 0);
      rideStreamSubcription =
          Geolocator.getPositionStream().listen((Position position) async {
            currentPosition = position;
            myPosition = position;
            LatLng mPositon = LatLng(position.latitude, position.longitude);

            var rot = MapKitAssistant.getMarkerRotation(oldPos.latitude, oldPos.longitude, mPositon.latitude, mPositon.longitude);

            Marker animatingMarker =
            Marker (
                markerId: MarkerId("animating"),
                position: mPositon,
                icon: animatingMarerIcon,
                rotation : rot,
                infoWindow: InfoWindow(title: "Current Location")
            );
            setState(() {
              CameraPosition cameraPosition = new CameraPosition(target: mPositon,zoom: 17);
              newRideGooglemapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

              markersSet.removeWhere((mark) => mark.markerId.value == "animating");
              markersSet.add(animatingMarker);
            });
            oldPos = mPositon;
            updateRideDetails();
            String rideRequestId = widget.rideDetails.ride_request_id;
            Map locMap = {
              "latitude": currentPosition.latitude.toString(),
              "longitude": currentPosition.longitude.toString()};
            newRequestRef.child(rideRequestId).child("driver_location").set(locMap);
          });
    }
    void updateRideDetails()async
    {
      if (isResquestingDirection==false)
      {
        isResquestingDirection = true;
        if (myPosition==null){
          return;
        }
        var postLatLng = LatLng(myPosition.latitude, myPosition.longitude);
        LatLng destinationLng;
        if(status=="accepted")
        {
          destinationLng = widget.rideDetails.pickup;
        }
        else
        {
          destinationLng = widget.rideDetails.drop;
        }
        var directionDetails = await AssistantMethods.obtainPlaceDirectionDetails (postLatLng,destinationLng);
        if (directionDetails!=null)
        {
          setState(() {
            durationRide = directionDetails.durationText;
          });
        }
        isResquestingDirection =false;
      }
    }
  }