import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hr_attendance_tracker/custom_theme.dart';
import 'package:hr_attendance_tracker/providers/profile_provider.dart';
import 'package:hr_attendance_tracker/widgets/custom_appbar.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  final bool isPersonal;

  const EditProfileScreen({Key? key, required this.isPersonal})
    : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final CustomTheme _customTheme = CustomTheme();
  bool _isInitialized = false;

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
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final phoneFormatter = MaskTextInputFormatter(
      mask: '+62 ###-####-####',
      filter: {"#": RegExp(r'[0-9]')},
    );

    return Scaffold(
      appBar: CustomAppbar(
        title: widget.isPersonal ? "Edit Personal Info" : "Edit Work Info",
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
                              widget.isPersonal
                                  ? "Edit your personal details below"
                                  : "Edit your work details below",
                              style: _customTheme.mediumFont(
                                CustomTheme.colorLightBrown,
                                FontWeight.w500,
                                context,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 32),

                      if (widget.isPersonal) ...[
                        _customTheme.customTextField(
                          context: context,
                          controller: profileProvider.nameController,
                          label: "Full Name",
                          hint: "Enter your full name",
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter your name";
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
                          hint: "Enter your email address",
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter your email";
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

                        _customTheme.customTextField(
                          context: context,
                          controller: profileProvider.phoneController,
                          label: "Phone Number",
                          hint: "Enter your phone number",
                          keyboardType: TextInputType.phone,
                          inputFormatters: [phoneFormatter],
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter your phone number";
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
                          selectedDate: profileProvider.profile.dob,
                          onPressed: () =>
                              profileProvider.pickDate(context, true),
                        ),
                        SizedBox(height: 24),

                        _customTheme.customSelectImage(
                          context: context,
                          profilePicturePath:
                              profileProvider.profile.profilePicturePath,
                          onPressed: () => profileProvider.pickImage(),
                          label: "Profile Picture",
                        ),
                      ] else ...[
                        _customTheme.customTextField(
                          context: context,
                          controller: profileProvider.employeeIdController,
                          label: "Employee ID",
                          hint: "Enter your employee ID",
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter your employee ID";
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
                          selectedDate: profileProvider.profile.dateOfJoining,
                          onPressed: () =>
                              profileProvider.pickDate(context, false),
                        ),
                        SizedBox(height: 20),

                        _customTheme.customDropdown<String>(
                          context: context,
                          value:
                              profileProvider.profile.department?.isNotEmpty ==
                                  true
                              ? profileProvider.profile.department
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
                          value:
                              profileProvider.profile.position?.isNotEmpty ==
                                  true
                              ? profileProvider.profile.position
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
                          value:
                              profileProvider.profile.location?.isNotEmpty ==
                                  true
                              ? profileProvider.profile.location
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
                      ],

                      SizedBox(height: 40),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (ctx) {
                                    return AlertDialog(
                                      backgroundColor: CustomTheme.whiteButNot,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: CustomTheme.borderRadius,
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
                                            profileProvider.reset();
                                            Navigator.of(ctx).pop();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.red.shade400,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
                            flex: 2,
                            child: ElevatedButton.icon(
                              onPressed: profileProvider.isLoading
                                  ? null
                                  : () async {
                                      if (profileProvider.validateProfile()) {
                                        profileProvider.setIsLoading(true);
                                        profileProvider.saveProfile();

                                        await Future.delayed(
                                          Duration(seconds: 2),
                                        );

                                        profileProvider.setIsLoading(false);

                                        if (context.mounted) {
                                          Navigator.pop(context);
                                          _customTheme.customScaffoldMessage(
                                            context: context,
                                            message: widget.isPersonal
                                                ? "Personal information updated successfully!"
                                                : "Work information updated successfully!",
                                          );
                                        }
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
}
