import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/widgets/button_clock_in_out.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:hr_attendance_tracker/custom_theme.dart';
import 'package:hr_attendance_tracker/models/profile.dart';
import 'package:hr_attendance_tracker/providers/attendance_history_provider.dart';
import 'package:hr_attendance_tracker/screens/attendance_history_screen.dart';

class HomeScreen extends StatelessWidget {
  // const HomeScreen({Key? key}) : super(key: key);

  DateTime today = DateTime.now();
  // DateTime today = DateTime(2025, 8, 11, 8, 45, 0);

  var dayName = CustomTheme().formatDay(DateTime.now());
  var monthName = CustomTheme().formatMonth(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _welcomeText(context),
            SizedBox(height: 20),
            _clockInOutBox(context),
            SizedBox(height: 20),
            _menu(context),

            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (_) => AttendanceHistoryScreen()),
            //     );
            //   },
            //   child: Text('History Attendance'),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _welcomeText(BuildContext context) {
    return Row(
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
    );
  }

  Widget _clockInOutBox(BuildContext context) {
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
    return Container(
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
                context.read<AttendanceHistoryProvider>().clockIn(today);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Clock In successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AttendanceHistoryScreen()),
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
                            context.read<AttendanceHistoryProvider>().clockOut(
                              today,
                            );
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
                                builder: (_) => AttendanceHistoryScreen(),
                              ),
                            );
                            isClockOut = true;
                            clockOutTime = today;
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
    );
  }

  Widget _menu(BuildContext context) {
    final menuItems = [
      menuItem(Icons.access_time, 'History', const Color(0xFFFF7043), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AttendanceHistoryScreen()),
        );
      }),
      menuItem(Icons.access_time, 'History', const Color.fromARGB(255, 83, 255, 67), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AttendanceHistoryScreen()),
        );
      }),
      menuItem(Icons.access_time, 'History', const Color.fromARGB(255, 95, 67, 255), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AttendanceHistoryScreen()),
        );
      }),
      menuItem(Icons.access_time, 'History', const Color.fromARGB(255, 255, 67, 102), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AttendanceHistoryScreen()),
        );
      }),
      menuItem(Icons.access_time, 'History', const Color.fromARGB(255, 67, 158, 255), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AttendanceHistoryScreen()),
        );
      }),
      menuItem(Icons.access_time, 'History', const Color.fromARGB(255, 236, 67, 255), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AttendanceHistoryScreen()),
        );
      }),
      menuItem(Icons.access_time, 'History', const Color(0xFFFF7043), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AttendanceHistoryScreen()),
        );
      }),
      menuItem(Icons.access_time, 'History', const Color(0xFFFF7043), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AttendanceHistoryScreen()),
        );
      }),
    ];

    return Container(
      padding: const EdgeInsets.all(20.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: CustomTheme.colorGold, width: 2),
        borderRadius: CustomTheme.borderRadius,
      ),
      child: SizedBox(
        height: 250,
        child: GridView.builder(
          // shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            final menuItem = menuItems[index];
            return _menuItem(
              menuItem['title'],
              menuItem['icon'],
              menuItem['iconColor'],
              menuItem['backgroundColor'],
              menuItem['onTap'],
            );
          },
        ),
      ),
    );
  }

  Widget _menuItem(
    String title,
    IconData icon,
    Color iconColor,
    Color backgroundColor,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(112, 0, 0, 0),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> menuItem(
    IconData icon,
    String title,
    Color backgroundColor,
    VoidCallback onPressed,
  ) {
    return {
      'icon': icon,
      'title': title,
      'iconColor': Colors.white,
      'backgroundColor': backgroundColor,
      'onTap': onPressed,
    };
  }
}
