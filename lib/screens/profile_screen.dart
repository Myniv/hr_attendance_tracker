import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hr_attendance_tracker/custom_theme.dart';
import 'package:hr_attendance_tracker/providers/profile_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              buildProfileHeader(
                context,
                profileProvider.profile.name,
                profileProvider.profile.position,
                profileProvider.profile.profilePicturePath,
                profileProvider.profile.dob,
              ),
              SizedBox(height: 20),
              buildProfileInfo(
                context,
                profileProvider.profile.name,
                profileProvider.profile.email,
                profileProvider.profile.phone,
                profileProvider.profile.dob,
              ),
              SizedBox(height: 20),
              buildLocationInfo(
                context,
                profileProvider.profile.employeeId,
                profileProvider.profile.dateOfJoining,
                profileProvider.profile.department,
                profileProvider.profile.position,
                profileProvider.profile.location,
              ),
            ],
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
      padding: const EdgeInsets.all(10.0),
      height: 150,
      decoration: BoxDecoration(
        color: CustomTheme.colorLightBrown,
        border: Border.all(color: CustomTheme.colorGold, width: 2),
        borderRadius: CustomTheme.borderRadius,
      ),
      child: Stack(
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: profilePicturePath != null
                      ? FileImage(File(profilePicturePath))
                      : AssetImage('assets/images/profile.png'),
                ),
                const SizedBox(width: 20),
                Column(
                  mainAxisSize: MainAxisSize.min, // shrink to fit children
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 300,
                      child: Text(
                        name ?? "Unknown",
                        style: CustomTheme().smallFont(
                          Colors.white,
                          null,
                          context,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      position ?? "Unknown",
                      style: CustomTheme().superSmallFont(
                        Colors.white,
                        FontWeight.normal,
                        context,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      dateOfBirth != null
                          ? "${dateOfBirth.day}/${dateOfBirth.month}/${dateOfBirth.year}"
                          : "Unknown",
                      style: CustomTheme().superSmallFont(
                        Colors.white,
                        FontWeight.normal,
                        context,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Positioned(
          //   top: 0,
          //   right: 0,
          //   child: IconButton(
          //     icon: Icon(Icons.edit, color: Colors.white),
          //     onPressed: () {},
          //   ),
          // ),
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
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CustomTheme.whiteButNot,
        border: Border.all(color: CustomTheme.colorGold, width: 2),
        borderRadius: CustomTheme.borderRadius,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
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
                style: CustomTheme().smallFont(
                  CustomTheme.colorBrown,
                  null,
                  context,
                ),
              ),

              IconButton(
                icon: Icon(Icons.edit, color: CustomTheme.colorBrown),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/edit-profile',
                    arguments: {'isPersonal': true},
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 5),
          buildInfoRow('Name', name ?? "Unknown", Icons.info, context),
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
            Icons.calendar_month,
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
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CustomTheme.whiteButNot,
        border: Border.all(color: CustomTheme.colorGold, width: 2),
        borderRadius: CustomTheme.borderRadius,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
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
                style: CustomTheme().smallFont(
                  CustomTheme.colorBrown,
                  null,
                  context,
                ),
              ),

              IconButton(
                icon: Icon(Icons.edit, color: CustomTheme.colorBrown),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/edit-profile',
                    arguments: {'isPersonal': false},
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 5),
          buildInfoRow(
            'Employee Id',
            employeeId != null ? employeeId.toString() : "Unknown",
            Icons.info,
            context,
          ),
          buildInfoRow(
            'Date Of Joining',
            dateOfJoining != null
                ? "${dateOfJoining.day}/${dateOfJoining.month}/${dateOfJoining.year}"
                : "Unknown",
            Icons.date_range,
            context,
          ),
          buildInfoRow(
            'Department',
            department ?? "Unknown",
            Icons.location_city,
            context,
          ),
          buildInfoRow('Position', position ?? "Unknown", Icons.build, context),
          buildInfoRow(
            'Location',
            location != null ? location : "Unknown",
            Icons.location_pin,
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
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: CustomTheme.colorBrown)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(iconF, color: CustomTheme.colorBrown),
          SizedBox(width: 10),
          SizedBox(
            width: 300,
            child: Text(
              label,
              style: CustomTheme().superSmallFont(
                CustomTheme.colorLightBrown,
                FontWeight.bold,
                context,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: CustomTheme().superSmallFont(
                  CustomTheme.colorLightBrown,
                  FontWeight.normal,
                  context,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
