import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/widgets/bottom_navbar.dart';
import 'package:hr_attendance_tracker/widgets/custom_appbar.dart';
import 'package:hr_attendance_tracker/screens/profile_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: CustomAppbar(),
        body: ProfilePage(),
        bottomNavigationBar: CustomBottomNavbar(),
      ),
    );
  }
}
