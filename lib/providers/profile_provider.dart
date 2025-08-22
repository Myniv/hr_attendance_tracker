import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/models/profile.dart';
import 'package:image_picker/image_picker.dart';

class ProfileProvider extends ChangeNotifier {
  final profileKey = GlobalKey<FormState>();

  Profile profile = Profile();

  final nameController = TextEditingController();
  final employeeIdController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final picker = ImagePicker();

  bool isLoading = false;
  bool _isDataLoaded = false;

  void setDepartment(String? value) {
    profile.department = value ?? '';
    notifyListeners();
  }

  void setPosition(String? value) {
    profile.position = value ?? '';
    notifyListeners();
  }

  void setLocation(String? value) {
    profile.location = value ?? '';
    notifyListeners();
  }

  void setDateOfJoining(DateTime? value) {
    if (value != null) {
      profile.dateOfJoining = value;
      notifyListeners();
    }
  }

  void setDOB(DateTime? value) {
    if (value != null) {
      profile.dob = value;
      notifyListeners();
    }
  }

  void setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profile.profilePicturePath = pickedFile.path;
      notifyListeners();
    }
  }

  Future<void> pickDate(BuildContext context, bool isDob) async {
    final DateTime initialDate;

    if (isDob) {
      initialDate =
          profile.dob ?? DateTime.now().subtract(Duration(days: 6570));
    } else {
      initialDate = profile.dateOfJoining ?? DateTime.now();
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      if (isDob) {
        setDOB(picked);
      } else {
        setDateOfJoining(picked);
      }
    }
  }

  void getProfileData() {
    if (_isDataLoaded) return;

    nameController.text = profile.name ?? '';
    emailController.text = profile.email ?? '';
    phoneController.text = profile.phone ?? '';
    employeeIdController.text = profile.employeeId != null
        ? profile.employeeId.toString()
        : '';
    _isDataLoaded = true;
    notifyListeners();
  }

  bool validateProfile() {
    return profileKey.currentState?.validate() ?? false;
  }

  void saveProfile() {
    profile.name = nameController.text;
    profile.email = emailController.text;
    profile.phone = phoneController.text;

    final employeeIdText = employeeIdController.text;
    if (employeeIdText.isNotEmpty) {
      profile.employeeId = int.tryParse(employeeIdText) ?? 0;
    }

    notifyListeners();
  }

  void loadProfileFromSource(Profile sourceProfile) {
    profile = Profile(
      name: sourceProfile.name,
      email: sourceProfile.email,
      phone: sourceProfile.phone,
      employeeId: sourceProfile.employeeId,
      department: sourceProfile.department,
      position: sourceProfile.position,
      location: sourceProfile.location,
      dateOfJoining: sourceProfile.dateOfJoining,
      dob: sourceProfile.dob,
      profilePicturePath: sourceProfile.profilePicturePath,
    );

    nameController.text = profile.name ?? '';
    emailController.text = profile.email ?? '';
    phoneController.text = profile.phone ?? '';
    employeeIdController.text = profile.employeeId != null
        ? profile.employeeId.toString()
        : '';

    _isDataLoaded = true;
    notifyListeners();
  }

  void reset() {
    _isDataLoaded = false;
    getProfileData();
  }
}
