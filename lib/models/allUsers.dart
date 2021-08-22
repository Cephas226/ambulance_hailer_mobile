import "package:firebase_database/firebase_database.dart";

class Users {
  String id;
  String email;
  String name;
  String phone;
  String carModel;
  String carNumber;


  Users(this.id, this.email, this.name, this.phone, this.carModel,
      this.carNumber);

  Users.fromSnapshot(DataSnapshot dataSnapshot){
    id=dataSnapshot.key;
    email=dataSnapshot.value["email"];
    name=dataSnapshot.value["name"];
    phone=dataSnapshot.value["phone"];
    carModel=dataSnapshot.value["car_details"]["carModel"];
    carNumber=dataSnapshot.value["car_details"]["carNumber"];
  }
}