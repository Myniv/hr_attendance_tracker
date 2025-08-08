import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/screens/home_screen.dart';
import 'package:hr_attendance_tracker/widgets/bottom_navbar.dart';
import 'package:hr_attendance_tracker/widgets/custom_appbar.dart';
import 'package:hr_attendance_tracker/screens/profile_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Sample Portfolio App",
      // home: Scaffold(
      //   appBar: CustomAppbar(),
      //   body: ProfilePage(),
      //   bottomNavigationBar: CustomBottomNavbar(),
      // ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<String> _titleScreen = ["Home", "Profile"];
  final List<IconData> _iconScreen = [Icons.home, Icons.person];
  final List<Widget> _screens = [
    HomeScreen(),
    // AttendanceHistoryScreen(),
    ProfileScreen(),
    // PortofolioScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: CustomAppbar(
          title: _titleScreen[_currentIndex],
        ), // AppBar(title: Text(_titleScreen[_currentIndex]),),
        body: _screens[_currentIndex],
        bottomNavigationBar: CustomBottomNavbar(
          currentIndex: _currentIndex,
          title: _titleScreen,
          icon: _iconScreen,
          onTap: _changeTab,
        ),
      ),
    );
  }
}
