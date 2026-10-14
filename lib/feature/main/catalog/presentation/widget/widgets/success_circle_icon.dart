import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SuccessCircleIcon extends StatelessWidget {
  final Color color;

  const SuccessCircleIcon({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      height: 90.h,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.check_circle_outline, color: color, size: 44.sp),
    );
  }
}
