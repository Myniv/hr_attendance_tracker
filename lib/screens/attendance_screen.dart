import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/custom_theme.dart';
import 'package:hr_attendance_tracker/screens/tab/attendance/attendance_absent_tab.dart';
import 'package:hr_attendance_tracker/screens/tab/attendance/attendance_history_tab.dart';
import 'package:hr_attendance_tracker/widgets/custom_appbar.dart';

class AttendanceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          title: null,
          backgroundColor: CustomTheme.colorLightBrown,
          bottom: TabBar(
            indicatorPadding: EdgeInsets.symmetric(vertical: 12),
            tabs: [
              Tab(
                icon: Icon(
                  Icons.phone_android,
                  size: 28,
                  color: CustomTheme.whiteButNot,
                ),
              ),
              Tab(
                icon: Icon(Icons.web, size: 28, color: CustomTheme.whiteButNot),
              ),
              Tab(
                icon: Icon(
                  Icons.design_services,
                  size: 28,
                  color: CustomTheme.whiteButNot,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [AttendanceHistoryTab(), AttendanceAbsentTab()],
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   currentIndex: _selectedBottomNavIndex,
        //   onTap: (index) {
        //     setState(() {
        //       _selectedBottomNavIndex = index;
        //     });
        //   },
        //   items: [
        //     BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Projects'),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.school),
        //       label: 'Certifications',
        //     ),
        //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        //   ],
        // ),
      ),
    );
  }
}
