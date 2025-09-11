import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/main.dart';
import 'package:hr_attendance_tracker/providers/auth_provider.dart';
import 'package:hr_attendance_tracker/providers/profile_provider.dart';
import 'package:hr_attendance_tracker/screens/auth/login_screen.dart';
import 'package:hr_attendance_tracker/screens/edit_profile_screen.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, ProfileProvider>(
      builder: (context, authProvider, profileProvider, child) {
        // print("=== AuthWrapper Debug ===");
        // print("Auth initialized: ${authProvider.isInitialized}");
        // print("User: ${authProvider.user?.uid}");
        // print("Profile: ${profileProvider.profile?.uid}");
        // print("Profile loading: ${profileProvider.isLoading}");
        // print("Profile error: ${profileProvider.errorMessage}");
        // print("========================");
        if (!authProvider.isInitialized) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (authProvider.user != null) {
          if (profileProvider.profile == null && !profileProvider.isLoading) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              profileProvider.loadProfile(authProvider.user!.uid);
            });
          }

          if (profileProvider.profile == null && profileProvider.isLoading) {
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading profile...'),
                  ],
                ),
              ),
            );
          }

          if (profileProvider.profile != null) {
            if (profileProvider.profile?.isNew == true ||
                profileProvider.profile?.isNew == null) {
              return const EditProfileScreen();
            }
            return const MainScreen();
          }

          if (profileProvider.errorMessage != null) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, color: Colors.red, size: 48),
                    SizedBox(height: 16),
                    Text(
                      'Failed to load profile',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(profileProvider.errorMessage ?? ''),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        profileProvider.loadProfile(authProvider.user!.uid);
                      },
                      child: Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
        }

        return const LoginScreen();
      },
    );
  }
}
