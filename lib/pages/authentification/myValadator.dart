import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class MyValidators {
  // FirstName validator
  static String nameValidator(String value) {
    if (value.isEmpty) {
      return 'Enter your first name';
    }
    if (value.isAlphabetOnly) {
      return null;
    } else
      return 'Enter a valid name';
  }

  // LastName validator
  static String phoneValidator(String value) {
    if (value.isEmpty) {
      return null;
    }
    if (value.isPhoneNumber) {
      return null;
    } else
      return 'Enter a valid phone number';
  }
  static String passwordValidator(String value) {
    if (value.isEmpty) {
      return null;
    }
    if (value.isAlphabetOnly) {
      return null;
    } else
      return 'Enter a valid password';
  }

  // Email validator
  static String emailValidator(String value) {
    if (value.isEmpty) {
      return 'Enter your email';
    }
    if (value.isEmail) {
      return null;
    } else
      return 'Enter a valid email';
  }
}