import 'package:flutter/material.dart';

class CustomBottomNavbar extends StatelessWidget {
  const CustomBottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // important to keep it tight
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: const Center(
            child: Text(
              'HR Attendance Tracker v1.0',
              style: TextStyle(color: Colors.brown),
            ),
          ),
        ),
        BottomNavigationBar(
          backgroundColor: Colors.brown,
          selectedItemColor: Colors.grey[200],
          unselectedItemColor: Colors.white,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ],
    );
  }
}
