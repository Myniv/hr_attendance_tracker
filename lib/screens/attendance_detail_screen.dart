import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/custom_theme.dart';
import 'package:hr_attendance_tracker/providers/attendance_history_provider.dart';
import 'package:hr_attendance_tracker/screens/tab/attendance/attendance_history_detail_tab.dart';
import 'package:provider/provider.dart';

class AttendanceDetailScreen extends StatefulWidget {
  const AttendanceDetailScreen({Key? key}) : super(key: key);

  @override
  _AttendanceDetailScreenState createState() => _AttendanceDetailScreenState();
}

class _AttendanceDetailScreenState extends State<AttendanceDetailScreen> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      final int? attId = args?['attendance_id'];

      if (attId != null) {
        print("AttendanceDetailScreen: AttId: $attId");
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final attendanceHistoryProvider = context
              .read<AttendanceHistoryProvider>();

          try {
            final selectedAttendance = attendanceHistoryProvider.attHistory
                .firstWhere((att) => att.id == attId);
            attendanceHistoryProvider.setCurrentAttendance(selectedAttendance);
            print("Attendance loaded: ${selectedAttendance.date}");
          } catch (e) {
            print("Attendance not found for AttId: $attId");
          }
        });
      }
      _isInitialized = true;
    }
  }

  List<double>? _parseLatLong(String? latLongString) {
    if (latLongString == null || latLongString.isEmpty) {
      return null;
    }

    final parts = latLongString.split(",");
    if (parts.length >= 2) {
      final lat = double.parse(parts[0].trim());
      final lng = double.parse(parts[1].trim());
      return [lat, lng];
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final attendanceHistoryProvider = context
        .watch<AttendanceHistoryProvider>();
    final currentAttendance = attendanceHistoryProvider.currentAttendance;

    if (currentAttendance == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Attendance Detail"),
          backgroundColor: CustomTheme.colorLightBrown,
        ),
        body: Center(child: Text("No attendance data found")),
      );
    }

    final inLatLong = _parseLatLong(currentAttendance.in_latlong);
    final outLatLong = _parseLatLong(currentAttendance.out_latlong);

    return DefaultTabController(
      length: 2,
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
                  Icons.input,
                  size: 28,
                  color: CustomTheme.whiteButNot,
                ),
                child: Text(
                  "Clock In",
                  style: CustomTheme().superSmallFont(
                    CustomTheme.whiteButNot,
                    FontWeight.normal,
                    context,
                  ),
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.output,
                  size: 28,
                  color: CustomTheme.whiteButNot,
                ),
                child: Text(
                  "Clock Out",
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
            AttendanceHistoryDetailTab(
              isClockIn: true,
              latitude: inLatLong?[0],
              longitude: inLatLong?[1],
              clockTime: currentAttendance.in_time,
              picturePath: currentAttendance.in_photo,
            ),
            AttendanceHistoryDetailTab(
              isClockIn: false,
              latitude: outLatLong?[0],
              longitude: outLatLong?[1],
              clockTime: currentAttendance.out_time,
              picturePath: currentAttendance.out_photo,
            ),
          ],
        ),
      ),
    );
  }
}
