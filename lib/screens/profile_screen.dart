import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hr_attendance_tracker/custom_theme.dart';
import 'package:hr_attendance_tracker/providers/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final String? uid = args?['uid'];

      if (uid != null) {
        print("Loading profile for UID: $uid");
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final profileProvider = context.read<ProfileProvider>();
          try {
            final selectedProfile = profileProvider.allProfiles.firstWhere(
              (profile) => profile.uid == uid,
            );
            profileProvider.setProfile2(selectedProfile);
            print("Profile loaded: ${selectedProfile.name}");
          } catch (e) {
            print("Profile not found for UID: $uid");
          }
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final profileProvider = context.read<ProfileProvider>();
          try {
            profileProvider.setProfile(profileProvider.profile!);
            print("Profile loaded: ${profileProvider.profile?.name}");
          } catch (e) {
            print("Profile not found for UID: $uid");
          }
        });
      }
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String? uid = args?['uid'];

    print("Profile 2: ${profileProvider.profile2?.name}");
    print("Profile 1: ${profileProvider.profile?.name}");

    var profile = uid != null
        ? profileProvider.profile2
        : profileProvider.profile;

    return Scaffold(
      backgroundColor: CustomTheme.backgroundScreenColor,
      appBar: AppBar(
        backgroundColor: CustomTheme.colorLightBrown,
        foregroundColor: Colors.white,
        title: Text(profile?.name ?? 'Profile'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                buildProfileHeader(
                  context,
                  profile?.name,
                  profile?.position,
                  profile?.profilePicturePath,
                  profile?.dob,
                ),
                SizedBox(height: 20),
                buildProfileInfo(
                  context,
                  profile?.name,
                  profile?.email,
                  profile?.phone,
                  profile?.dob,
                  uid,
                ),
                SizedBox(height: 20),
                buildLocationInfo(
                  context,
                  profile?.employeeId,
                  profile?.dateOfJoining,
                  profile?.department,
                  profile?.position,
                  profile?.location,
                  uid,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProfileHeader(
    BuildContext context,
    String? name,
    String? position,
    String? profilePicturePath,
    DateTime? dateOfBirth,
  ) {
    return Container(
      padding: const EdgeInsets.all(20.0),
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
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: CustomTheme.colorGold, width: 3),
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundImage:
                  profilePicturePath != null && profilePicturePath.isNotEmpty
                  ? NetworkImage(profilePicturePath)
                  : AssetImage('assets/images/profile.png') as ImageProvider,
              backgroundColor: CustomTheme.colorGold.withOpacity(0.3),
              child: (profilePicturePath == null || profilePicturePath.isEmpty)
                  ? Icon(Icons.person, size: 50, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name ?? "Unknown",
                  style: CustomTheme().mediumFont(
                    Colors.white,
                    FontWeight.w700,
                    context,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 8),
                Text(
                  position ?? "Unknown Position",
                  style: CustomTheme().smallFont(
                    Colors.white.withOpacity(0.9),
                    FontWeight.w500,
                    context,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateOfBirth != null
                      ? "Born: ${dateOfBirth.day}/${dateOfBirth.month}/${dateOfBirth.year}"
                      : "Birth date unknown",
                  style: CustomTheme().superSmallFont(
                    Colors.white.withOpacity(0.8),
                    FontWeight.w400,
                    context,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfileInfo(
    BuildContext context,
    String? name,
    String? email,
    String? phone,
    DateTime? dob,
    String? uid,
  ) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CustomTheme.whiteButNot,
        border: Border.all(color: CustomTheme.colorGold, width: 2),
        borderRadius: CustomTheme.borderRadius,
        boxShadow: [
          BoxShadow(
            color: CustomTheme.colorBrown.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PERSONAL INFORMATION',
                style: CustomTheme().mediumFont(
                  CustomTheme.colorBrown,
                  FontWeight.w700,
                  context,
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit_rounded, color: CustomTheme.colorBrown),
                onPressed: () async {
                  if (uid == null) {
                    Navigator.pushNamed(context, '/edit-profile');
                  } else {
                    Navigator.pushNamed(
                      context,
                      '/edit-profile',
                      arguments: {'uid': uid},
                    );
                  }

                  if (mounted) {
                    final profileProvider = context.read<ProfileProvider>();
                    if (uid != null) {
                      await profileProvider.loadAllProfiles();
                      try {
                        final updatedProfile = profileProvider.allProfiles
                            .firstWhere((profile) => profile.uid == uid);
                        profileProvider.setProfile2(updatedProfile);
                      } catch (e) {
                        print("Error finding updated profile: $e");
                      }
                    } else {
                      final currentUid = profileProvider.profile?.uid;
                      if (currentUid != null) {
                        await profileProvider.loadProfile(currentUid);
                      }
                    }
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          buildInfoRow('Name', name ?? "Unknown", Icons.person, context),
          buildInfoRow('Email', email ?? "Unknown", Icons.email, context),
          buildInfoRow(
            'Phone Number',
            phone ?? "Unknown",
            Icons.phone,
            context,
          ),
          buildInfoRow(
            'Date of Birth',
            dob != null ? "${dob.day}/${dob.month}/${dob.year}" : "Unknown",
            Icons.cake,
            context,
          ),
        ],
      ),
    );
  }

  Widget buildLocationInfo(
    BuildContext context,
    int? employeeId,
    DateTime? dateOfJoining,
    String? department,
    String? position,
    String? location,
    String? uid,
  ) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CustomTheme.whiteButNot,
        border: Border.all(color: CustomTheme.colorGold, width: 2),
        borderRadius: CustomTheme.borderRadius,
        boxShadow: [
          BoxShadow(
            color: CustomTheme.colorBrown.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'WORK INFORMATION',
                style: CustomTheme().mediumFont(
                  CustomTheme.colorBrown,
                  FontWeight.w700,
                  context,
                ),
              ),
              // IconButton(
              //   icon: Icon(Icons.edit_rounded, color: CustomTheme.colorBrown),
              //   onPressed: () async {
              //     Navigator.pushNamed(
              //       context,
              //       '/edit-profile',
              //       arguments: {'uid': uid},
              //     );

              //     if (mounted) {
              //       final profileProvider = context.read<ProfileProvider>();
              //       if (uid != null) {
              //         await profileProvider.loadAllProfiles();
              //         try {
              //           final updatedProfile = profileProvider.allProfiles
              //               .firstWhere((profile) => profile.uid == uid);
              //           profileProvider.setProfile2(updatedProfile);
              //         } catch (e) {
              //           print("Error finding updated profile: $e");
              //         }
              //       } else {
              //         final currentUid = profileProvider.profile?.uid;
              //         if (currentUid != null) {
              //           await profileProvider.loadProfile(currentUid);
              //         }
              //       }
              //     }
              //   },
              // ),
            ],
          ),
          SizedBox(height: 10),
          buildInfoRow(
            'Employee ID',
            employeeId != null ? employeeId.toString() : "Unknown",
            Icons.badge,
            context,
          ),
          buildInfoRow(
            'Date of Joining',
            dateOfJoining != null
                ? "${dateOfJoining.day}/${dateOfJoining.month}/${dateOfJoining.year}"
                : "Unknown",
            Icons.date_range,
            context,
          ),
          buildInfoRow(
            'Department',
            department ?? "Unknown",
            Icons.business,
            context,
          ),
          buildInfoRow('Position', position ?? "Unknown", Icons.work, context),
          buildInfoRow(
            'Location',
            location ?? "Unknown",
            Icons.location_on,
            context,
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow(
    String label,
    String value,
    IconData iconF,
    BuildContext context,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: CustomTheme.colorGold.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(iconF, color: CustomTheme.colorBrown, size: 20),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: CustomTheme().smallFont(
                CustomTheme.colorLightBrown,
                FontWeight.w600,
                context,
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: CustomTheme().smallFont(
                CustomTheme.colorBrown,
                FontWeight.w500,
                context,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
