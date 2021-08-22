import 'package:firebase_database/firebase_database.dart';

class Drivers {
  String name;
  String phone;
  String email;
  String id;
  String carModel;
  String carNumber;

  Drivers(this.name, this.phone, this.email, this.id, this.carModel,
      this.carNumber);
  Drivers.fromSnapshot(DataSnapshot dataSnapshot){
    id=dataSnapshot.key;
    email=dataSnapshot.value["email"];
    name=dataSnapshot.value["name"];
    phone=dataSnapshot.value["phone"];
    carModel=dataSnapshot.value["car_details"]["carModel"];
    carNumber=dataSnapshot.value["car_details"]["carNumber"];
  }
}