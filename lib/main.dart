import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/custom_theme.dart';
import 'package:hr_attendance_tracker/providers/attendance_history_provider.dart';
import 'package:hr_attendance_tracker/providers/auth_provider.dart';
import 'package:hr_attendance_tracker/providers/profile_provider.dart';
import 'package:hr_attendance_tracker/routes.dart';
import 'package:hr_attendance_tracker/screens/admin/dashboard_screen.dart';
import 'package:hr_attendance_tracker/screens/admin/profile_list_screen.dart';
import 'package:hr_attendance_tracker/screens/attendance_screen.dart';
import 'package:hr_attendance_tracker/screens/auth/auth_wrapper.dart';
import 'package:hr_attendance_tracker/widgets/custom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:hr_attendance_tracker/screens/home_screen.dart';
import 'package:hr_attendance_tracker/widgets/bottom_navbar.dart';
import 'package:hr_attendance_tracker/widgets/custom_appbar.dart';
import 'package:hr_attendance_tracker/screens/profile_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

late List<CameraDescription> cameras;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  await Firebase.initializeApp(
    options: FirebaseOptions(
      projectId: 'hr-attendance-tracker-471814', // Project ID
      messagingSenderId: '654813655804', //Project Number
      apiKey: 'AIzaSyCv9eLhtKcVUTpZRNPG3zjN8BSzelthLbY', //Web API Key
      appId: '1:654813655804:android:a6d18e1158480b7ef6dd79',
    ), // App ID
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: false,
  );
  await Supabase.initialize(
    url: 'https://ltvskbkhdfgvkveqaxpg.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx0dnNrYmtoZGZndmt2ZXFheHBnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc1MjU3NjUsImV4cCI6MjA3MzEwMTc2NX0.i2YH6LvyAwkreZ11f-NbUkQBq7oQ5xuKHqe9sIEWhGE',
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AttendanceHistoryProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Sample Portfolio App",
      debugShowCheckedModeBanner: false,
      // home: MainScreen(),
      home: AuthWrapper(),
      onGenerateRoute: AppRoutes.generateRoute,
      initialRoute: AppRoutes.splash,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  List<Widget> _screens = [];

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _changeScreen(List<Widget> screen) {
    setState(() {
      _screens = screen;
    });
  }

  final List<String> _titleScreen = ["Home", "Attendance", "Profile"];
  final List<IconData> _iconScreen = [
    Icons.home,
    Icons.access_time,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    final List<Widget> _screensMember = [
      HomeScreen(onTabSelected: _changeTab),
      AttendanceScreen(),
      ProfileScreen(),
    ];
    final List<Widget> _screensAdmin = [
      DashboardScreen(),
      AttendanceScreen(),
      ProfileListScreen(),
    ];

    // late final List<Widget> _screens = profileProvider.profile?.role == "admin"
    //     ? _screensAdmin
    //     : _screensMember;
    if (profileProvider.profile?.role == "admin") {
      _changeScreen(_screensAdmin);
    } else {
      _changeScreen(_screensMember);
    }
    return Scaffold(
      appBar: CustomAppbar(
        title: _titleScreen[_currentIndex],
        forceDrawer: true,
      ), // AppBar(title: Text(_titleScreen[_currentIndex]),),
      backgroundColor: CustomTheme.backgroundScreenColor,
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: _currentIndex,
        title: _titleScreen,
        icon: _iconScreen,
        onTap: _changeTab,
      ),
      drawer: CustomDrawer(),
    );
  }
}
