import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/widgets/custom_appbar.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: "About",
        onBack: () => Navigator.of(context).pop(),
        icon: Icons.arrow_back,
      ),
      body: Center(
        child: Text('Settings Screen'),
      ),
    );
  }
}
