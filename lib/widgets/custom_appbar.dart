import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/custom_theme.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? icon;
  final VoidCallback? onBack;
  final bool forceDrawer; // Add this parameter

  const CustomAppbar({
    super.key,
    required this.title,
    this.icon,
    this.onBack,
    this.forceDrawer = false,
  });

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    return AppBar(
      backgroundColor: CustomTheme.colorBrown,
      title: Text(title, style: TextStyle(color: Colors.white)),
      leading: forceDrawer
          ? Builder(
              builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: Icon(Icons.menu, color: Colors.white),
              ),
            )
          : (canPop
                ? IconButton(
                    onPressed: onBack ?? () => Navigator.of(context).pop(),
                    icon: Icon(icon ?? Icons.arrow_back),
                    color: Colors.white,
                  )
                : Builder(
                    builder: (context) => IconButton(
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      icon: Icon(Icons.menu, color: Colors.white),
                    ),
                  )),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
