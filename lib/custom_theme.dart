import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hr_attendance_tracker/providers/profile_provider.dart';
import 'package:intl/intl.dart';

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

  double _getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final shortestSide = screenWidth < screenHeight
        ? screenWidth
        : screenHeight;

    final scaleFactor = shortestSide / 375.0;

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
    double fontSize = 12;
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

  void customScaffoldMessage({
    required BuildContext context,
    required String message,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: smallFont(Colors.white, FontWeight.w600, context),
        ),
        backgroundColor: backgroundColor ?? CustomTheme.colorLightBrown,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Widget customTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(borderRadius: CustomTheme.borderRadius),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLines: maxLines,
        style: smallFont(CustomTheme.colorBrown, FontWeight.w500, context),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: superSmallFont(
            CustomTheme.colorLightBrown,
            FontWeight.w600,
            context,
          ),
          hintStyle: superSmallFont(
            CustomTheme.colorLightBrown.withOpacity(0.6),
            FontWeight.w400,
            context,
          ),
          filled: true,
          fillColor: CustomTheme.whiteButNot,
          border: OutlineInputBorder(
            borderRadius: CustomTheme.borderRadius,
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        validator: validator,
      ),
    );
  }

  Widget customDropdown<T>({
    required BuildContext context,
    required T? value,
    required List<T> items,
    required String label,
    required void Function(T?) onChanged,
    String? Function(T?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(borderRadius: CustomTheme.borderRadius),
      child: DropdownButtonFormField<T>(
        // itemHeight: 100,
        // menuMaxHeight: 100,
        value: value,
        items: items
            .map(
              (item) => DropdownMenuItem<T>(
                value: item,
                child: Text(
                  item.toString(),
                  style: smallFont(
                    CustomTheme.colorBrown,
                    FontWeight.w500,
                    context,
                  ),
                ),
              ),
            )
            .toList(),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: superSmallFont(
            CustomTheme.colorLightBrown,
            FontWeight.w600,
            context,
          ),
          filled: true,
          fillColor: CustomTheme.whiteButNot,
          border: OutlineInputBorder(
            borderRadius: CustomTheme.borderRadius,
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        dropdownColor: CustomTheme.whiteButNot,
        onChanged: onChanged,
        validator: validator,
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: CustomTheme.colorLightBrown,
          size: 28,
        ),
      ),
    );
  }

  Widget customSelectDate({
    required BuildContext context,
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CustomTheme.whiteButNot,
        borderRadius: CustomTheme.borderRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: smallFont(
                    CustomTheme.colorLightBrown,
                    FontWeight.w600,
                    context,
                  ),
                ),
                SizedBox(height: 8),
                if (selectedDate != null) ...[
                  Text(
                    DateFormat('MMM dd, yyyy').format(selectedDate),
                    style: superSmallFont(
                      CustomTheme.colorBrown,
                      FontWeight.w600,
                      context,
                    ),
                  ),
                ] else ...[
                  Text(
                    'No date selected',
                    style: superSmallFont(
                      CustomTheme.colorLightBrown,
                      FontWeight.w400,
                      context,
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: onPressed,
            icon: Icon(Icons.calendar_month_rounded, size: 20),
            label: Text('Select'),
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomTheme.colorGold,
              foregroundColor: CustomTheme.colorBrown,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              textStyle: smallFont(
                CustomTheme.colorBrown,
                FontWeight.w700,
                context,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget customSelectImage({
    required BuildContext context,
    required VoidCallback onPressed,
    String? profilePicturePath,
    String? label,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CustomTheme.whiteButNot,
        borderRadius: CustomTheme.borderRadius,
        boxShadow: [
          BoxShadow(
            color: CustomTheme.colorBrown.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label ?? "Select Picture",
                  style: smallFont(
                    CustomTheme.colorLightBrown,
                    FontWeight.w600,
                    context,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: onPressed,
                icon: Icon(Icons.add_photo_alternate_rounded, size: 20),
                label: Text("Choose"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomTheme.colorGold,
                  foregroundColor: CustomTheme.colorBrown,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  textStyle: smallFont(
                    CustomTheme.colorBrown,
                    FontWeight.w700,
                    context,
                  ),
                ),
              ),
            ],
          ),
          if (profilePicturePath != null) ...[
            SizedBox(height: 16),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: CustomTheme.borderRadius,
                border: Border.all(color: CustomTheme.colorGold, width: 2),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: CustomTheme.borderRadius,
                    child: Image.file(
                      File(profilePicturePath),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
