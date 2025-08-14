import 'package:flutter/foundation.dart';
import 'package:hr_attendance_tracker/models/attendance_history.dart';

class AttendanceHistoryProvider extends ChangeNotifier {
  final List<AttendanceHistory> _attHistory = [];
  List<AttendanceHistory> get attHistory => _attHistory;

  void checkIn(DateTime inTime) {
    _attHistory.add(AttendanceHistory(date: DateTime.now(), inTime: inTime));
    notifyListeners();
  }

  void checkOut(DateTime outTime) {
    final today = DateTime.now();
    int todayIndex = -1;

    for (var i = 0; i < _attHistory.length; i++) {
      if (_attHistory[i].date.day == today.day &&
          _attHistory[i].date.month == today.month &&
          _attHistory[i].date.year == today.year) {
        todayIndex = i;
        break;
      }
    }

    if (todayIndex != -1) {
      // Update the existing record
      _attHistory[todayIndex] = AttendanceHistory(
        date: _attHistory[todayIndex].date,
        outTime: outTime,
      );
      notifyListeners();
    } else {
      if (kDebugMode) {
        print("Please check in first.");
      }
      return null;
    }
  }
}
