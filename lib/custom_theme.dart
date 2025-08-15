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

  // Helper method to get responsive font size
  double _getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Use the smaller dimension to maintain aspect ratio
    final shortestSide = screenWidth < screenHeight
        ? screenWidth
        : screenHeight;

    // Base scale factor (assuming 375px width as baseline - iPhone SE/8 width)
    final scaleFactor = shortestSide / 375.0;

    // Apply scale factor with min/max bounds to prevent too small or too large text
    return (baseFontSize * scaleFactor).clamp(
      baseFontSize * 0.8,
      baseFontSize * 1.5,
    );
  }

  TextStyle superSmallFont(
    Color color, [
    FontWeight? fontWeight,
    BuildContext? context,
  ]) {
    double fontSize = 12; // Caption/Small text
    if (context != null) {
      fontSize = _getResponsiveFontSize(context, 12);
    }

    return TextStyle(
      color: color,
      fontWeight: fontWeight ?? FontWeight.bold,
      fontSize: fontSize,
    );
  }

  TextStyle smallFont(
    Color color, [
    FontWeight? fontWeight,
    BuildContext? context,
  ]) {
    double fontSize = 14; // Body text
    if (context != null) {
      fontSize = _getResponsiveFontSize(context, 14);
    }

    return TextStyle(
      color: color,
      fontWeight: fontWeight ?? FontWeight.bold,
      fontSize: fontSize,
    );
  }

  TextStyle mediumFont(
    Color color, [
    FontWeight? fontWeight,
    BuildContext? context,
  ]) {
    double fontSize = 16; // Subtitle/Large body text
    if (context != null) {
      fontSize = _getResponsiveFontSize(context, 16);
    }

    return TextStyle(
      color: color,
      fontWeight: fontWeight ?? FontWeight.bold,
      fontSize: fontSize,
    );
  }

  TextStyle largeFont(
    Color color, [
    FontWeight? fontWeight,
    BuildContext? context,
  ]) {
    double fontSize = 20; // Title/Heading
    if (context != null) {
      fontSize = _getResponsiveFontSize(context, 20);
    }

    return TextStyle(
      color: color,
      fontWeight: fontWeight ?? FontWeight.bold,
      fontSize: fontSize,
      letterSpacing: 1.5,
    );
  }

  TextStyle superLargeFont(
    Color color, [
    FontWeight? fontWeight,
    BuildContext? context,
  ]) {
    double fontSize = 26; // Title/Heading
    if (context != null) {
      fontSize = _getResponsiveFontSize(context, 26);
    }

    return TextStyle(
      color: color,
      fontWeight: fontWeight ?? FontWeight.bold,
      fontSize: fontSize,
    );
  }

  String formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return "$hour:$minute $period";
  }

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  String formatDayDate(DateTime date) {
    return "${date.day}";
  }

  String formatDay(DateTime date) {
    const days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];
    return days[date.weekday - 1];
  }

  String formatMonth(DateTime date) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[date.month - 1];
  }
}
