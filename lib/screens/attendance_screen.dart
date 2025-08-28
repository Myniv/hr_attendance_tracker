import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/custom_theme.dart';
import 'package:hr_attendance_tracker/screens/tab/attendance/attendance_request_tab.dart';
import 'package:hr_attendance_tracker/screens/tab/attendance/attendance_history_tab.dart';
import 'package:hr_attendance_tracker/screens/tab/attendance/attendance_shift_tab.dart';

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
                  Icons.history,
                  size: 28,
                  color: CustomTheme.whiteButNot,
                ),
                child: Text(
                  "Log",
                  style: CustomTheme().superSmallFont(
                    CustomTheme.whiteButNot,
                    FontWeight.normal,
                    context,
                  ),
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.upload_file,
                  size: 28,
                  color: CustomTheme.whiteButNot,
                ),
                child: Text(
                  "Attendance",
                  style: CustomTheme().superSmallFont(
                    CustomTheme.whiteButNot,
                    FontWeight.normal,
                    context,
                  ),
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.assignment_turned_in_outlined,
                  size: 28,
                  color: CustomTheme.whiteButNot,
                ),
                child: Text(
                  "Shift",
                  style: CustomTheme().superSmallFont(
                    CustomTheme.whiteButNot,
                    FontWeight.normal,
                    context,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AttendanceHistoryTab(),
            AttendanceRequestTab(),
            AttendanceShiftTab(),
          ],
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
