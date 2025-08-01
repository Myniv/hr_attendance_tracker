import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  // width: 500,
                  height: 150,
                  decoration: BoxDecoration(
                    // gradient: LinearGradient(
                    //   colors: [Colors.purpleAccent, Colors.deepPurpleAccent],
                    // ),
                    color: const Color.fromARGB(255, 157, 121, 108),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      // BoxShadow(
                      //   color: Colors.black26,
                      //   blurRadius: 10,
                      //   offset: Offset(0, 5),
                      // ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: buildProfileHeader(),
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
                ),
                SizedBox(height: 20),
                buildProfileInfo(),
                SizedBox(height: 20),
                buildLocationInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProfileHeader() {
    final profile = Profile();
    final today = DateTime.now();
    final formattedDate = "${today.day}/${today.month}/${today.year}";

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 40),
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/profile.png'),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    profile.position,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  Text(
                    formattedDate,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfileInfo() {
    final profile = Profile();
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color.fromARGB(255, 157, 121, 108)),
        borderRadius: BorderRadius.circular(10),
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 157, 121, 108),
                ),
              ),

              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: const Color.fromARGB(255, 157, 121, 108),
                ),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 5),
          buildInfoRow('Name', profile.name),
          buildInfoRow('Email', profile.email),
          buildInfoRow('Phone Number', profile.phone),
          buildInfoRow('Date of Birth', profile.dob),
        ],
      ),
    );
  }
  Widget buildLocationInfo() {
    final profile = Profile();
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color.fromARGB(255, 157, 121, 108)),
        borderRadius: BorderRadius.circular(10),
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 157, 121, 108),
                ),
              ),

              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: const Color.fromARGB(255, 157, 121, 108),
                ),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 5),
          buildInfoRow('Employee Id', profile.employeeId),
          buildInfoRow('Date Of Joining', profile.dateOfJoining),
          buildInfoRow('Department', profile.department),
          buildInfoRow('Position', profile.position),
          buildInfoRow('Location', profile.location),
        ],
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.brown)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
