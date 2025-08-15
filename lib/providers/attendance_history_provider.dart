import 'package:flutter/foundation.dart';
import 'package:hr_attendance_tracker/models/attendance_history.dart';

class AttendanceHistoryProvider extends ChangeNotifier {
  final List<AttendanceHistory> _attHistory = [];
  List<AttendanceHistory> get attHistory => _attHistory;

  void clockIn(DateTime inTime) {
    // final today = DateTime.now();
    final today = inTime;
    int todayIndex = -1;

    for (var i = 0; i < _attHistory.length; i++) {
      if (_attHistory[i].date.day == today.day &&
          _attHistory[i].date.month == today.month &&
          _attHistory[i].date.year == today.year) {
        todayIndex = i;
        break;
      }
    }

    if (todayIndex == -1) {
      _attHistory.add(AttendanceHistory(date: today, inTime: inTime));
      notifyListeners();
      print(
        _attHistory
            .map(
              (r) =>
                  'Date: ${r.date}, In: ${r.inTime}, hoursWorked ${r.hoursWorked}',
            )
            .toList(),
      );
    } else {
      return null;
    }
  }

  void clockOut(DateTime outTime) {
    // final today = DateTime.now();
    final today = outTime;

    for (var i = 0; i < _attHistory.length; i++) {
      if (_attHistory[i].date.day == today.day &&
          _attHistory[i].date.month == today.month &&
          _attHistory[i].date.year == today.year) {
        // Simply update the outTime - no need to recreate the object
        _attHistory[i].setOutTime(outTime);
        notifyListeners();
        print(
          _attHistory
              .map(
                (r) =>
                    'Date: ${r.date}, In: ${r.inTime}, Out: ${r.outTime}, hoursWorked ${r.hoursWorked}',
              )
              .toList(),
        );
        return;
      }
    }

    if (kDebugMode) {
      print("Please check in first.");
    }
  }
}
