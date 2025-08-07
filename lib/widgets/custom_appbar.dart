import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? icon;
  final VoidCallback? onBack;
  const CustomAppbar({super.key, required this.title, this.icon, this.onBack});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.brown,
      leading: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onBack,
      ),
      title: Text(title, style: TextStyle(color: Colors.white)),
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
