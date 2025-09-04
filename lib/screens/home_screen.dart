import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/providers/profile_provider.dart';
import 'package:hr_attendance_tracker/services/attendance_history_services.dart';
import 'package:hr_attendance_tracker/widgets/button_clock_in_out.dart';
import 'package:hr_attendance_tracker/widgets/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:hr_attendance_tracker/custom_theme.dart';
import 'package:hr_attendance_tracker/providers/attendance_history_provider.dart';
import 'package:hr_attendance_tracker/screens/tab/attendance/attendance_history_tab.dart';

class HomeScreen extends StatefulWidget {
  final void Function(int) onTabSelected;

  HomeScreen({required this.onTabSelected});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DateTime today;
  late String dayName;
  late String monthName;
  Timer? _timer;
  bool isClockIn = false;
  bool isClockOut = false;
  DateTime? clockInTime = null;
  DateTime? clockOutTime = null;
  late AttendanceHistoryServices _attendanceHistoryServices =
      AttendanceHistoryServices();

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateDateTime();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadClockStatus();
  }

  Future<void> _loadClockStatus() async {
    isClockIn = await _attendanceHistoryServices.loadIsClockIn() ?? false;
    isClockOut = await _attendanceHistoryServices.loadIsClockOut() ?? false;
    clockInTime = await _attendanceHistoryServices.loadClockInTime();
    clockOutTime = await _attendanceHistoryServices.loadClockOutTime();
    setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateDateTime() {
    setState(() {
      today = DateTime.now();
      dayName = CustomTheme().formatDay(today);
      monthName = CustomTheme().formatMonth(today);
    });
  }

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
            _clockInOutBox(context, isClockIn, isClockOut, clockInTime, clockOutTime),
            SizedBox(height: 20),
            _menu(context),
            SizedBox(height: 20),
            CarouselSlider(),

            ElevatedButton(
              onPressed: () {
                _attendanceHistoryServices.clearAllPreferences();
              },
              child: Text('History Attendance'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _welcomeText(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 300,
              child: Text(
                'Hi, ${profileProvider.profile.name} 👋',
                style: CustomTheme().largeFont(
                  Colors.white,
                  FontWeight.normal,
                  context,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
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
          backgroundImage: profileProvider.profile.profilePicturePath != null
              ? FileImage(File(profileProvider.profile.profilePicturePath!))
              : AssetImage('assets/images/profile.png'),
        ),
      ],
    );
  }

  Widget _clockInOutBox(BuildContext context, bool isClockIn, bool isClockOut, DateTime? clockInTime, DateTime? clockOutTime) {
    final hour = today.hour % 12 == 0 ? 12 : today.hour % 12;
    final minute = today.minute.toString().padLeft(2, '0');
    final period = today.hour >= 12 ? 'PM' : 'AM';

    String? hoursWorked = null;

    final attHistory = context.watch<AttendanceHistoryProvider>().attHistory;

    for (var record in attHistory) {
      if (record.date.day == today.day &&
          record.date.month == today.month &&
          record.date.year == today.year) {
        isClockIn = true;
        clockInTime = record.in_time;

        final durationWorked = today.difference(record.in_time!);
        final hours = durationWorked.inHours;
        final minutes = durationWorked.inMinutes % 60;
        final seconds = durationWorked.inSeconds % 60;

        hoursWorked =
            "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
        record.total_hours = double.parse(
          (durationWorked.inMinutes / 60).toStringAsFixed(2),
        );

        if (record.out_time != null) {
          isClockOut = true;
          clockOutTime = record.out_time!;

          final finalDurationWorked = record.out_time!.difference(
            record.in_time!,
          );
          final finalHours = finalDurationWorked.inHours;
          final finalMinutes = finalDurationWorked.inMinutes % 60;
          final finalSeconds = finalDurationWorked.inSeconds % 60;
          hoursWorked =
              "${finalHours.toString().padLeft(2, '0')}:${finalMinutes.toString().padLeft(2, '0')}:${finalSeconds.toString().padLeft(2, '0')}";
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
                ? "You Have Clocked Out Today at ${clockOutTime != null ? CustomTheme().formatTime(clockOutTime!) : 'Unknown time'}"
                : isClockIn
                ? "Since Clock In at ${clockInTime != null ? CustomTheme().formatTime(clockInTime!) : 'Unknown time'}"
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
                CustomTheme().customScaffoldMessage(
                  context: context,
                  message: 'Clock In successfully',
                );
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (_) => AttendanceHistoryTab()),
                // );
                widget.onTabSelected(1);
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
                            CustomTheme().customScaffoldMessage(
                              context: context,
                              message: 'Clock Out successfully',
                            );
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (_) => AttendanceScreen(),
                            //   ),
                            // );
                            widget.onTabSelected(1);
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
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (_) => AttendanceHistoryTab()),
        // );
        widget.onTabSelected(1);
      }),
      menuItem(
        Icons.access_time,
        'History',
        const Color.fromARGB(255, 83, 255, 67),
        () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AttendanceHistoryTab()),
          );
        },
      ),
      menuItem(
        Icons.access_time,
        'History',
        const Color.fromARGB(255, 95, 67, 255),
        () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AttendanceHistoryTab()),
          );
        },
      ),
      menuItem(
        Icons.access_time,
        'History',
        const Color.fromARGB(255, 255, 67, 102),
        () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AttendanceHistoryTab()),
          );
        },
      ),
      menuItem(
        Icons.access_time,
        'History',
        const Color.fromARGB(255, 67, 158, 255),
        () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AttendanceHistoryTab()),
          );
        },
      ),
      menuItem(
        Icons.access_time,
        'History',
        const Color.fromARGB(255, 236, 67, 255),
        () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AttendanceHistoryTab()),
          );
        },
      ),
      menuItem(Icons.access_time, 'History', const Color(0xFFFF7043), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AttendanceHistoryTab()),
        );
      }),
      menuItem(Icons.access_time, 'History', const Color(0xFFFF7043), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AttendanceHistoryTab()),
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
      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,

        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 80,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
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
