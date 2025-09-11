import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  String uid;
  String name;
  String email;
  String role;
  String? phone;
  DateTime? dob;
  String? department;
  String? position;
  String? location;
  int? employeeId;
  DateTime? dateOfJoining;
  String? profilePicturePath;

  Profile({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.dob,
    this.department,
    this.position,
    this.location,
    this.employeeId,
    this.dateOfJoining,
    this.profilePicturePath,
  });

  Profile copyWith({
    String? uid,
    String? name,
    String? email,
    String? role,
    String? phone,
    DateTime? dob,
    String? department,
    String? position,
    String? location,
    int? employeeId,
    DateTime? dateOfJoining,
    String? profilePicturePath,
  }) {
    return Profile(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      dob: dob ?? this.dob,
      department: department ?? this.department,
      position: position ?? this.position,
      location: location ?? this.location,
      employeeId: employeeId ?? this.employeeId,
      dateOfJoining: dateOfJoining ?? this.dateOfJoining,
      profilePicturePath: profilePicturePath ?? this.profilePicturePath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'role': role,
      'phone': phone,
      'dob': dob != null ? Timestamp.fromDate(dob!) : null,
      'department': department,
      'position': position,
      'location': location,
      'employeeId': employeeId,
      'dateOfJoining': dateOfJoining != null
          ? Timestamp.fromDate(dateOfJoining!)
          : null,
      'profilePicturePath': profilePicturePath,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
      phone: map['phone'],
      dob: map['dob'] != null ? (map['dob'] as Timestamp).toDate() : null,
      department: map['department'],
      position: map['position'],
      location: map['location'],
      employeeId: map['employeeId'],
      dateOfJoining: map['dateOfJoining'] != null
          ? (map['dateOfJoining'] as Timestamp).toDate()
          : null,
      profilePicturePath: map['profilePicturePath'],
    );
  }
}
