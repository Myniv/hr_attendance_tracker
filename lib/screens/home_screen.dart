import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/custom_theme.dart';
import 'package:hr_attendance_tracker/screens/attendance_history_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(color: CustomTheme.backgroundScreenColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Home Screen',
              style: CustomTheme().largeFont(CustomTheme.whiteButNot),
            ),
            SizedBox(
              height: 100,
              width: 500,
              child: Text(
                'An HR attendance tracker is a tool used to monitor and record employee attendance, including working hours, absences, and leave. It helps HR departments ensure accurate payroll, improve productivity, and maintain compliance with company policies. By using an attendance tracker, organizations can streamline workforce management and make informed decisions based on real-time attendance data.',
                style: CustomTheme().superSmallFont(
                  CustomTheme.whiteButNot,
                  FontWeight.normal,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AttendanceHistoryScreen(),
                  ),
                );
              },
              child: Text('Go to Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
