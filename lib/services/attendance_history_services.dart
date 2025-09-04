import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:hr_attendance_tracker/models/attendance_history.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceHistoryServices {
  static const String baseUrl = "http://10.0.2.2:7190/api/attendance/";

  Future<List<AttendanceHistory>> getAllAttendance() async {
    try {
      final response = await http
          .get(
            Uri.parse(baseUrl),
            headers: {"Content-Type": "application/json"},
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData
            .map((item) => AttendanceHistory.fromJson(item))
            .toList();
      } else {
        throw Exception(
          "Failed to load attendance. Status: ${response.statusCode}, Body: ${response.body}",
        );
      }
    } catch (e) {
      throw Exception("Error fetching attendance: $e");
    }
  }

  Future<List<AttendanceHistory>> getAttendanceByEmployeeId(
    int employeeId,
  ) async {
    try {
      final url = "${baseUrl}by-employee/$employeeId";

      final response = await http
          .get(Uri.parse(url), headers: {"Content-Type": "application/json"})
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        List<AttendanceHistory> attendanceList = jsonData
            .map((item) => AttendanceHistory.fromJson(item))
            .toList();

        return attendanceList;
      } else {
        throw Exception(
          "Failed to load attendance for employee $employeeId. Status: ${response.statusCode}, Body: ${response.body}",
        );
      }
    } catch (e) {
      throw Exception("Error fetching attendance for employee $employeeId: $e");
    }
  }

  Future<AttendanceHistory> clockIn(AttendanceHistory attendanceHistory) async {
    try {
      final body = {
        "date": attendanceHistory.date.toIso8601String(),
        "in_time": attendanceHistory.in_time?.toIso8601String(),
        "employee_id": attendanceHistory.employee_id ?? 1,
      };

      final url = "${baseUrl}clock-in";

      final response = await http
          .post(
            Uri.parse(url),
            headers: {"Content-Type": "application/json"},
            body: json.encode(body),
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 201 || response.statusCode == 200) {
        return AttendanceHistory.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          "Failed to clock in. Status: ${response.statusCode}, Body: ${response.body}",
        );
      }
    } catch (e) {
      throw Exception("Error clocking in: $e");
    }
  }

  Future<void> clockOut(AttendanceHistory attendanceHistory) async {
    try {
      final body = {
        "date": attendanceHistory.date.toIso8601String(),
        "out_time": attendanceHistory.out_time?.toIso8601String(),
      };

      final url = "${baseUrl}clock-out/${attendanceHistory.id}";

      final response = await http
          .put(
            Uri.parse(url),
            headers: {"Content-Type": "application/json"},
            body: json.encode(body),
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
          "Failed to clock out. Status: ${response.statusCode}, Body: ${response.body}",
        );
      }
    } catch (e) {
      throw Exception("Error clocking out: $e");
    }
  }

  Future<void> saveEmployeeId(int employeeId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt("employee_id", employeeId);
    } catch (e) {
      throw Exception("Failed to save employee ID");
    }
  }

  Future<int?> loadEmployeeId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final employeeId = prefs.getInt("employee_id");
      return employeeId;
    } catch (e) {
      return null;
    }
  }

  Future<void> saveAttendanceId(int? id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (id == null) {
        await prefs.remove("attendance_id");
      } else {
        await prefs.setInt("attendance_id", id);
      }
    } catch (e) {
      throw Exception("Failed to save attendance ID");
    }
  }

  Future<int?> loadAttendanceId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final attendanceId = prefs.getInt("attendance_id");
      return attendanceId;
    } catch (e) {
      return null;
    }
  }

  Future<void> saveIsClockOut(bool isClockOut) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("is_clock_out", isClockOut);
    } catch (e) {
      throw Exception("Failed to save clock out status");
    }
  }

  Future<bool?> loadIsClockOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool("is_clock_out");
    } catch (e) {
      return null;
    }
  }

  Future<void> saveIsClockIn(bool isClockIn) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("is_clock_in", isClockIn);
    } catch (e) {
      throw Exception("Failed to save clock in status");
    }
  }

  Future<bool?> loadIsClockIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isClockIn = prefs.getBool("is_clock_in");
      return isClockIn;
    } catch (e) {
      return null;
    }
  }

  Future<DateTime?> saveClockInTime(DateTime inTime) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("clock_in_time", inTime.toIso8601String());
      return inTime;
    } catch (e) {
      throw Exception("Failed to save clock in time");
    }
  }

  Future<DateTime?> loadClockInTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final clockInTimeStr = prefs.getString("clock_in_time");
      if (clockInTimeStr != null) {
        return DateTime.parse(clockInTimeStr);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<DateTime?> saveClockOutTime(DateTime outTime) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("clock_out_time", outTime.toIso8601String());
      return outTime;
    } catch (e) {
      throw Exception("Failed to save clock out time");
    }
  }

  Future<DateTime?> loadClockOutTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final clockOutTimeStr = prefs.getString("clock_out_time");
      if (clockOutTimeStr != null) {
        return DateTime.parse(clockOutTimeStr);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  clearAllPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
