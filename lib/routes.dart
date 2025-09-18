import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/screens/about_screen.dart';
import 'package:hr_attendance_tracker/screens/attendance_detail_screen.dart';
import 'package:hr_attendance_tracker/screens/auth/login_screen.dart';
import 'package:hr_attendance_tracker/screens/auth/register_screen.dart';
import 'package:hr_attendance_tracker/screens/clock_inout_screen.dart';
import 'package:hr_attendance_tracker/screens/custom_splash_screen.dart';
import 'package:hr_attendance_tracker/screens/tab/attendance/attendance_history_tab.dart';
import 'package:hr_attendance_tracker/screens/edit_profile_screen.dart';
import 'package:hr_attendance_tracker/screens/home_screen.dart';
import 'package:hr_attendance_tracker/screens/not_found_screen.dart';
import 'package:hr_attendance_tracker/screens/profile_screen.dart';
import 'package:hr_attendance_tracker/screens/setting_screen.dart';

class AppRoutes {
  // static const String home = '/';
  static const profile = '/profile';
  static const editProfile = '/edit-profile';
  static const attendance = '/attendance';
  static const about = '/about';
  static const setting = '/setting';
  static const register = '/register';
  static const login = '/login';
  static const splash = '/splash';
  static const clockInOut = '/clockInOut';
  static const attendanceDetail = '/attendance-history-detail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // case home:
      //   return MaterialPageRoute(
      //     builder: (_) => HomeScreen(),
      //     settings: settings,
      //   );
      case profile:
        return MaterialPageRoute(
          builder: (_) => ProfileScreen(),
          settings: settings,
        );
      case editProfile:
        return MaterialPageRoute(
          builder: (_) => EditProfileScreen(),
          settings: settings,
        );
      case attendance:
        return MaterialPageRoute(
          builder: (_) => AttendanceHistoryTab(),
          settings: settings,
        );
      case about:
        return MaterialPageRoute(
          builder: (_) => AboutScreen(),
          settings: settings,
        );
      case setting:
        return MaterialPageRoute(
          builder: (_) => SettingScreen(),
          settings: settings,
        );
      case login:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
          settings: settings,
        );
      case register:
        return MaterialPageRoute(
          builder: (_) => RegisterScreen(),
          settings: settings,
        );
      case splash:
        return MaterialPageRoute(
          builder: (_) => CustomSplashScreen(),
          settings: settings,
        );
      case clockInOut:
        return MaterialPageRoute(
          builder: (_) => ClockInOutScreen(),
          settings: settings,
        );
      case attendanceDetail:
        return MaterialPageRoute(
          builder: (_) => AttendanceDetailScreen(),
          settings: settings,
        );
      
      default:
        return MaterialPageRoute(builder: (_) => NotFoundScreen());
    }
  }
}
