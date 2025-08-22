class Profile {
  String? name;
  String? email;
  String? phone;
  DateTime? dob;
  String? department;
  String? position;
  String? location;
  int? employeeId;
  DateTime dateOfJoining;
  String? profilePicturePath;

  Profile({
    this.name = "Mulyana N",
    this.email = "mulyanan@solecode.id",
    this.phone = "+62 857-7030-2069",
    DateTime? dob,
    this.department = "IT Department",
    this.position = "Flutter Developer",
    this.location = "Tangerang",
    this.employeeId = 2011500457,
    DateTime? dateOfJoining,
    this.profilePicturePath,
  }) : dob = dob ?? DateTime(1990, 1, 1),
       dateOfJoining = dateOfJoining ?? DateTime(2020, 4, 1);
}
