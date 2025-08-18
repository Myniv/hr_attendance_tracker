import 'package:flutter/foundation.dart';
import 'package:hr_attendance_tracker/models/attendance_history.dart';
import 'package:hr_attendance_tracker/models/attendance_summary.dart';

class AttendanceHistoryProvider extends ChangeNotifier {
  final List<AttendanceHistory> _attHistory = [];
  final List<AttendanceSummary> _summaries = [];

  List<AttendanceHistory> get attHistory => _attHistory;
  List<AttendanceSummary> get summaries => _summaries;

  void clockIn(DateTime inTime) {
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

    if (todayIndex == -1) {
      _attHistory.add(AttendanceHistory(date: today, inTime: inTime));
      _updateOrCreateSummary(today);
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
    final today = DateTime.now();

    for (var i = 0; i < _attHistory.length; i++) {
      if (_attHistory[i].date.day == today.day &&
          _attHistory[i].date.month == today.month &&
          _attHistory[i].date.year == today.year) {
        _attHistory[i].setOutTime(outTime);
        _updateOrCreateSummary(today);
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

  // Auto-update or create summary based on month/year
  void _updateOrCreateSummary(DateTime date) {
    final monthYear = DateTime(date.year, date.month, 1);

    int summaryIndex = -1;
    for (var i = 0; i < _summaries.length; i++) {
      if (_summaries[i].monthYear.year == monthYear.year &&
          _summaries[i].monthYear.month == monthYear.month) {
        summaryIndex = i;
        break;
      }
    }

    if (summaryIndex != -1) {
      _summaries[summaryIndex] = _calculateFreshSummary(date);
    } else {
      _summaries.add(_calculateFreshSummary(date));
    }
  }

  AttendanceSummary _calculateFreshSummary(DateTime date) {
    final summary = AttendanceSummary(date: date);

    for (var record in _attHistory) {
      if (record.date.year == date.year && record.date.month == date.month) {
        summary.updateWithRecord(record);
      }
    }

    return summary;
  }

  AttendanceSummary getSummary(DateTime date) {
    final monthYear = DateTime(date.year, date.month, 1);

    for (var summary in _summaries) {
      if (summary.monthYear.year == monthYear.year &&
          summary.monthYear.month == monthYear.month) {
        return summary;
      }
    }

    final newSummary = _calculateFreshSummary(date);
    _summaries.add(newSummary);
    return newSummary;
  }
}
