import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_theme.dart';

class PasswordRequirementItem extends StatelessWidget {
  final String text;
  final bool done;

  const PasswordRequirementItem({
    super.key,
    required this.text,
    required this.done,
  });

  @override
  Widget build(BuildContext context) {
    final color = done ? AppColors.success : AppColors.textHint;
    return Padding(
      padding: EdgeInsets.only(top: 3.h),
      child: Row(
        children: [
          Icon(
            done ? Icons.check_circle : Icons.circle_outlined,
            size: 12.sp,
            color: color,
          ),
          SizedBox(width: 6.w),
          Text(
            text,
            style: AppTextTheme.caption.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
