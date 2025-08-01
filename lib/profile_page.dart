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
                buildProfileInfo(),
                buildProfileBio(),
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
                    profile.profession,
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

    Widget buildInfoBox(
      IconData leadingIcon,
      String text,
      VoidCallback onEdit,
    ) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 157, 121, 108)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(leadingIcon, color: const Color.fromARGB(255, 157, 121, 108)),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: const Color.fromARGB(255, 157, 121, 108),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.edit,
                color: const Color.fromARGB(255, 157, 121, 108),
              ),
              onPressed: onEdit,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          buildInfoBox(Icons.email, profile.email, () {
            print("Edit email");
          }),
          buildInfoBox(Icons.phone, profile.phone, () {
            print("Edit phone");
          }),
          buildInfoBox(Icons.location_on, profile.address, () {
            print("Edit address");
          }),
        ],
      ),
    );
  }

  Widget buildProfileBio() {
    final profile = Profile();

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5),
          Padding(padding: EdgeInsets.all(8.0)),
          Text(
            "About Me",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(profile.bio, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
