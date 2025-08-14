import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/custom_theme.dart';
import 'package:hr_attendance_tracker/models/profile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.backgroundScreenColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                buildProfileHeader(context),
                SizedBox(height: 20),
                buildProfileInfo(context),
                SizedBox(height: 20),
                buildLocationInfo(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProfileHeader(BuildContext context) {
    final profile = Profile();
    final today = DateTime.now();
    final formattedDate = "${today.day}/${today.month}/${today.year}";

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
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),
                const SizedBox(width: 20),
                Column(
                  mainAxisSize: MainAxisSize.min, // shrink to fit children
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      style: CustomTheme().smallFont(
                        Colors.white,
                        null,
                        context,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      profile.position,
                      style: CustomTheme().superSmallFont(
                        Colors.white,
                        FontWeight.normal,
                        context,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      formattedDate,
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
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(Icons.edit, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfileInfo(BuildContext context) {
    final profile = Profile();
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
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 5),
          buildInfoRow('Name', profile.name, Icons.info, context),
          buildInfoRow('Email', profile.email, Icons.email, context),
          buildInfoRow('Phone Number', profile.phone, Icons.phone, context),
          buildInfoRow(
            'Date of Birth',
            profile.dob,
            Icons.calendar_month,
            context,
          ),
        ],
      ),
    );
  }

  Widget buildLocationInfo(BuildContext context) {
    final profile = Profile();
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
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 5),
          buildInfoRow('Employee Id', profile.employeeId, Icons.info, context),
          buildInfoRow(
            'Date Of Joining',
            profile.dateOfJoining,
            Icons.date_range,
            context,
          ),
          buildInfoRow(
            'Department',
            profile.department,
            Icons.location_city,
            context,
          ),
          buildInfoRow('Position', profile.position, Icons.build, context),
          buildInfoRow(
            'Location',
            profile.location,
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
