class AttendanceHistory {
  final DateTime date;
  final DateTime? inTime;
  final DateTime? outTime;
  final double hoursWorked;
  final String dayName;

  AttendanceHistory({
    required DateTime date,
    DateTime? inTime,
    DateTime? outTime,
  }) : date = DateTime(date.year, date.month, date.day),
       inTime = inTime != null
           ? DateTime(
               date.year,
               date.month,
               date.day,
               inTime.hour,
               inTime.minute,
             )
           : null,
       outTime = outTime != null
           ? DateTime(
               date.year,
               date.month,
               date.day,
               outTime.hour,
               outTime.minute,
             )
           : null,
       hoursWorked = (inTime != null && outTime != null)
           ? _calculateHoursWorked(inTime, outTime)
           : 0.0,
       dayName = _getDayName(date);

  static double _calculateHoursWorked(DateTime inTime, DateTime? outTime) {
    if (outTime != null) {
      Duration diff = outTime.difference(inTime);
      return diff.inMinutes / 60.0;
    }
    return 0.0;
  }

  static String _getDayName(DateTime date) {
    const days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];
    return days[date.weekday - 1];
  }

  // String get formattedDate =>
  //     "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";

  // String get formattedInTime =>
  //     "${inTime.hour.toString().padLeft(2, '0')}:${inTime.minute.toString().padLeft(2, '0')}";

  // String get formattedOutTime =>
  //     "${outTime.hour.toString().padLeft(2, '0')}:${outTime.minute.toString().padLeft(2, '0')}";
}
