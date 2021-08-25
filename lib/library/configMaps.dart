import 'dart:async';

import 'package:ambulance_hailer/models/drivers.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:ambulance_hailer/models/allUsers.dart';
import 'package:geolocator/geolocator.dart';
User firebaseUser;
User currentfirebaseUser;
User currentfirebaseDriver;
Position currentPosition;
Users userCurrentInfo;
StreamSubscription <Position> homeDriverStreamSubcription;
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final myApiKey = "AIzaSyAtzQc5uOLC9UcrPka0QHCsrpxx7Chxl0A";
String serverToken = "key=AAAAqI-qO1E:APA91bF0RhdW-NHnRGd6eTSiC0AfiSu4LskMhOvNoQ1ctuxFXeNcO5759gtqQGEzLAfEMvWKMvKBvPKDwjUzyvxLy4q4IJ-vypyxDArXseQ2Vxza2a7Gh8oPeVSLOvPtHnkERei2hXmY";

Drivers driversInformation;
Users usersInformation;
StreamSubscription <Position> rideStreamSubcription;