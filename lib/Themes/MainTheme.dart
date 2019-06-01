import 'package:flutter/material.dart';

// buttons color F89481
// primary color FFFFFF
// secondry color FBFBFB

class AppTheme {
  // Light Mode
  lightMode() {
    return ThemeData(
        primaryColor: Color(0xFFFFFFFF),
        accentColor: Color(0xFFF6F6F6),
        buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.normal),
        backgroundColor: Color(0xFFF6F6F6),
        brightness: Brightness.light,
        textTheme: TextTheme(
          body1: TextStyle(
            color: Color(0xFF000000),
          ),
          body2: TextStyle(
            color: Color(0xFFF5664B),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black54, size: 20));
  }

  darkMode() {
    return ThemeData(
      primaryColor: Color(0xFF212121),
      accentColor: Color(0xFFFBFBFB),
      buttonColor: Color(0xFFF5664B),
      backgroundColor: Color(0xFF272727),
      brightness: Brightness.dark,
      textTheme: TextTheme(
        body1: TextStyle(
          color: Color(0xFFFFFFFF),
        ),
        body2: TextStyle(
          color: Color(0xFFfbc72f),
        ),
      ),
      iconTheme: IconThemeData(
        color: Colors.black54,
        size: 20
      )
    );
  }
}
