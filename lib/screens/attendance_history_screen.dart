import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/providers/attendance_history_provider.dart';
import 'package:provider/provider.dart';
import 'package:hr_attendance_tracker/custom_theme.dart';
import 'package:hr_attendance_tracker/models/attendance_history.dart';
import 'package:hr_attendance_tracker/widgets/custom_appbar.dart';

class AttendanceHistoryScreen extends StatelessWidget {
  int absent = 0;
  int lateClockIn = 0;
  int earlyClockIn = 0;
  int present = 0;
  int onTime = 0;
  int overtime = 0;

  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final workStart = DateTime(today.year, today.month, today.day, 8, 0);
    final finalClockIn = DateTime(today.year, today.month, today.day, 9, 0);
    final clockOut = DateTime(today.year, today.month, today.day, 15, 0);
    final attHistory = context.watch<AttendanceHistoryProvider>().attHistory;

    for (var record in attHistory) {
      if (record.inTime != null) {
        present++;

        if (record.inTime!.isAfter(finalClockIn)) {
          lateClockIn++;
        } else if (record.inTime!.isBefore(workStart)) {
          earlyClockIn++;
        } else {
          onTime++;
        }

        if (record.outTime != null && record.outTime!.isAfter(clockOut)) {
          overtime++;
        }
      } else {
        absent++;
      }
    }
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
              _selectDate(context),
              _summaryCard(context),
              ListView.builder(
                itemCount: attHistory.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final attendance = attHistory[index];
                  return _attendanceCard(
                    attendance.dayName,
                    attendance.date,
                    attendance.inTime,
                    attendance.outTime,
                    context,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectDate(BuildContext context) {
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

  Widget _summaryCard(BuildContext context) {
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
                _summaryItem("Absent", absent.toString(), context),
                _summaryItem("Late Clock In", lateClockIn.toString(), context),
                _summaryItem(
                  "Early Clock In",
                  earlyClockIn.toString(),
                  context,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _summaryItem("Present", present.toString(), context),
                _summaryItem("On Time", onTime.toString(), context),
                _summaryItem("Overtime", overtime.toString(), context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryItem(String title, String value, BuildContext context) {
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
    BuildContext context,
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
                      CustomTheme().formatDayDate(date!),
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
                    inTime != null ? CustomTheme().formatTime(inTime) : "Off",
                    style: inTime != null
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
                    outTime != null ? CustomTheme().formatTime(outTime) : "Off",
                    style: outTime != null
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
