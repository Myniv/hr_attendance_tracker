import 'package:flutter/foundation.dart';
import 'package:hr_attendance_tracker/models/attendance_summary.dart';

class AttendanceSummaryProvider extends ChangeNotifier {
  final List<AttendanceSummary> _attendanceSummary = [];
  List<AttendanceSummary> get attendanceSummary => _attendanceSummary;

  void updateAttendanceSummary(List<AttendanceSummary> newAttendanceSummary) {
    _attendanceSummary.clear();
    _attendanceSummary.addAll(newAttendanceSummary);
    notifyListeners();
  }
}
