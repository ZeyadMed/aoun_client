import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aoun_client/core/theme/app_text_theme.dart';

class StatBox extends StatelessWidget {
  final String label, value;
  final Color color, bg;
  const StatBox({
    required this.label,
    required this.value,
    required this.color,
    required this.bg,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextTheme.labelMedium.copyWith(
              color: color,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 2.h),
          Text(label, style: AppTextTheme.caption),
        ],
      ),
    ),
  );
}
