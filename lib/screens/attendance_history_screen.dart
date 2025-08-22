import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/providers/attendance_history_provider.dart';
import 'package:provider/provider.dart';
import 'package:hr_attendance_tracker/custom_theme.dart';
import 'package:hr_attendance_tracker/models/attendance_summary.dart';
import 'package:hr_attendance_tracker/widgets/custom_appbar.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  @override
  State<AttendanceHistoryScreen> createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AttendanceHistoryProvider>();
    final attHistory = provider.attHistory;

    final summary = provider.getSummary(selectedDate);

    final filteredHistory = attHistory
        .where(
          (record) =>
              record.date.year == selectedDate.year &&
              record.date.month == selectedDate.month,
        )
        .toList();

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
              // FloatingActionButton(
              //   onPressed: () {
              //     context.read<AttendanceHistoryProvider>().addDummyData();
              //   },
              //   tooltip: "Add Dummy Data",
              //   child: Icon(Icons.data_usage),
              // ),
              _selectDate(context),
              _summaryCard(context, summary),
              ListView.builder(
                itemCount: filteredHistory.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final attendance = filteredHistory[index];
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
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: DateTime(2020),
            lastDate: DateTime.now(),
            initialDatePickerMode: DatePickerMode.year,
          );

          if (picked != null) {
            setState(() {
              selectedDate = DateTime(picked.year, picked.month, 1);
            });
          }
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
                    _formatMonthYear(selectedDate),
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

  String _formatMonthYear(DateTime date) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return "${months[date.month - 1]} ${date.year}";
  }

  Widget _summaryCard(BuildContext context, AttendanceSummary summary) {
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
                _summaryItem("Absent", summary.absent.toString(), context),
                _summaryItem(
                  "Late Clock In",
                  summary.lateClockIn.toString(),
                  context,
                ),
                _summaryItem(
                  "Early Clock In",
                  summary.earlyClockIn.toString(),
                  context,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _summaryItem("Present", summary.present.toString(), context),
                _summaryItem("On Time", summary.onTime.toString(), context),
                _summaryItem("Overtime", summary.overtime.toString(), context),
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
