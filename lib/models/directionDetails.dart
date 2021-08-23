import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionDetails {
  int distanceValue;
  int durationValue;
  int directionValue;

  String durationtext;
  String distanceText;
  String durationText;
  String encodePoints;

  DirectionDetails(
      this.distanceValue,
      this.durationValue,
      this.directionValue,
      this.durationtext,
      this.distanceText,
      this.durationText,
      this.encodePoints);
}