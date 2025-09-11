import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/screens/about_screen.dart';
import 'package:hr_attendance_tracker/screens/auth/login_screen.dart';
import 'package:hr_attendance_tracker/screens/auth/register_screen.dart';
import 'package:hr_attendance_tracker/screens/tab/attendance/attendance_history_tab.dart';
import 'package:hr_attendance_tracker/screens/edit_profile_screen.dart';
import 'package:hr_attendance_tracker/screens/home_screen.dart';
import 'package:hr_attendance_tracker/screens/not_found_screen.dart';
import 'package:hr_attendance_tracker/screens/profile_screen.dart';
import 'package:hr_attendance_tracker/screens/setting_screen.dart';

class AppRoutes {
  // static const String home = '/';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String attendance = '/attendance';
  static const String about = '/about';
  static const String setting = '/setting';
  static const register = '/register';
  static const login = '/login';

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
      default:
        return MaterialPageRoute(builder: (_) => NotFoundScreen());
    }
  }
}
