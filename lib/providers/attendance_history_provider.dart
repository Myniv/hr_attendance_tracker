import 'package:flutter/foundation.dart';
import 'package:hr_attendance_tracker/models/attendance_history.dart';
import 'package:hr_attendance_tracker/models/attendance_summary.dart';
import 'package:hr_attendance_tracker/services/attendance_history_services.dart';

class AttendanceHistoryProvider extends ChangeNotifier {
  List<AttendanceHistory> _attHistory = [];
  List<AttendanceSummary> _summaries = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _employeeId;
  int? _currentAttendanceId;
  bool _isClockOut = false;

  List<AttendanceHistory> get attHistory => _attHistory;
  List<AttendanceSummary> get summaries => _summaries;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get employeeId => _employeeId;
  int? get currentAttendanceId => _currentAttendanceId;
  bool get isClockOut => _isClockOut;

  final AttendanceHistoryServices _attendanceHistoryServices =
      AttendanceHistoryServices();

  Future<void> fetchAttendanceHistoryByEmployeeId() async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      _employeeId = await _attendanceHistoryServices.loadEmployeeId();
      await _attendanceHistoryServices.saveEmployeeId(_employeeId!);

      _attHistory = await _attendanceHistoryServices.getAttendanceByEmployeeId(
        _employeeId!,
      );

      _errorMessage = null;
    } catch (e) {
      _errorMessage = "Failed to load attendance history: ${e.toString()}";
      _attHistory = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clockIn(DateTime inTime) async {
    _isLoading = true;
    notifyListeners();

    final today = DateTime.now();
    final data = AttendanceHistory(
      date: today,
      in_time: inTime,
      employee_id: _employeeId,
    );

    try {
      final attendance = await _attendanceHistoryServices.clockIn(data);
      await _attendanceHistoryServices.saveAttendanceId(attendance.id!);
      await _attendanceHistoryServices.saveIsClockIn(true);
      await _attendanceHistoryServices.saveClockInTime(inTime);

      _errorMessage = null;
    } catch (e) {
      _errorMessage = "Failed to clock in: ${e.toString()}";
      print("Failed to clock in: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clockOut(DateTime outTime) async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      // Ensure employee ID is available
      if (_employeeId == null) {
        _employeeId = await _attendanceHistoryServices.loadEmployeeId();
        if (_employeeId == null) {
          _errorMessage = "Employee ID not found. Please clock in first.";
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      final attendanceId = await _attendanceHistoryServices.loadAttendanceId();

      if (attendanceId == null) {
        _errorMessage =
            "No active clock-in session found. Please clock in first.";
        _isLoading = false;
        notifyListeners();
        return;
      }

      final today = DateTime.now();
      final data = AttendanceHistory(
        id: attendanceId,
        date: today,
        out_time: outTime,
        employee_id: _employeeId,
      );

      print("Employee ID: $_employeeId");

      await _attendanceHistoryServices.clockOut(data);

      // Update SharedPreferences
      await _attendanceHistoryServices.saveAttendanceId(
        null,
      ); // Clear attendance ID
      await _attendanceHistoryServices.saveIsClockOut(true);
      await _attendanceHistoryServices.saveClockOutTime(outTime);

      _errorMessage = null;

      // Refresh attendance history to show the updated record
      await fetchAttendanceHistoryByEmployeeId();
    } catch (e) {
      _errorMessage = "Failed to clock out: ${e.toString()}";
      print("Failed to clock out: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
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

  // Add a method to manually refresh data
  Future<void> refreshData() async {
    await fetchAttendanceHistoryByEmployeeId();
  }

  // Add a method to clear error messages
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
