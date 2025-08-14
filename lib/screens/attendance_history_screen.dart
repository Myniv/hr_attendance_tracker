import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/custom_theme.dart';
import 'package:hr_attendance_tracker/models/attendance_history.dart';
import 'package:hr_attendance_tracker/widgets/custom_appbar.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  final Color color = Color(0xFF1F1301);
  // const AttendanceHistoryScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceHistoryScreen> createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  final List<AttendanceHistory> attendanceHistory = [
    AttendanceHistory(
      date: DateTime(2025, 8, 1),
      inTime: DateTime(0, 1, 1, 8, 0),
      outTime: DateTime(0, 1, 1, 17, 0),
    ),
    AttendanceHistory(
      date: DateTime(2025, 8, 2),
      inTime: DateTime(0, 1, 1, 8, 15),
      outTime: DateTime(0, 1, 1, 17, 10),
    ),
    AttendanceHistory(
      date: DateTime(2025, 8, 6),
      inTime: null, // Off day
      outTime: null,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.backgroundScreenColor,
      appBar: CustomAppbar(
        title: "Attendance History",
        onBack: () {
          Navigator.pop(context);
        },
        icon: Icons.arrow_back,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _selectDate(),
              _summaryCard(),
              ListView.builder(
                itemCount: attendanceHistory.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final attendance = attendanceHistory[index];
                  return _attendanceCard(
                    attendance.dayName,
                    attendance.date,
                    attendance.inTime,
                    attendance.outTime,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectDate() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: () {
          print("object");
        },
        child: Container(
          height: 50,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: CustomTheme.whiteButNot,
            border: Border.all(color: CustomTheme.colorGold, width: 2),
            borderRadius: CustomTheme.borderRadius,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.calendar_month, color: Colors.black, size: 28),
              Expanded(
                child: Center(
                  child: Text(
                    "October 2025",
                    style: CustomTheme().superSmallFont(
                      Colors.black,
                      null,
                      context,
                    ),
                  ),
                ),
              ),
              Icon(Icons.arrow_drop_down, color: Colors.black, size: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryCard() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10),
      child: Container(
        height: 230,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: CustomTheme.colorLightBrown,
          border: Border.all(color: CustomTheme.colorGold, width: 2),
          borderRadius: CustomTheme.borderRadius,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _summaryItem("Absent", "13"),
                _summaryItem("Late Check In", "3"),
                _summaryItem("Early Clock In", "6"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _summaryItem("Present", "18"),
                _summaryItem("On Time", "15"),
                _summaryItem("Overtime", "2"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryItem(String title, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: CustomTheme().superSmallFont(
              CustomTheme.whiteButNot,
              null,
              context,
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: CustomTheme.whiteButNot,
              borderRadius: CustomTheme.borderRadius,
            ),
            child: Text(
              value,
              style: CustomTheme().smallFont(
                CustomTheme.colorBrown,
                null,
                context,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _attendanceCard(
    String day,
    DateTime? date,
    DateTime? inTime,
    DateTime? outTime,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: CustomTheme.colorYellow, width: 2),
          borderRadius: CustomTheme.borderRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: CustomTheme.colorYellow,
                  border: Border.all(color: CustomTheme.colorYellow),
                  borderRadius: CustomTheme.borderRadius,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      day,
                      style: CustomTheme().superSmallFont(
                        Colors.black,
                        null,
                        context,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      date.toString(),
                      style: CustomTheme().smallFont(
                        Colors.black,
                        null,
                        context,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Check In",
                    style: CustomTheme().superSmallFont(
                      Colors.white,
                      null,
                      context,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    inTime.toString(),
                    style: inTime != "Off"
                        ? CustomTheme().smallFont(Colors.white, null, context)
                        : CustomTheme().smallFont(Colors.red, null, context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Check Out",
                    style: CustomTheme().superSmallFont(
                      Colors.white,
                      null,
                      context,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    outTime.toString(),
                    style: inTime != "Off"
                        ? CustomTheme().smallFont(Colors.white, null, context)
                        : CustomTheme().smallFont(Colors.red, null, context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
