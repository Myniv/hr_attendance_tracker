import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/models/profile.dart';
import 'package:hr_attendance_tracker/services/profile_service.dart';
import 'package:image_picker/image_picker.dart';

class ProfileProvider extends ChangeNotifier {
  final profileKey = GlobalKey<FormState>();
  final ProfileService _profileService = ProfileService();

  Profile? _profile;
  Profile? get profile => _profile;

  Profile? _profile2;
  Profile? get profile2 => _profile2;

  List<Profile> _allProfiles = [];
  List<Profile> get allProfiles => _allProfiles;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isUploadingPhoto = false;
  bool get isUploadingPhoto => _isUploadingPhoto;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  File? _selectedImageFile;
  File? get selectedImageFile => _selectedImageFile;

  final nameController = TextEditingController();
  final employeeIdController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final _picker = ImagePicker();

  bool _isDataLoaded = false;

  void setDepartment(String? value) {
    _profile?.department = value ?? '';
    notifyListeners();
  }

  void setPosition(String? value) {
    _profile?.position = value ?? '';
    notifyListeners();
  }

  void setLocation(String? value) {
    _profile?.location = value ?? '';
    notifyListeners();
  }

  void setDateOfJoining(DateTime? value) {
    if (value != null) {
      _profile?.dateOfJoining = value;
      notifyListeners();
    }
  }

  void setDOB(DateTime? value) {
    if (value != null) {
      _profile?.dob = value;
      notifyListeners();
    }
  }

  void setProfile(Profile profile) {
    _profile = profile;
    _selectedImageFile = null;
    notifyListeners();
  }

  void setProfile2(Profile profile) {
    _profile2 = profile;
    _selectedImageFile = null;
    notifyListeners();
  }

  void _setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setUploadingPhoto(bool value) {
    _isUploadingPhoto = value;
    notifyListeners();
  }

  void _setSelectedImageFile(File? file) {
    _selectedImageFile = file;
    notifyListeners();
  }

  Future<void> pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        print("Image picked: ${pickedFile.path}");
        // await uploadProfilePhoto(File(pickedFile.path));
        _setSelectedImageFile(File(pickedFile.path));
      }
    } catch (e) {
      print("Error picking image: $e");
      _errorMessage = "Failed to pick image: $e";
      _selectedImageFile = null;
      notifyListeners();
    }
  }

  Future<void> pickDate(BuildContext context, bool isDob) async {
    final DateTime initialDate;

    if (isDob) {
      initialDate =
          _profile?.dob ?? DateTime.now().subtract(Duration(days: 6570));
    } else {
      initialDate = _profile?.dateOfJoining ?? DateTime.now();
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

  bool validateProfile() {
    return profileKey.currentState?.validate() ?? false;
  }

  Future<void> uploadProfilePhoto(File file) async {
    if (_profile == null) {
      _errorMessage = "No profile loaded";
      notifyListeners();
      return;
    }
    _setUploadingPhoto(true);
    _errorMessage = null;
    notifyListeners();
    try {
      final url = await _profileService.uploadProfilePhoto(
        _profile!.uid,
        file,
        _profile!.profilePicturePath ?? '',
      );

      final updatedProfile = _profile!.copyWith(profilePicturePath: url);
      _profile = updatedProfile;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = "Failed to upload photo: $e";
      _selectedImageFile = null;
      notifyListeners();
      rethrow;
    } finally {
      _setUploadingPhoto(false);
      _setIsLoading(false);
    }
  }

  Future<void> loadAllProfiles() async {
    _setIsLoading(true);
    try {
      _allProfiles = await _profileService.getAllUserProfiles();
      _errorMessage = null;
    } catch (e) {
      print("Error loading all profiles: $e");
      _errorMessage = "Failed to load all profiles: $e";
    } finally {
      _setIsLoading(false);
    }
  }

  Future<void> loadProfile(String uid) async {
    _setIsLoading(true);
    try {
      _profile = await _profileService.getUserProfile(uid);

      if (_profile != null) {
        nameController.text = _profile!.name ?? '';
        emailController.text = _profile!.email ?? '';
        phoneController.text = _profile!.phone ?? '';
        employeeIdController.text = _profile?.employeeId != null
            ? _profile!.employeeId.toString()
            : '';
      }

      _errorMessage = null;
      _selectedImageFile = null;
    } catch (e) {
      print("Error loading profile: $e");
      _errorMessage = "Failed to load profile: $e";
    } finally {
      _setIsLoading(false);
    }
  }

  Future<void> updateProfile() async {
    if (_profile == null) return;
    if (!profileKey.currentState!.validate()) return;
    if (_selectedImageFile != null) {}

    _setIsLoading(true);
    try {
      if (_selectedImageFile != null) {
        await uploadProfilePhoto(_selectedImageFile!);
      }

      final updated = Profile(
        uid: _profile!.uid,
        name: nameController.text,
        email: emailController.text,
        role: _profile!.role,
        phone: phoneController.text,
        dob: _profile!.dob,
        department: _profile!.department,
        position: _profile!.position,
        location: _profile!.location,
        employeeId: _profile!.employeeId,
        dateOfJoining: _profile!.dateOfJoining,
        profilePicturePath: _profile!.profilePicturePath,
        isNew: false,
      );

      await _profileService.updateUserProfile(updated);
      _profile = updated;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      print("Error updating profile: $e");
      _errorMessage = "Failed to update profile: $e";
      notifyListeners();
      rethrow;
    } finally {
      _setIsLoading(false);
    }
  }

  Future<void> updateProfile2() async {
    if (_profile2 == null) {
      _errorMessage = "No profile2 loaded for editing";
      notifyListeners();
      return;
    }

    if (!profileKey.currentState!.validate()) return;

    _setIsLoading(true);
    try {
      // Handle photo upload if there's a selected image
      String? updatedPhotoPath = _profile2!.profilePicturePath;
      if (_selectedImageFile != null) {
        updatedPhotoPath = await _profileService.uploadProfilePhoto(
          _profile2!.uid,
          _selectedImageFile!,
          _profile2!.profilePicturePath ?? '',
        );
      }

      // Create updated profile with form data
      final updated = Profile(
        uid: _profile2!.uid,
        name: nameController.text,
        email: emailController.text,
        role: _profile2!.role,
        phone: phoneController.text,
        dob: _profile2!.dob,
        department: _profile2!.department,
        position: _profile2!.position,
        location: _profile2!.location,
        employeeId:
            int.tryParse(employeeIdController.text) ?? _profile2!.employeeId,
        dateOfJoining: _profile2!.dateOfJoining,
        profilePicturePath: updatedPhotoPath,
        isNew: false,
      );

      // Update in database
      await _profileService.updateUserProfile(updated);

      // Update local state
      _profile2 = updated;

      // Also update in allProfiles list
      final index = _allProfiles.indexWhere((p) => p.uid == updated.uid);
      if (index != -1) {
        _allProfiles[index] = updated;
      }

      _errorMessage = null;
      _selectedImageFile = null;
      notifyListeners();

      print("Profile2 updated successfully: ${updated.name}");
    } catch (e) {
      print("Error updating profile2: $e");
      _errorMessage = "Failed to update profile: $e";
      notifyListeners();
      rethrow;
    } finally {
      _setIsLoading(false);
    }
  }

  void clearProfile() {
    _profile = null;
    _errorMessage = null;
    _selectedImageFile = null;
    notifyListeners();
  }

  // void reset() {
  //   _isDataLoaded = false;
  //   getProfileData();
  // }
}
