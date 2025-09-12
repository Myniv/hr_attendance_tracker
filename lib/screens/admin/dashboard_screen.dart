import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/custom_theme.dart';
import 'package:hr_attendance_tracker/providers/attendance_history_provider.dart';
import 'package:hr_attendance_tracker/providers/profile_provider.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().loadAllProfiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);
    final profiles = provider.allProfiles;
    final provAttendance = Provider.of<AttendanceHistoryProvider>(context);
    final attHistory = provAttendance.attHistory;

    return Scaffold(
      backgroundColor: CustomTheme.backgroundScreenColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Dashboard",
                  style: CustomTheme().largeFont(
                    CustomTheme.colorYellow,
                    FontWeight.w600,
                    context,
                  ),
                ),
                cardTitleValue("Total Users", profiles.length.toString()),
                const SizedBox(height: 16),
                cardTitleValue("Total Attends", attHistory.length.toString()),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget cardTitleValue(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: CustomTheme.colorLightBrown,
        border: Border.all(color: CustomTheme.colorGold, width: 2),
        borderRadius: CustomTheme.borderRadius,
        boxShadow: [
          BoxShadow(
            color: CustomTheme.colorBrown.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: CustomTheme().mediumFont(
              CustomTheme.whiteButNot,
              FontWeight.w600,
              context,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: CustomTheme().largeFont(
              CustomTheme.whiteButNot,
              FontWeight.w600,
              context,
            ),
          ),
        ],
      ),
    );
  }
}
