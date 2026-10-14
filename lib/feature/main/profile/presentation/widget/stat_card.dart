import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aoun_client/core/theme/app_text_theme.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color bg;

  const StatCard(this.label, this.value, this.color, this.bg, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextTheme.labelMedium.copyWith(
              color: color,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 4.h),

          Text(label, textAlign: TextAlign.center, style: AppTextTheme.caption),
        ],
      ),
    );
  }
}
