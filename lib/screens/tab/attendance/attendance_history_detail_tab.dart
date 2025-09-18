import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hr_attendance_tracker/custom_theme.dart';
import 'package:hr_attendance_tracker/widgets/no_item.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class AttendanceHistoryDetailTab extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final bool isClockIn;
  final String? picturePath;
  final DateTime? clockTime;

  const AttendanceHistoryDetailTab({
    Key? key,
    this.latitude,
    this.longitude,
    required this.isClockIn,
    this.picturePath,
    this.clockTime,
  }) : super(key: key);

  @override
  State<AttendanceHistoryDetailTab> createState() =>
      _AttendanceHistoryDetailTabState();
}

class _AttendanceHistoryDetailTabState
    extends State<AttendanceHistoryDetailTab> {
  String _address = "Unknown";

  @override
  void initState() {
    super.initState();
    if (widget.latitude != null && widget.longitude != null) {
      _getAddressFromLatLng(widget.latitude!, widget.longitude!);
    }
  }

  Future<void> _getAddressFromLatLng(double lat, double lon) async {
    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lon&format=json",
    );

    try {
      final response = await http.get(
        url,
        headers: {"User-Agent": "test_flutter"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _address = data['display_name'];
        });
      } else {
        setState(() {
          _address = "Failed to get address";
        });
      }
    } catch (e) {
      setState(() {
        _address = "Error fetching address: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.backgroundScreenColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (widget.latitude == null &&
                  widget.longitude == null &&
                  widget.clockTime == null) ...[
                Center(
                  child: NoItem(
                    title: widget.isClockIn
                        ? "No Available Clock In Record"
                        : "No Available Clock Out Record",
                    subTitle: widget.isClockIn
                        ? "You have not clocked in yet!"
                        : "You have not clocked out yet!",
                  ),
                ),
              ] else ...[
                _buildPictureAddress(
                  widget.picturePath ?? "",
                  _address,
                  "${widget.latitude ?? 0.0}, ${widget.longitude ?? 0.0}",
                  widget.clockTime?.toString() ?? "Unknown",
                  widget.isClockIn,
                ),
                SizedBox(height: 20),
                if (widget.latitude != null && widget.longitude != null)
                  _buildLocationMap(widget.latitude!, widget.longitude!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPictureAddress(
    String picturePath,
    String address,
    String location,
    String clockTime,
    bool clockIn,
  ) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
              child: CircleAvatar(
                radius: 50,
                backgroundImage: picturePath.isNotEmpty
                    ? NetworkImage(picturePath)
                    : AssetImage('assets/images/profile.png') as ImageProvider,
                backgroundColor: CustomTheme.colorGold.withOpacity(0.3),
                child: (picturePath.isEmpty)
                    ? Icon(Icons.person, size: 50, color: Colors.white)
                    : null,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 16, bottom: 4),
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              color: CustomTheme.colorGold,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              clockIn ? "Clock In" : "Clock Out",
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
                          "${DateFormat('EEEE, d MMMM y').format(DateTime.parse(clockTime))}\n"
                          "${DateFormat('hh.mm a').format(DateTime.parse(clockTime))}",
                          style: CustomTheme().smallFont(
                            CustomTheme.whiteButNot,
                            FontWeight.w400,
                            context,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: CustomTheme.colorGold,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Location",
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
                address,
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
                "Coordinates: $location",
                style: CustomTheme().superSmallFont(
                  CustomTheme.whiteButNot.withOpacity(0.7),
                  FontWeight.w400,
                  context,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationMap(double latitude, double longitude) {
    return Container(
      height: 300,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: CustomTheme.colorBrown.withOpacity(0.3),
        borderRadius: CustomTheme.borderRadius,
        border: Border.all(
          color: CustomTheme.colorGold.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: CustomTheme.borderRadius,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(latitude, longitude),
            initialZoom: 16,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              userAgentPackageName: "com.example.hr_attendance_tracker",
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(latitude, longitude),
                  width: 80,
                  height: 80,
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
