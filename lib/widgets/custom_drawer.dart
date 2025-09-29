import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/custom_theme.dart';
import 'package:hr_attendance_tracker/providers/auth_provider.dart';
import 'package:hr_attendance_tracker/providers/profile_provider.dart';
import 'package:hr_attendance_tracker/routes.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  final CustomTheme _theme = CustomTheme();

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final authProvider = context.watch<AuthProvider>();

    return Drawer(
      backgroundColor: CustomTheme.backgroundScreenColor,
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [CustomTheme.colorYellow, CustomTheme.colorGold],
              ),
              boxShadow: [
                BoxShadow(
                  color: CustomTheme.colorBrown.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            color: CustomTheme.colorBrown,
                            size: 24,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ),

                    Spacer(),

                    InkWell(
                      // onTap: () => Navigator.pushNamed(context, '/profile'),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: CustomTheme.colorBrown,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  profileProvider.profile?.profilePicturePath !=
                                      null
                                  ? NetworkImage(
                                      profileProvider
                                          .profile!
                                          .profilePicturePath!,
                                    )
                                  : AssetImage('assets/images/profile.png'),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profileProvider.profile?.name ?? "User",
                                  style: _theme.mediumFont(
                                    CustomTheme.colorBrown,
                                    FontWeight.w500,
                                    context,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  profileProvider.profile?.position ?? "HR",
                                  style: _theme.smallFont(
                                    CustomTheme.colorBrown.withOpacity(0.7),
                                    FontWeight.bold,
                                    context,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  _buildMenuItem(
                    context: context,
                    icon: Icons.info_outline_rounded,
                    title: 'About',
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, '/about');
                    },
                  ),

                  _buildMenuItem(
                    context: context,
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, '/setting');
                    },
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.logout,
                    title: 'Logout',
                    onTap: () async {
                      final profileProvider = Provider.of<ProfileProvider>(
                        context,
                        listen: false,
                      );
                      profileProvider.clearProfile();

                      await authProvider.signOut();
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.login,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: CustomTheme.borderRadius,
        color: Colors.transparent,
      ),
      child: Container(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: CustomTheme.borderRadius,
          splashColor: CustomTheme.colorGold.withOpacity(0.1),
          highlightColor: CustomTheme.colorGold.withOpacity(0.05),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: CustomTheme.colorGold.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: CustomTheme.colorGold, size: 20),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: _theme.mediumFont(
                          CustomTheme.whiteButNot,
                          FontWeight.w600,
                          context,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: CustomTheme.colorGold.withOpacity(0.5),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
