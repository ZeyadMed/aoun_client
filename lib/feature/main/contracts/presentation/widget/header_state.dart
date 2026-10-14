import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aoun_client/core/theme/app_text_theme.dart';

class HeaderStat extends StatelessWidget {
  final String val, label;
  final Color color;
  const HeaderStat(this.val, this.label, this.color, {super.key});
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          Text(
            val,
            style: AppTextTheme.h4.copyWith(color: color, fontSize: 13.sp),
          ),
          Text(
            label,
            style: AppTextTheme.caption.copyWith(color: Colors.white60),
          ),
        ],
      ),
    ),
  );
}
