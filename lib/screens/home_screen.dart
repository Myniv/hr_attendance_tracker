import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/widgets/button_clock_in_out.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:hr_attendance_tracker/custom_theme.dart';
import 'package:hr_attendance_tracker/models/attendance_history.dart';
import 'package:hr_attendance_tracker/models/profile.dart';
import 'package:hr_attendance_tracker/providers/attendance_history_provider.dart';
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

    bool isClockIn = false;
    bool isClockOut = false;
    DateTime? clockInTime = null;
    DateTime? clockOutTime = null;

    String? hoursWorked = null;

    final attHistory = context.watch<AttendanceHistoryProvider>().attHistory;

    for (var record in attHistory) {
      if (record.date.day == today.day &&
          record.date.month == today.month &&
          record.date.year == today.year) {
        isClockIn = true;
        clockInTime = record.inTime;

        final durationWorked = today.difference(record.inTime!);
        final hours = durationWorked.inHours;
        final minutes = durationWorked.inMinutes % 60;
        final seconds = durationWorked.inSeconds % 60;

        hoursWorked = "$hours:$minutes:$seconds";
        record.hoursWorked = double.parse(
          (durationWorked.inMinutes / 60).toStringAsFixed(2),
        );

        if (record.outTime != null) {
          isClockOut = true;
          clockOutTime = record.outTime!;
        }
        break;
      }
    }

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
                    "$dayName, ${today.day} $monthName ${today.year}",
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
                      if (!isClockIn || isClockOut) ...[
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
                      ] else ...[
                        Text(
                          "$hoursWorked",
                          style: CustomTheme().superLargeFont(
                            const Color.fromARGB(255, 72, 133, 3),
                            null,
                            context,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Hours",
                          style: CustomTheme().superLargeFont(
                            CustomTheme.colorBrown,
                            FontWeight.normal,
                            context,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),

                  Text(
                    isClockOut
                        ? "You Have Clocked Out Today at ${CustomTheme().formatTime(clockOutTime!)}"
                        : isClockIn
                        ? "Since Clock In at ${CustomTheme().formatTime(clockInTime!)}"
                        : "Not Clock In Yet",
                    style: CustomTheme().superSmallFont(
                      isClockOut
                          ? const Color.fromARGB(255, 0, 122, 4)
                          : isClockIn
                          ? CustomTheme.colorBrown
                          : const Color.fromARGB(255, 216, 14, 0),
                      // CustomTheme.colorBrown,
                      FontWeight.normal,
                      context,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (!isClockIn && !isClockOut) ...[
                    ButtonClockInOut(
                      isClockIn: isClockIn,

                      onPressed: () {
                        context.read<AttendanceHistoryProvider>().clockIn(
                          today,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Clock In successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AttendanceHistoryScreen(),
                          ),
                        );
                      },
                    ),
                  ] else if (!isClockOut) ...[
                    ButtonClockInOut(
                      isClockIn: isClockIn,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: Text("Clock Out"),
                              content: Text("Are you sure want to clock out?"),
                              actions: [
                                TextButton(
                                  child: Text("Cancel"),
                                  onPressed: () => Navigator.of(ctx).pop(),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () {
                                    context
                                        .read<AttendanceHistoryProvider>()
                                        .clockOut(today);
                                    Navigator.of(ctx).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Clock Out successfully'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            AttendanceHistoryScreen(),
                                      ),
                                    );
                                    isClockOut = true;
                                    clockOutTime = DateTime.now();
                                  },
                                  child: Text(
                                    'Clock Out',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AttendanceHistoryScreen()),
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
