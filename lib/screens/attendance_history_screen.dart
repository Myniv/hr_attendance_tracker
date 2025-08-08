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
      day: "Monday",
      date: "1",
      inTime: "08:00",
      outTime: "17:00",
    ),
    AttendanceHistory(
      day: "Tuesday",
      date: "2",
      inTime: "08:15",
      outTime: "17:10",
    ),
    AttendanceHistory(
      day: "Wednesday",
      date: "3",
      inTime: "08:05",
      outTime: "17:00",
    ),
    AttendanceHistory(
      day: "Thursday",
      date: "4",
      inTime: "08:10",
      outTime: "17:20",
    ),
    AttendanceHistory(
      day: "Friday",
      date: "5",
      inTime: "07:55",
      outTime: "16:50",
    ),
    AttendanceHistory(
      day: "Saturday",
      date: "6",
      inTime: "Off",
      outTime: "Off",
    ),
    AttendanceHistory(day: "Sunday", date: "7", inTime: "Off", outTime: "Off"),
    AttendanceHistory(
      day: "Monday",
      date: "8",
      inTime: "08:00",
      outTime: "17:00",
    ),
    AttendanceHistory(
      day: "Tuesday",
      date: "9",
      inTime: "08:20",
      outTime: "17:15",
    ),
    AttendanceHistory(
      day: "Wednesday",
      date: "10",
      inTime: "08:00",
      outTime: "17:00",
    ),
    AttendanceHistory(
      day: "Thursday",
      date: "11",
      inTime: "08:10",
      outTime: "17:00",
    ),
    AttendanceHistory(
      day: "Friday",
      date: "12",
      inTime: "08:00",
      outTime: "16:45",
    ),
    AttendanceHistory(
      day: "Saturday",
      date: "13",
      inTime: "Off",
      outTime: "Off",
    ),
    AttendanceHistory(day: "Sunday", date: "14", inTime: "Off", outTime: "Off"),
    AttendanceHistory(
      day: "Monday",
      date: "15",
      inTime: "08:00",
      outTime: "17:00",
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
                    attendance.day,
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
                    style: CustomTheme().mediumFont(Colors.black),
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
            style: CustomTheme().smallFont(CustomTheme.whiteButNot),
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
              style: CustomTheme().mediumFont(CustomTheme.colorBrown),
            ),
          ),
        ],
      ),
    );
  }

  Widget _attendanceCard(
    String day,
    String date,
    String inTime,
    String outTime,
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
                    Text(day, style: CustomTheme().smallFont(Colors.black)),
                    SizedBox(height: 10),
                    Text(date, style: CustomTheme().mediumFont(Colors.black)),
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
                    style: CustomTheme().smallFont(Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    inTime,
                    style: inTime != "Off"
                        ? CustomTheme().mediumFont(Colors.white)
                        : CustomTheme().mediumFont(Colors.red),
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
                    style: CustomTheme().smallFont(Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    outTime,
                    style: inTime != "Off"
                        ? CustomTheme().mediumFont(Colors.white)
                        : CustomTheme().mediumFont(Colors.red),
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
