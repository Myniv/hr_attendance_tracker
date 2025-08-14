import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/custom_theme.dart';
import 'package:hr_attendance_tracker/models/attendance_history.dart';
import 'package:hr_attendance_tracker/models/profile.dart';
import 'package:hr_attendance_tracker/screens/attendance_history_screen.dart';

class HomeScreen extends StatelessWidget {
  // const HomeScreen({Key? key}) : super(key: key);

  DateTime today = DateTime.now();
  var dayName = CustomTheme().formatDay(DateTime.now());
  var monthName = CustomTheme().formatMonth(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final hour = today.hour % 12 == 0 ? 12 : today.hour % 12;
    final minute = today.minute.toString().padLeft(2, '0');
    final period = today.hour >= 12 ? 'PM' : 'AM';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, ${Profile().name} 👋',
                      style: CustomTheme().largeFont(
                        Colors.white,
                        FontWeight.normal,
                        context,
                      ),
                    ),
                    Text(
                      "Welcome Back!",
                      style: CustomTheme().largeFont(
                        Colors.white,
                        FontWeight.bold,
                        context,
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),
              ],
            ),
            SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: CustomTheme.colorYellow,
                border: Border.all(color: CustomTheme.colorGold, width: 2),
                borderRadius: CustomTheme.borderRadius,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$dayName, ${today.day} $monthName",
                    style: CustomTheme().smallFont(
                      CustomTheme.colorBrown,
                      null,
                      context,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "$hour:$minute",
                        style: CustomTheme().superLargeFont(
                          CustomTheme.colorBrown,
                          null,
                          context,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        period,
                        style: CustomTheme().superLargeFont(
                          CustomTheme.colorBrown,
                          FontWeight.normal,
                          context,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  Text(
                    "Not Clock In Yet",
                    style: CustomTheme().superSmallFont(
                      CustomTheme.colorBrown,
                      FontWeight.normal,
                      context,
                    ),
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.input, color: CustomTheme.colorBrown),
                      label: Text(
                        'Clock In',
                        style: CustomTheme().smallFont(
                          CustomTheme.colorBrown,
                          null,
                          context,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: CustomTheme.colorGold,
                            width: 2,
                          ),
                        ),
                        elevation: 3,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AttendanceHistoryScreen(),
                  ),
                );
              },
              child: Text('History Attendance'),
            ),
          ],
        ),
      ),
    );
  }
}
