import 'package:flutter/material.dart';

class CustomTheme {
  static const Color backgroundScreenColor = Color(0xFF1F1301);
  static const Color colorLightBrown = Color(0xFFA0522D);
  static const Color colorBrown = Color(0xFF5D2E0A);
  static const Color colorGold = Color(0xFFD4A574);
  static const Color colorYellow = Color(0xFFFFA800);
  static const Color whiteButNot = Color(0xFFE8D5C4);

  static const BorderRadius borderRadius = BorderRadius.all(
    Radius.circular(15),
  );

  TextStyle superSmallFont(Color color, [FontWeight? fontWeight]) {
    return TextStyle(
      color: color,
      fontWeight: fontWeight ?? FontWeight.bold,
      fontSize: 18,
    );
  }
  TextStyle smallFont(Color color, [FontWeight? fontWeight]) {
    return TextStyle(
      color: color,
      fontWeight: fontWeight ?? FontWeight.bold,
      fontSize: 20,
    );
  }

  TextStyle mediumFont(Color color, [FontWeight? fontWeight]) {
    return TextStyle(
      color: color,
      fontWeight: fontWeight ?? FontWeight.bold,
      fontSize: 22,
    );
  }

  TextStyle largeFont(Color color, [FontWeight? fontWeight]) {
    return TextStyle(
      color: color,
      fontWeight: fontWeight ?? FontWeight.bold,
      fontSize: 24,
    );
  }
}
