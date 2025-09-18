import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:hr_attendance_tracker/custom_theme.dart';
import 'package:hr_attendance_tracker/providers/attendance_history_provider.dart';
import 'package:hr_attendance_tracker/widgets/custom_appbar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hr_attendance_tracker/main.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ClockInOutScreen extends StatefulWidget {
  const ClockInOutScreen({super.key});

  @override
  State<ClockInOutScreen> createState() => _ClockInOutScreenState();
}

class _ClockInOutScreenState extends State<ClockInOutScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  XFile? _capturedImage;
  String _location = "Getting location...";
  String _statusPermission = "Checking permissions...";
  String _address = "Fetching address...";
  bool _isSubmitting = false;
  bool _isLocationLoading = true;
  bool isClockIn = true;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(cameras[0], ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
    _getLocation();
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    isClockIn = args?['isClockIn'];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      try {
        await _initializeControllerFuture;
        final XFile file = await _controller.takePicture();
        setState(() {
          _capturedImage = file;
        });
      } catch (e) {
        CustomTheme().customScaffoldMessage(
          context: context,
          message: "Error taking photo: $e",
          backgroundColor: Colors.red,
        );
      }
    } else if (status.isDenied) {
      CustomTheme().customScaffoldMessage(
        context: context,
        message: "Camera permission denied",
        backgroundColor: Colors.red,
      );
    } else if (status.isPermanentlyDenied) {
      CustomTheme().customScaffoldMessage(
        context: context,
        message: "Camera permanently denied. Opening settings...",
        backgroundColor: Colors.red,
      );
      await openAppSettings();
    }
  }

  Future<void> _getLocation() async {
    try {
      await _checkPermission();

      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _location =
            "${pos.latitude.toStringAsFixed(6)}, ${pos.longitude.toStringAsFixed(6)}";
      });

      await _getAddressFromLatLng(pos.latitude, pos.longitude);
    } catch (e) {
      setState(() {
        _location = "Unable to get location";
        _address = "Location not available";
        _isLocationLoading = false;
      });
    }
  }

  Future<void> _getAddressFromLatLng(double lat, double lon) async {
    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lon&format=json",
    );

    try {
      final response = await http.get(
        url,
        headers: {"User-Agent": "hr_attendance_app"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _address = data['display_name'] ?? "Address not found";
          _isLocationLoading = false;
        });
      } else {
        setState(() {
          _address = "Failed to get address";
          _isLocationLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _address = "Error fetching address";
        _isLocationLoading = false;
      });
    }
  }

  Future<void> _checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _statusPermission = "Location services are disabled";
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _statusPermission = "Location permission denied";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _statusPermission = "Location permission permanently denied";
      });
      return;
    }

    setState(() {
      _statusPermission = "Location permission granted";
    });
  }

  Future<void> _submitAttendance(
    AttendanceHistoryProvider attHistoryProvider,
  ) async {
    setState(() {
      _isSubmitting = true;
    });

    if (isClockIn) {
      await attHistoryProvider.clockIn(
        DateTime.now(),
        _location,
        File(_capturedImage!.path),
      );

      CustomTheme().customScaffoldMessage(
        context: context,
        message: "Attendance Clock In successfully!",
        backgroundColor: Colors.green,
      );
    } else {
      await attHistoryProvider.clockOut(
        DateTime.now(),
        _location,
        File(_capturedImage!.path),
      );

      CustomTheme().customScaffoldMessage(
        context: context,
        message: "Attendance Clock Out successfully!",
        backgroundColor: Colors.green,
      );
    }
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSubmitting = false;
      _capturedImage = null;
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final attHistoryProvider = Provider.of<AttendanceHistoryProvider>(
      context,
      listen: false,
    );
    return Scaffold(
      backgroundColor: CustomTheme.backgroundScreenColor,
      appBar: CustomAppbar(
        title: "Clock In/Out",
        icon: Icons.arrow_back,
        onBack: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      CustomTheme.colorGold.withOpacity(0.2),
                      CustomTheme.colorBrown.withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: CustomTheme.borderRadius,
                  border: Border.all(
                    color: CustomTheme.colorGold.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: isClockIn ? Colors.green : Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isClockIn ? "Clock In" : "Clock Out",
                      style: CustomTheme().largeFont(
                        isClockIn ? Colors.green : Colors.red,
                        FontWeight.w700,
                        context,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              if (_capturedImage != null) ...[
                Text(
                  "Photo Captured",
                  style: CustomTheme().mediumFont(
                    CustomTheme.colorGold,
                    FontWeight.w600,
                    context,
                  ),
                ),
                const SizedBox(height: 12),
                _buildCameraTaken(),
                const SizedBox(height: 20),
                _buildLocationInfo(),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: CustomTheme().customActionButton(
                        text: "Retake",
                        icon: Icons.camera_alt_outlined,
                        onPressed: () {
                          setState(() {
                            _capturedImage = null;
                          });
                        },
                        backgroundColor: CustomTheme.colorLightBrown,
                        foregroundColor: CustomTheme.whiteButNot,
                        context: context,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: CustomTheme().customActionButton(
                        text: "Submit Attendance",
                        icon: Icons.check_circle_outline,
                        onPressed: () => _submitAttendance(attHistoryProvider),
                        isLoading: _isSubmitting,
                        context: context,
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Text(
                  "Camera Preview",
                  style: CustomTheme().mediumFont(
                    CustomTheme.colorGold,
                    FontWeight.w600,
                    context,
                  ),
                ),
                const SizedBox(height: 12),
                _buildCameraPreview(),
                const SizedBox(height: 20),

                CustomTheme().customActionButton(
                  text: "Take Photo",
                  icon: Icons.camera_alt,
                  onPressed: _takePhoto,
                  context: context,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CustomTheme.colorBrown.withOpacity(0.3),
        borderRadius: CustomTheme.borderRadius,
        border: Border.all(
          color: CustomTheme.colorGold.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: CustomTheme.colorGold, size: 20),
              const SizedBox(width: 8),
              Text(
                "Current Location",
                style: CustomTheme().mediumFont(
                  CustomTheme.colorGold,
                  FontWeight.w600,
                  context,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _address,
            style: CustomTheme().smallFont(
              CustomTheme.whiteButNot,
              FontWeight.w400,
              context,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            "Location: $_location",
            style: CustomTheme().superSmallFont(
              CustomTheme.whiteButNot.withOpacity(0.7),
              FontWeight.w400,
              context,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: CustomTheme.borderRadius,
        border: Border.all(color: CustomTheme.colorGold, width: 2),
        boxShadow: [
          BoxShadow(
            color: CustomTheme.colorBrown.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: CustomTheme.borderRadius,
        child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CameraPreview(_controller);
            } else {
              return Container(
                height: 300,
                color: CustomTheme.colorBrown.withOpacity(0.3),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          CustomTheme.colorGold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Initializing Camera...",
                        style: CustomTheme().mediumFont(
                          CustomTheme.whiteButNot,
                          FontWeight.w400,
                          context,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildCameraTaken() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: CustomTheme.borderRadius,
        border: Border.all(color: CustomTheme.colorGold, width: 2),
        boxShadow: [
          BoxShadow(
            color: CustomTheme.colorBrown.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: CustomTheme.borderRadius,
        child: Image.file(
          File(_capturedImage!.path),
          height: 300,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
