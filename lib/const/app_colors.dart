import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  static final LinearGradient kPrimaryGradientGreenColor = const LinearGradient(
    colors: [Color.fromRGBO(16, 148, 156, 1), Color.fromRGBO(16, 148, 156, 1)],
    stops: [0.25, 0.75],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final Color primaryColor = Color.fromRGBO(16, 148, 156, 1);

  static final Color kPrimaryBackgroundColor = const Color(0xFFF6F7FA);
  static final Color kPrimaryWhite = Colors.white;
  static final Color kPrimaryGreen = Color.fromRGBO(16, 148, 156, 1);
  static final Color kPrimaryBlue = const Color(0x0ffe07ff);
  static final Color kPrimaryGrey = const Color(0xFFA0AEB9);
  static final LinearGradient kPrimaryGradientGrey = const LinearGradient(
    colors: [Color(0xff9fadb9), Color(0xff9fadb9)],
    stops: [0.25, 0.75],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static final LinearGradient kPrimaryGradientWhite = const LinearGradient(
    colors: [Color(0xffffffff), Color(0xffffffff)],
    stops: [0.25, 0.75],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const Color primary = Color.fromRGBO(16, 148, 156, 1);
  static const Color inactive = Color.fromRGBO(0, 0, 0, 0.4);
  static const Color background = Color.fromRGBO(232, 232, 232, 1);
  static Color input = const Color.fromRGBO(196, 196, 196, 1).withOpacity(0.25);
}
