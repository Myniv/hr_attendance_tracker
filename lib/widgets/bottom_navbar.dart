import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/custom_theme.dart';

class CustomBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<String> title;
  final List<IconData> icon;
  const CustomBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // important to keep it tight
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: CustomTheme.backgroundScreenColor),
          child: const Center(
            child: Text(
              'HR Attendance Tracker v1.0',
              style: TextStyle(color: CustomTheme.whiteButNot),
            ),
          ),
        ),
        BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          elevation: 0,
          backgroundColor: CustomTheme.colorBrown,
          selectedItemColor: Colors.grey[200],
          unselectedItemColor: Colors.white,
          items: <BottomNavigationBarItem>[
            for (int i = 0; i < title.length; i++)
              BottomNavigationBarItem(icon: Icon(icon[i]), label: title[i]),
          ],
        ),
      ],
    );
  }
}
