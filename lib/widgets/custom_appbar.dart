import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/custom_theme.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? icon;
  final VoidCallback? onBack;
  const CustomAppbar({super.key, required this.title, this.icon, this.onBack});

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    return AppBar(
      backgroundColor: CustomTheme.colorBrown,
      title: Text(title, style: TextStyle(color: Colors.white)),
      leading: canPop
          ? IconButton(
              onPressed: onBack,
              icon: Icon(icon),
              color: Colors.white,
            )
          : Builder(
              builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: Icon(Icons.menu, color: Colors.white),
              ),
            ),
      // actions: [
      //   IconButton(
      //     icon: Icon(Icons.edit, color: Colors.white),
      //     onPressed: () {},
      //   ),
      // ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
