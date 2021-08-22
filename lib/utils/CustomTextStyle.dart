import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextStyle {
  static var regularTextStyle = GoogleFonts.nunito(
    textStyle: TextStyle(
        color: Colors.black,
        letterSpacing: .1),
    fontSize: 24,
    fontWeight: FontWeight.w400,
  );
  static var mediumTextStyle =
  GoogleFonts.nunito(
    textStyle: TextStyle(
        color: Colors.black,
        letterSpacing: .1),
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );
  static var mediumTextStyleWhite = TextStyle(
      fontSize: 14, fontFamily: "Roboto", fontWeight: FontWeight.w500,color: Colors.white);
  static var boldTextStyle = TextStyle(
      fontSize: 14, fontFamily: "Roboto", fontWeight: FontWeight.w700);
  static var blackTextStyle = TextStyle(
      fontSize: 14, fontFamily: "Roboto", fontWeight: FontWeight.w900);
}
