import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_theme.dart';

class OtpPinField extends StatelessWidget {
  final int length;
  final ValueChanged<String> onCompleted;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const OtpPinField({
    super.key,
    this.length = 6,
    required this.onCompleted,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final defaultTheme = PinTheme(
      width: 48.w,
      height: 56.h,
      textStyle: AppTextTheme.h2.copyWith(color: AppColors.mainAppColor),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
    );
    final focused = defaultTheme.copyDecorationWith(
      border: Border.all(color: AppColors.mainAppColor, width: 2),
      color: AppColors.mainLight,
    );
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Pinput(
        controller: controller,
        length: length,
        defaultPinTheme: defaultTheme,
        focusedPinTheme: focused,
        submittedPinTheme: focused,
        onCompleted: onCompleted,
        onChanged: onChanged,
        hapticFeedbackType: HapticFeedbackType.lightImpact,
        keyboardType: TextInputType.number,
      ),
    );
  }
}
