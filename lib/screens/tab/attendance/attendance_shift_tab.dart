import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/providers/attendance_history_provider.dart';
import 'package:hr_attendance_tracker/widgets/no_item.dart';
import 'package:provider/provider.dart';
import 'package:hr_attendance_tracker/custom_theme.dart';

class AttendanceShiftTab extends StatefulWidget {
  @override
  State<AttendanceShiftTab> createState() => _AttendanceShiftTabState();
}

class _AttendanceShiftTabState extends State<AttendanceShiftTab> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AttendanceHistoryProvider>();
    final attHistory = provider.attHistory;

    final filteredHistory = attHistory
        .where(
          (record) =>
              record.date.year == selectedDate.year &&
              record.date.month == selectedDate.month,
        )
        .toList();

    final reqShift = filteredHistory
        .where((record) => record.out_time != null )
        .toList();

    return Scaffold(
      backgroundColor: CustomTheme.backgroundScreenColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
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
              if (reqShift.isEmpty)
                NoItem(
                  title: "No Request Shifting Records",
                  subTitle: "No records found for the selected date.",
                )
              else
                ListView.builder(
                  itemCount: reqShift.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final attendance = reqShift[index];
                    // return _attendanceCard(
                    //   attendance.dayName,
                    //   attendance.date,
                    //   attendance.inTime,
                    //   attendance.outTime,
                    //   context,
                    // );
                    return InkWell(
                      onTap: () {},
                      child: _absentCard(attendance.date, "Accepted", context),
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
            "Request Shifting",
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
                      "The Request Shifting has been accepted.",
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
