import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/custom_theme.dart';
import 'package:hr_attendance_tracker/widgets/custom_appbar.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  final Color color = Color(0xFF1F1301);
  // const AttendanceHistoryScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceHistoryScreen> createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
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
                itemCount: 20,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  // return Card(
                  //   color: Color(0xFF1F1301),
                  //   shadowColor: Colors.white,
                  //   child: _attendanceCard("Friday", "7", "22:00", "23:00"),
                  // );
                  return _attendanceCard("Friday", "7", "22:00", "23:00");
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
            borderRadius: BorderRadius.circular(15),
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
          borderRadius: BorderRadius.circular(20),
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
              borderRadius: BorderRadius.circular(12),
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
    String todayDate,
    String checkIn,
    String checkOut,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: CustomTheme.colorYellow, width: 2),
          borderRadius: BorderRadius.circular(10),
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
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      day,
                      style: CustomTheme().smallFont(Colors.black),
                    ),
                    SizedBox(height: 10),
                    Text(
                      todayDate,
                      style: CustomTheme().mediumFont(Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                // decoration: BoxDecoration(
                //   color: Color.fromARGB(255, 255, 255, 255),
                // ),
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
                      checkIn,
                      style: CustomTheme().mediumFont(Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                // decoration: BoxDecoration(
                //   color: Color.fromARGB(255, 255, 255, 255),
                // ),
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
                      checkIn,
                      style: CustomTheme().mediumFont(Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
