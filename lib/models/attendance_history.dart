class AttendanceHistory {
  DateTime date;
  DateTime? inTime;
  DateTime? outTime; // Remove final to make it mutable
  double hoursWorked;
  String dayName;

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

  // Add a method to update outTime and recalculate hoursWorked
  void setOutTime(DateTime newOutTime) {
    outTime = DateTime(
      date.year,
      date.month,
      date.day,
      newOutTime.hour,
      newOutTime.minute,
    );

    // Recalculate hoursWorked
    if (inTime != null && outTime != null) {
      hoursWorked = _calculateHoursWorked(inTime!, outTime!);
    }
  }

  static double _calculateHoursWorked(DateTime inTime, DateTime outTime) {
    Duration diff = outTime.difference(inTime);
    return diff.inMinutes / 60.0;
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
}
