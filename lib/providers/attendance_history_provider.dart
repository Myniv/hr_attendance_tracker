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

  void addDummyData() {
    _attHistory.clear();
    _summaries.clear();

    _addDummyMonth(2024, 10, [
      {
        'day': 1,
        'inTime': DateTime(2024, 10, 1, 8, 15),
        'outTime': DateTime(2024, 10, 1, 16, 30),
      }, 
      {
        'day': 2,
        'inTime': DateTime(2024, 10, 2, 7, 45),
        'outTime': DateTime(2024, 10, 2, 15, 0),
      },
      {
        'day': 3,
        'inTime': DateTime(2024, 10, 3, 8, 30),
        'outTime': DateTime(2024, 10, 3, 15, 0),
      }, 
      {'day': 4, 'inTime': null, 'outTime': null}, 
      
      {
        'day': 7,
        'inTime': DateTime(2024, 10, 7, 8, 0),
        'outTime': DateTime(2024, 10, 7, 17, 0),
      }, 
      {
        'day': 8,
        'inTime': DateTime(2024, 10, 8, 9, 15),
        'outTime': DateTime(2024, 10, 8, 15, 0),
      }, 
      {
        'day': 9,
        'inTime': DateTime(2024, 10, 9, 7, 30),
        'outTime': DateTime(2024, 10, 9, 15, 30),
      }, 
      {
        'day': 10,
        'inTime': DateTime(2024, 10, 10, 8, 30),
        'outTime': DateTime(2024, 10, 10, 15, 0),
      }, 
    ]);

    _addDummyMonth(2024, 11, [
      {
        'day': 1,
        'inTime': DateTime(2024, 11, 1, 8, 0),
        'outTime': DateTime(2024, 11, 1, 15, 0),
      }, 
      {
        'day': 4,
        'inTime': DateTime(2024, 11, 4, 9, 30),
        'outTime': DateTime(2024, 11, 4, 15, 0),
      }, 
      {
        'day': 5,
        'inTime': DateTime(2024, 11, 5, 7, 45),
        'outTime': DateTime(2024, 11, 5, 16, 0),
      }, 
      {'day': 6, 'inTime': null, 'outTime': null}, 
      {
        'day': 7,
        'inTime': DateTime(2024, 11, 7, 8, 15),
        'outTime': DateTime(2024, 11, 7, 15, 0),
      }, 
      {
        'day': 8,
        'inTime': DateTime(2024, 11, 8, 9, 0),
        'outTime': DateTime(2024, 11, 8, 18, 0),
      }, 
    ]);

    _addDummyMonth(2024, 12, [
      {
        'day': 2,
        'inTime': DateTime(2024, 12, 2, 7, 50),
        'outTime': DateTime(2024, 12, 2, 15, 0),
      }, 
      {
        'day': 3,
        'inTime': DateTime(2024, 12, 3, 8, 45),
        'outTime': DateTime(2024, 12, 3, 15, 0),
      }, 
      {
        'day': 4,
        'inTime': DateTime(2024, 12, 4, 9, 20),
        'outTime': DateTime(2024, 12, 4, 17, 30),
      }, 
      {'day': 5, 'inTime': null, 'outTime': null}, 
      {
        'day': 6,
        'inTime': DateTime(2024, 12, 6, 8, 0),
        'outTime': DateTime(2024, 12, 6, 15, 0),
      }, 
    ]);

    _addDummyMonth(2025, 1, [
      {
        'day': 2,
        'inTime': DateTime(2025, 1, 2, 8, 10),
        'outTime': DateTime(2025, 1, 2, 15, 0),
      }, 
      {
        'day': 3,
        'inTime': DateTime(2025, 1, 3, 9, 45),
        'outTime': DateTime(2025, 1, 3, 15, 0),
      }, 
      {
        'day': 6,
        'inTime': DateTime(2025, 1, 6, 7, 30),
        'outTime': DateTime(2025, 1, 6, 16, 30),
      },
      {
        'day': 7,
        'inTime': DateTime(2025, 1, 7, 8, 25),
        'outTime': DateTime(2025, 1, 7, 15, 0),
      }, 
      {'day': 8, 'inTime': null, 'outTime': null}, 
      {
        'day': 9,
        'inTime': DateTime(2025, 1, 9, 8, 0),
        'outTime': DateTime(2025, 1, 9, 18, 15),
      }, 
      {
        'day': 10,
        'inTime': DateTime(2025, 1, 10, 9, 10),
        'outTime': DateTime(2025, 1, 10, 15, 0),
      }, 
    ]);

    _addDummyMonth(2025, 2, [
      {
        'day': 3,
        'inTime': DateTime(2025, 2, 3, 8, 5),
        'outTime': DateTime(2025, 2, 3, 15, 0),
      }, 
      {
        'day': 4,
        'inTime': DateTime(2025, 2, 4, 9, 25),
        'outTime': DateTime(2025, 2, 4, 15, 30),
      }, 
      {
        'day': 5,
        'inTime': DateTime(2025, 2, 5, 7, 40),
        'outTime': DateTime(2025, 2, 5, 15, 0),
      }, 
      {
        'day': 6,
        'inTime': DateTime(2025, 2, 6, 8, 30),
        'outTime': DateTime(2025, 2, 6, 17, 0),
      }, 
      {'day': 7, 'inTime': null, 'outTime': null}, 
    ]);

    _addDummyMonth(2025, 8, [
      {
        'day': 1,
        'inTime': DateTime(2025, 8, 1, 8, 0),
        'outTime': DateTime(2025, 8, 1, 15, 0),
      }, 
      {
        'day': 2,
        'inTime': DateTime(2025, 8, 2, 9, 30),
        'outTime': DateTime(2025, 8, 2, 15, 0),
      },
      {
        'day': 5,
        'inTime': DateTime(2025, 8, 5, 7, 45),
        'outTime': DateTime(2025, 8, 5, 16, 15),
      }, 
      {
        'day': 6,
        'inTime': DateTime(2025, 8, 6, 8, 15),
        'outTime': DateTime(2025, 8, 6, 15, 0),
      }, 
      {'day': 7, 'inTime': null, 'outTime': null}, // Absent
      {
        'day': 8,
        'inTime': DateTime(2025, 8, 8, 8, 45),
        'outTime': DateTime(2025, 8, 8, 18, 30),
      }, 
      {
        'day': 9,
        'inTime': DateTime(2025, 8, 9, 9, 20),
        'outTime': DateTime(2025, 8, 9, 15, 0),
      }, 
      {
        'day': 12,
        'inTime': DateTime(2025, 8, 12, 7, 55),
        'outTime': DateTime(2025, 8, 12, 15, 0),
      }, 
    ]);

    notifyListeners();
    print("Dummy data added for multiple months and years!");
  }

  void _addDummyMonth(int year, int month, List<Map<String, dynamic>> records) {
    for (var record in records) {
      final date = DateTime(year, month, record['day']);
      _attHistory.add(
        AttendanceHistory(
          date: date,
          inTime: record['inTime'],
          outTime: record['outTime'],
        ),
      );

      _updateOrCreateSummary(date);
    }
  }
}
