import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/providers/attendance_history_provider.dart';
import 'package:provider/provider.dart';
import 'package:hr_attendance_tracker/custom_theme.dart';
import 'package:hr_attendance_tracker/models/attendance_summary.dart';
import 'package:hr_attendance_tracker/widgets/custom_appbar.dart';

class AttendanceAbsentTab extends StatefulWidget {
  @override
  State<AttendanceAbsentTab> createState() => _AttendanceAbsentTabState();
}

class _AttendanceAbsentTabState extends State<AttendanceAbsentTab> {
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

    final absent = filteredHistory
        .where((record) => record.inTime == null)
        .toList();

    return Scaffold(
      backgroundColor: CustomTheme.backgroundScreenColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              FloatingActionButton(
                onPressed: () {
                  context.read<AttendanceHistoryProvider>().addDummyData();
                },
                tooltip: "Add Dummy Data",
                child: Icon(Icons.data_usage),
              ),
              _selectDate(context),
              ListView.builder(
                itemCount: absent.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final attendance = absent[index];
                  // return _attendanceCard(
                  //   attendance.dayName,
                  //   attendance.date,
                  //   attendance.inTime,
                  //   attendance.outTime,
                  //   context,
                  // );
                  return InkWell(
                    onTap: () {},
                    child: _absentCard(attendance.date, "Rejected", context),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(32.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomTheme.colorGold,
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: () {
            // Handle button press
          },
          child: Text(
            "Request Attendance",
            style: CustomTheme().smallFont(
              CustomTheme.colorBrown,
              null,
              context,
            ),
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

  Widget _absentCard(DateTime date, String status, BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(16.0),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: CustomTheme.colorYellow, width: 2),
          borderRadius: CustomTheme.borderRadius,
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${date.day} ${_formatMonthYear(date)}",
                      style: CustomTheme().mediumFont(
                        CustomTheme.whiteButNot,
                        null,
                        context,
                      ),
                    ),
                    Text(
                      "The Request Attendance has been rejected.",
                      style: CustomTheme().smallFont(
                        CustomTheme.whiteButNot,
                        FontWeight.normal,
                        context,
                      ),
                    ),
                    Text(
                      status,
                      style: CustomTheme().superSmallFont(
                        status == "Rejected" ? Colors.red : Colors.green,
                        null,
                        context,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Icon(Icons.arrow_right, color: CustomTheme.whiteButNot, size: 50),
            ],
          ),
        ),
      ),
    );
  }
}
