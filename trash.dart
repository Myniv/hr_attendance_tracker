import 'package:flutter/material.dart';

abstract class Trash extends StatelessWidget {
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
}

class Profile {
  var name = "Mulyana N";
  var profession = "Flutter Developer";
  var email = "mulyanan@solecode.id";
  var phone = "08123456789";
  var address = "Tangerang, Indonesia";
  var bio =
      "Passionate mobile developer with 3+ years experience in Flutter and React Native. Love creating beautiful and functional mobile applications.";
}
