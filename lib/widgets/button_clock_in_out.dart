import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/custom_theme.dart';

class ButtonClockInOut extends StatelessWidget {
  final bool isClockIn;
  final VoidCallback onPressed;
  const ButtonClockInOut({
    super.key,
    required this.isClockIn,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        icon: Icon(
          isClockIn ? Icons.output : Icons.input,
          color: CustomTheme.colorBrown,
        ),
        label: Text(
          isClockIn ? 'Clock Out' : 'Clock In',
          style: CustomTheme().smallFont(CustomTheme.colorBrown, null, context),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isClockIn ? Colors.red : Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: CustomTheme.colorGold, width: 2),
          ),
          elevation: 3,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
