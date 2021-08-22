import 'package:ambulance_hailer/library/configMaps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ambulance_hailer/main.dart';
import 'package:ambulance_hailer/pages/home/home_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'myValadator.dart';

class AuthentificationController extends GetxController {
  List<bool> selectedToggleUserType=[false, false].obs;
  TextEditingController nameController;
  TextEditingController phoneController;
  TextEditingController passwordController;
  TextEditingController emailController;
  TextEditingController carModelController;
  TextEditingController carNumberController;
   String snapValue="";
  @override
  Future<void> onInit() async {
    nameController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    emailController = TextEditingController();
    carModelController = TextEditingController();
    carNumberController = TextEditingController();
    selectedToggleUserType = [false, false];
    super.onInit();
  }


  @override
  void onClose() {
    nameController?.dispose();
    phoneController?.dispose();
    passwordController?.dispose();
    emailController?.dispose();
  }
  bool validateCreds() {
    bool validated = false;
    if (MyValidators.nameValidator(nameController.text) == null &&
        MyValidators.phoneValidator(phoneController.text) == null &&
        MyValidators.passwordValidator(passwordController.text) == null &&
        MyValidators.emailValidator(emailController.text) == null &&
        selectedToggleUserType.contains(true)) {
      validated = true;
    } else {
      validated = false;
    }
    return validated;
  }
  controllerReset() {
    nameController.text = '';
    phoneController.text = '';
    emailController.text="";
    passwordController.text = '';
    carNumberController.text="";
    carModelController.text="";
    selectedToggleUserType = [false, false];
    snapValue='';
  }
}
