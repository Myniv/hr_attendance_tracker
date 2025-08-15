class AttendanceSummary {
  DateTime date;
  DateTime workStart;
  DateTime finalClockIn;
  DateTime clockOut;
  int present;
  int lateClockIn;
  int earlyClockIn;
  int onTime;
  int overtime;
  int absent;

  AttendanceSummary({
    required DateTime date,
    required DateTime workStart,
    required DateTime finalClockIn,
    required DateTime clockOut,
    this.present = 0,
    this.lateClockIn = 0,
    this.earlyClockIn = 0,
    this.onTime = 0,
    this.overtime = 0,
    this.absent = 0,
  }) : date = DateTime(date.year, date.month, date.day),
       workStart = DateTime(date.year, date.month, date.day, 8, 0),
       finalClockIn = DateTime(date.year, date.month, date.day, 9, 0),
       clockOut = DateTime(date.year, date.month, date.day, 15, 0);
}
