import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hr_attendance_tracker/custom_theme.dart';
import 'package:hr_attendance_tracker/main.dart';
import 'package:hr_attendance_tracker/providers/auth_provider.dart';
import 'package:hr_attendance_tracker/providers/profile_provider.dart';
import 'package:hr_attendance_tracker/widgets/custom_appbar.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final CustomTheme _customTheme = CustomTheme();
  bool _isInitialized = false;
  String? _currentUid;
  String? _originalUid;
  bool _isEditingProfile2 = false;
  bool _isCreatingNewProfile = false;

  final departmentsList = [
    'HR',
    'Finance',
    'Engineering',
    'Sales',
    'Marketing',
    'IT Department',
  ];

  final positionsList = [
    'Manager',
    'Senior Developer',
    'Junior Developer',
    'Intern',
    'Flutter Developer',
  ];

  final locationList = [
    'Jakarta',
    'Tangerang',
    'Bandung',
    'Surabaya',
    'Medan',
    'Bali',
  ];

  @override
  void initState() {
    super.initState();
    _loadUid();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final profileProvider = Provider.of<ProfileProvider>(
        context,
        listen: false,
      );
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      final String? uid = args?['uid'];
      final bool? createNewProfile = args?['createNewProfile'];

      if (uid != null) {
        _currentUid = uid;
        _isEditingProfile2 = true;
        _isCreatingNewProfile = false;

        profileProvider.setEditingState(true, false);

        print("EditProfileScreen: Editing profile2 for UID: $uid");

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _loadProfileData(profileProvider, uid);
        });
      } else if (createNewProfile != null && createNewProfile == true) {
        _isEditingProfile2 = false;
        _isCreatingNewProfile = true;

        profileProvider.setEditingState(false, true);
        profileProvider.initializeNewProfile();

        print("EditProfileScreen: Creating new profile");
      } else {
        _isEditingProfile2 = false;
        _isCreatingNewProfile = false;

        profileProvider.setEditingState(false, false);

        print("EditProfileScreen: Editing current user profile");
        _populateFormFields(profileProvider.profile, profileProvider);
      }

      _isInitialized = true;
    }
  }

  void _loadProfileData(ProfileProvider profileProvider, String uid) {
    var targetProfile = profileProvider.profile2;

    if (targetProfile == null || targetProfile.uid != uid) {
      try {
        targetProfile = profileProvider.allProfiles.firstWhere(
          (profile) => profile.uid == uid,
        );
        profileProvider.setProfile2(targetProfile);
      } catch (e) {
        print("Profile not found in allProfiles for UID: $uid");
        return;
      }
    }
    _populateFormFields(targetProfile, profileProvider);
  }

  void _populateFormFields(dynamic profile, ProfileProvider profileProvider) {
    if (profile != null) {
      profileProvider.nameController.text = profile.name ?? '';
      profileProvider.emailController.text = profile.email ?? '';
      profileProvider.phoneController.text = profile.phone ?? '';
      profileProvider.employeeIdController.text = profile.employeeId != null
          ? profile.employeeId.toString()
          : '';

      profileProvider.setDepartment(profile.department);
      profileProvider.setPosition(profile.position);
      profileProvider.setLocation(profile.location);
      profileProvider.setDOB(profile.dob);
      profileProvider.setDateOfJoining(profile.dateOfJoining);
    }
  }

  void _loadUid() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final uid = await authProvider.loadUserUID();
    if (uid != null) {
      setState(() {
        _originalUid = uid;
      });
    }
  }

  dynamic _getCurrentProfile(ProfileProvider profileProvider) {
    return _isEditingProfile2
        ? profileProvider.profile2
        : _isCreatingNewProfile
        ? profileProvider.newProfile
        : profileProvider.profile;
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final currentProfile = _getCurrentProfile(profileProvider);
    final isNew = currentProfile?.isNew;

    final phoneFormatter = MaskTextInputFormatter(
      mask: '+62 ###-####-####',
      filter: {"#": RegExp(r'[0-9]')},
    );

    return Scaffold(
      appBar: CustomAppbar(
        title: _isEditingProfile2
            ? "Edit ${currentProfile?.name ?? 'Profile'}"
            : _isCreatingNewProfile
            ? "New Profile"
            : "Edit Personal Info",
        onBack: () => Navigator.pop(context),
        icon: Icons.arrow_back,
      ),
      backgroundColor: CustomTheme.backgroundScreenColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: CustomTheme.whiteButNot.withOpacity(0.95),
                borderRadius: CustomTheme.borderRadius,
                border: Border.all(color: CustomTheme.colorGold, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: CustomTheme.colorBrown.withOpacity(0.3),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: profileProvider.profileKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              CustomTheme.colorGold.withOpacity(0.3),
                              CustomTheme.colorYellow.withOpacity(0.2),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: CustomTheme.borderRadius,
                        ),
                        child: Column(
                          children: [
                            Text(
                              _isEditingProfile2
                                  ? "Edit ${currentProfile?.name ?? 'profile'} details below"
                                  : _isCreatingNewProfile
                                  ? "Create a new profile"
                                  : "Edit your personal details below",
                              style: _customTheme.mediumFont(
                                CustomTheme.colorBrown,
                                FontWeight.bold,
                                context,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 32),

                      _customTheme.customSelectImage(
                        context: context,
                        profilePicturePath: currentProfile?.profilePicturePath,
                        selectedImageFile: profileProvider.selectedImageFile,
                        onPressed: () => profileProvider.pickImage(),
                        label: "Profile Picture",
                      ),
                      SizedBox(height: 20),

                      _customTheme.customTextField(
                        context: context,
                        controller: profileProvider.nameController,
                        label: "Full Name",
                        hint: "Enter full name",
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter name";
                          }
                          if (value.trim().length < 3) {
                            return "Name must be at least 3 characters";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),

                      _customTheme.customTextField(
                        context: context,
                        controller: profileProvider.emailController,
                        label: "Email Address",
                        hint: "Enter email address",
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter email";
                          }
                          if (!RegExp(
                            r'^[^@]+@[^@]+\.[^@]+',
                          ).hasMatch(value.trim())) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      // Add this after the email field, only for new profile creation
                      if (_isCreatingNewProfile) ...[
                        SizedBox(height: 20),
                        _customTheme.customTextField(
                          context: context,
                          controller: profileProvider.passwordController,
                          label: "Password",
                          hint: "Enter password",
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter password";
                            }
                            if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                        ),
                      ],
                      SizedBox(height: 20),

                      _customTheme.customTextField(
                        context: context,
                        controller: profileProvider.phoneController,
                        label: "Phone Number",
                        hint: "Enter phone number",
                        keyboardType: TextInputType.phone,
                        inputFormatters: [phoneFormatter],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter phone number";
                          }
                          if (value.replaceAll(RegExp(r'[^\d]'), '').length <
                              10) {
                            return "Please enter a valid phone number";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24),

                      _customTheme.customSelectDate(
                        context: context,
                        label: "Date of Birth",
                        selectedDate: currentProfile?.dob,
                        onPressed: () =>
                            profileProvider.pickDate(context, true),
                      ),
                      SizedBox(height: 24),

                      _customTheme.customTextField(
                        context: context,
                        controller: profileProvider.employeeIdController,
                        label: "Employee ID",
                        hint: "Enter employee ID",
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter employee ID";
                          }
                          if (int.tryParse(value.trim()) == null) {
                            return "Employee ID must be a number";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24),

                      _customTheme.customSelectDate(
                        context: context,
                        label: "Date of Joining",
                        selectedDate: currentProfile?.dateOfJoining,
                        onPressed: () =>
                            profileProvider.pickDate(context, false),
                      ),
                      SizedBox(height: 20),

                      _customTheme.customDropdown<String>(
                        context: context,
                        value: currentProfile?.department?.isNotEmpty == true
                            ? currentProfile?.department
                            : null,
                        items: departmentsList,
                        label: "Department",
                        onChanged: (value) =>
                            profileProvider.setDepartment(value),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a department';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),

                      _customTheme.customDropdown<String>(
                        context: context,
                        value: currentProfile?.position?.isNotEmpty == true
                            ? currentProfile?.position
                            : null,
                        items: positionsList,
                        label: "Position",
                        onChanged: (value) =>
                            profileProvider.setPosition(value),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a position';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),

                      _customTheme.customDropdown<String>(
                        context: context,
                        value: currentProfile?.location?.isNotEmpty == true
                            ? currentProfile?.location
                            : null,
                        items: locationList,
                        label: "Location",
                        onChanged: (value) =>
                            profileProvider.setLocation(value),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a location';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 40),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: profileProvider.isLoading
                                  ? null
                                  : () {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (ctx) {
                                          return AlertDialog(
                                            backgroundColor:
                                                CustomTheme.whiteButNot,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  CustomTheme.borderRadius,
                                            ),
                                            title: Text(
                                              "Reset Form?",
                                              style: _customTheme.mediumFont(
                                                CustomTheme.colorBrown,
                                                FontWeight.w700,
                                                context,
                                              ),
                                            ),
                                            content: Text(
                                              "Are you sure you want to reset all changes?",
                                              style: _customTheme.smallFont(
                                                CustomTheme.colorLightBrown,
                                                FontWeight.w500,
                                                context,
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(ctx).pop(),
                                                child: Text(
                                                  "Cancel",
                                                  style: _customTheme.smallFont(
                                                    CustomTheme.colorLightBrown,
                                                    FontWeight.w600,
                                                    context,
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  _populateFormFields(
                                                    currentProfile,
                                                    profileProvider,
                                                  );
                                                  Navigator.of(ctx).pop();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.red.shade400,
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                ),
                                                child: Text(
                                                  'Reset',
                                                  style: _customTheme.smallFont(
                                                    Colors.white,
                                                    FontWeight.w700,
                                                    context,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                              icon: Icon(Icons.refresh_rounded, size: 20),
                              label: Text('Reset'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade400,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                                textStyle: _customTheme.smallFont(
                                  Colors.white,
                                  FontWeight.w700,
                                  context,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: profileProvider.isLoading
                                  ? null
                                  : () async {
                                      if (profileProvider.validateProfile()) {
                                        await _saveProfile(
                                          profileProvider,
                                          currentProfile,
                                        );
                                      }
                                    },
                              icon: profileProvider.isLoading
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: CustomTheme.colorBrown,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Icon(Icons.save_rounded, size: 20),
                              label: Text(
                                profileProvider.isLoading
                                    ? 'Saving...'
                                    : 'Update Profile',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CustomTheme.colorGold,
                                foregroundColor: CustomTheme.colorBrown,
                                padding: EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 6,
                                textStyle: _customTheme.smallFont(
                                  CustomTheme.colorBrown,
                                  FontWeight.w700,
                                  context,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveProfile(
    ProfileProvider profileProvider,
    dynamic currentProfile,
  ) async {
    try {
      if (_isEditingProfile2) {
        await profileProvider.updateProfile2();
      } else if (_isCreatingNewProfile) {
        await profileProvider.createNewProfile();
      } else {
        await profileProvider.updateProfile();
      }

      await Future.delayed(Duration(seconds: 2));

      _customTheme.customScaffoldMessage(
        context: context,
        message: "Information updated successfully!",
      );

      final isNew = currentProfile?.isNew;
      if (isNew == true || isNew == null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MainScreen()),
        );
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      _customTheme.customScaffoldMessage(
        context: context,
        message: "Failed to update profile: $e",
        backgroundColor: Colors.red,
      );
    }
  }
}
