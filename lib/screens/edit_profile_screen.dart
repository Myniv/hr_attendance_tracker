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
        onBack: () {
          Navigator.pop(context);
        },
        icon: Icons.arrow_back,
      ),
      backgroundColor: CustomTheme.backgroundScreenColor,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: CustomTheme.borderRadius,
                border: Border.all(color: Colors.blueAccent),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: profileProvider.profileKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isPersonal
                            ? "Personal Information"
                            : "Work Information",
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.isPersonal
                            ? "Update your personal details below."
                            : "Update your work details below.",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 24),

                      if (widget.isPersonal) ...[
                        TextFormField(
                          controller: profileProvider.nameController,
                          decoration: InputDecoration(
                            labelText: "Full Name",
                            hintText: "Enter your full name",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: CustomTheme.borderRadius,
                              borderSide: BorderSide.none,
                            ),
                          ),
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
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: profileProvider.emailController,
                          decoration: InputDecoration(
                            labelText: "Email Address",
                            hintText: "Enter your email address",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: CustomTheme.borderRadius,
                              borderSide: BorderSide.none,
                            ),
                          ),
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
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: profileProvider.phoneController,
                          decoration: InputDecoration(
                            labelText: "Phone Number",
                            hintText: "Enter your phone number",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: CustomTheme.borderRadius,
                              borderSide: BorderSide.none,
                            ),
                          ),
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
                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Date of Birth",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (profileProvider.profile.dob != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        'Selected: ${DateFormat('MMM dd, yyyy').format(profileProvider.profile.dob!)}',
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )
                                  else
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        'No date selected',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () =>
                                  profileProvider.pickDate(context, true),
                              child: Text(
                                'Select Date',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Profile Picture",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => profileProvider.pickImage(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                profileProvider.profile.profilePicturePath !=
                                        null
                                    ? "Change Image"
                                    : "Choose Image",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (profileProvider.profile.profilePicturePath != null)
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(
                                      profileProvider
                                          .profile
                                          .profilePicturePath!,
                                    ),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ] else ...[
                        TextFormField(
                          controller: profileProvider.employeeIdController,
                          decoration: InputDecoration(
                            labelText: "Employee ID",
                            hintText: "Enter your employee ID",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: CustomTheme.borderRadius,
                              borderSide: BorderSide.none,
                            ),
                          ),
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
                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Date of Joining",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (profileProvider.profile.dateOfJoining !=
                                      null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        'Selected: ${DateFormat('MMM dd, yyyy').format(profileProvider.profile.dateOfJoining!)}',
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )
                                  else
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        'No date selected',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () =>
                                  profileProvider.pickDate(context, false),
                              child: Text(
                                'Select Date',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        DropdownButtonFormField<String>(
                          value:
                              profileProvider.profile.department?.isNotEmpty ==
                                  true
                              ? profileProvider.profile.department
                              : null,
                          items: departmentsList
                              .map(
                                (dept) => DropdownMenuItem<String>(
                                  value: dept,
                                  child: Text(dept),
                                ),
                              )
                              .toList(),
                          decoration: InputDecoration(
                            labelText: "Department",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: CustomTheme.borderRadius,
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (value) {
                            profileProvider.setDepartment(value);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a department';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        DropdownButtonFormField<String>(
                          value:
                              profileProvider.profile.position?.isNotEmpty ==
                                  true
                              ? profileProvider.profile.position
                              : null,
                          items: positionsList
                              .map(
                                (pos) => DropdownMenuItem<String>(
                                  value: pos,
                                  child: Text(pos),
                                ),
                              )
                              .toList(),
                          decoration: InputDecoration(
                            labelText: "Position",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: CustomTheme.borderRadius,
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (value) {
                            profileProvider.setPosition(value);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a position';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        DropdownButtonFormField<String>(
                          value:
                              profileProvider.profile.location?.isNotEmpty ==
                                  true
                              ? profileProvider.profile.location
                              : null,
                          items: locationList
                              .map(
                                (loc) => DropdownMenuItem<String>(
                                  value: loc,
                                  child: Text(loc),
                                ),
                              )
                              .toList(),
                          decoration: InputDecoration(
                            labelText: "Location",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: CustomTheme.borderRadius,
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (value) {
                            profileProvider.setLocation(value);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a location';
                            }
                            return null;
                          },
                        ),
                      ],
                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(
                              Icons.refresh,
                              size: 20,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 20,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) {
                                  return AlertDialog(
                                    title: Text("Reset Form?"),
                                    content: Text(
                                      "Are you sure you want to reset all changes?",
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text("Cancel"),
                                        onPressed: () =>
                                            Navigator.of(ctx).pop(),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.redAccent,
                                        ),
                                        onPressed: () {
                                          profileProvider.reset();
                                          Navigator.of(ctx).pop();
                                        },
                                        child: Text(
                                          'Reset',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            label: Text(
                              'Reset',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            icon: profileProvider.isLoading
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Icon(
                                    Icons.save,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent[700],
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 20,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
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
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              widget.isPersonal
                                                  ? "Personal information updated successfully!"
                                                  : "Work information updated successfully!",
                                            ),
                                            backgroundColor: Colors.green,
                                            duration: Duration(seconds: 3),
                                          ),
                                        );
                                      }
                                    }
                                  },
                            label: Text(
                              'Update',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
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
