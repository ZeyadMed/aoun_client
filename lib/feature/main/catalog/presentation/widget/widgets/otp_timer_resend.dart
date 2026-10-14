import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_theme.dart';

class OtpTimerResend extends StatelessWidget {
  final int seconds;
  final VoidCallback onResend;

  const OtpTimerResend({
    super.key,
    required this.seconds,
    required this.onResend,
  });

  String get _timeStr {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final expired = seconds == 0;
    return Column(
      children: [
        Text(
          expired ? 'انتهت صلاحية الرمز' : '${'auth.otp_expires'.tr()} $_timeStr',
          style: AppTextTheme.caption.copyWith(
            color: expired ? AppColors.error : AppColors.textHint,
          ),
        ),
        if (expired) ...[
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: onResend,
            child: Text(
              'auth.otp_resend'.tr(),
              style: AppTextTheme.labelSmall.copyWith(
                color: AppColors.mainAppColor,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
