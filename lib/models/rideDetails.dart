import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideDetails {
  String pick_address;
  String drop_address;
  LatLng pickup;
  LatLng drop;
  String ride_request_id;
  String rider_name;
  String rider_phone;
  String payment_method;

  RideDetails(
      this.pick_address,
      this.drop_address,
      this.pickup,
      this.drop,
      this.ride_request_id,
      this.rider_name,
      this.rider_phone,
      this.payment_method);
}