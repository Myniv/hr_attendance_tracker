import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/custom_theme.dart';
import 'package:hr_attendance_tracker/widgets/no_item.dart';

class NotFoundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.backgroundScreenColor,
      body: Center(
        child: NoItem(title: "404", subTitle: "Page not found"),
      ),
    );
  }
}
