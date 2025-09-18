import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hr_attendance_tracker/models/attendance_history.dart';
import 'package:hr_attendance_tracker/models/attendance_summary.dart';
import 'package:hr_attendance_tracker/services/attendance_history_services.dart';

class AttendanceHistoryProvider extends ChangeNotifier {
  List<AttendanceHistory> _attHistory = [];
  List<AttendanceSummary> _summaries = [];
  AttendanceHistory? _currentAttendance;
  bool _isLoading = false;
  String? _errorMessage;
  String? _employeeId;
  int? _currentAttendanceId;
  bool _isClockOut = false;

  List<AttendanceHistory> get attHistory => _attHistory;
  List<AttendanceSummary> get summaries => _summaries;
  AttendanceHistory? get currentAttendance => _currentAttendance;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get employeeId => _employeeId;
  int? get currentAttendanceId => _currentAttendanceId;
  bool get isClockOut => _isClockOut;

  bool _isUploadingPhoto = false;
  bool get isUploadingPhoto => _isUploadingPhoto;

  File? _selectedImageFile;
  File? get selectedImageFile => _selectedImageFile;

  final AttendanceHistoryServices _attendanceHistoryServices =
      AttendanceHistoryServices();

  bool _isClockIn = false;
  DateTime? _clockInTime;
  DateTime? _clockOutTime;

  bool get isClockIn => _isClockIn;
  DateTime? get clockInTime => _clockInTime;
  DateTime? get clockOutTime => _clockOutTime;

  Future<void> loadClockStatus() async {
    _isClockIn = await _attendanceHistoryServices.loadIsClockIn() ?? false;
    _isClockOut = await _attendanceHistoryServices.loadIsClockOut() ?? false;
    _clockInTime = await _attendanceHistoryServices.loadClockInTime();
    _clockOutTime = await _attendanceHistoryServices.loadClockOutTime();
    notifyListeners();
  }

  void _setUploadingPhoto(bool value) {
    _isUploadingPhoto = value;
    notifyListeners();
  }

  void setCurrentAttendance(AttendanceHistory attendance) {
    _currentAttendance = attendance;
    notifyListeners();
  }

  Future<void> fetchAttendanceHistoryByEmployeeId() async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      _employeeId = await _attendanceHistoryServices.loadEmployeeId();
      print(_employeeId);
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

  Future<void> clockIn(
    DateTime inTime,
    String clockInLatLong,
    File clockInPhoto,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final clockInPhotoUrl = await uploadProfilePhoto(
        clockInPhoto,
        _employeeId!,
        true,
      );

      final today = DateTime.now();
      final data = AttendanceHistory(
        date: today,
        in_time: inTime,
        employee_id: _employeeId,
        in_photo: clockInPhotoUrl,
        in_latlong: clockInLatLong,
      );

      final attendance = await _attendanceHistoryServices.clockIn(data);
      await _attendanceHistoryServices.saveAttendanceId(attendance.id!);
      await _attendanceHistoryServices.saveIsClockIn(true);
      await _attendanceHistoryServices.saveClockInTime(inTime);

      _isClockIn = true;
      _isClockOut = false;
      _clockInTime = inTime;
      _clockOutTime = null;

      _errorMessage = null;
    } catch (e) {
      _errorMessage = "Failed to clock in: ${e.toString()}";
      print("Failed to clock in: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clockOut(
    DateTime outTime,
    String clockOutLatLong,
    File clockOutPhoto,
  ) async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
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

      final clockOutPhotoUrl = await uploadProfilePhoto(
        clockOutPhoto,
        _employeeId!,
        true,
      );

      final today = DateTime.now();
      final data = AttendanceHistory(
        id: attendanceId,
        date: today,
        out_time: outTime,
        employee_id: _employeeId,
        out_photo: clockOutPhotoUrl,
        out_latlong: clockOutLatLong,
        status: "attend",
      );

      print("Employee ID: $_employeeId");

      await _attendanceHistoryServices.clockOut(data);

      await _attendanceHistoryServices.saveAttendanceId(null);
      await _attendanceHistoryServices.saveIsClockOut(true);
      await _attendanceHistoryServices.saveClockOutTime(outTime);

      _isClockOut = true;
      _clockOutTime = outTime;

      _errorMessage = null;

      await fetchAttendanceHistoryByEmployeeId();
    } catch (e) {
      _errorMessage = "Failed to clock out: ${e.toString()}";
      print("Failed to clock out: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> uploadProfilePhoto(File file, String uid, bool clockIn) async {
    _setUploadingPhoto(true);
    _errorMessage = null;
    notifyListeners();
    try {
      final url = await _attendanceHistoryServices.uploadClockInOutPhoto(
        uid,
        file,
        clockIn,
      );

      _errorMessage = null;
      notifyListeners();
      return url;
    } catch (e) {
      _errorMessage = "Failed to upload photo: $e";
      notifyListeners();
      rethrow;
    } finally {
      _setUploadingPhoto(false);
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
