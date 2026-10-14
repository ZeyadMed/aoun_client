import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_colors.dart';

class OtpInfoIcon extends StatelessWidget {
  const OtpInfoIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68.w,
      height: 68.h,
      decoration: BoxDecoration(
        color: AppColors.mainLight,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Icon(
        Icons.smartphone,
        color: AppColors.mainAppColor,
        size: 30.sp,
      ),
    );
  }
}
