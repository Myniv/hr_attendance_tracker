import 'package:hr_attendance_tracker/models/attendance_history.dart';

class AttendanceSummary {
  DateTime monthYear;
  DateTime workStart;
  DateTime finalClockIn;
  DateTime clockOut;

  int present;
  int lateClockIn;
  int earlyClockIn;
  int onTime;
  int overtime;
  int absent;

  AttendanceSummary({required DateTime date})
    : monthYear = DateTime(date.year, date.month, 1),
      workStart = DateTime(date.year, date.month, date.day, 8, 0),
      finalClockIn = DateTime(date.year, date.month, date.day, 9, 0),
      clockOut = DateTime(date.year, date.month, date.day, 15, 0),
      present = 0,
      lateClockIn = 0,
      earlyClockIn = 0,
      onTime = 0,
      overtime = 0,
      absent = 0;

  void updateWithRecord(AttendanceHistory record) {
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
}
