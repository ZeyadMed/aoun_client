import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_theme.dart';
import 'password_requirement_item.dart';

class PasswordRequirementsBox extends StatelessWidget {
  final String password;

  const PasswordRequirementsBox({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.bgTertiary,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('متطلبات كلمة المرور:', style: AppTextTheme.labelMedium),
          SizedBox(height: 6.h),
          PasswordRequirementItem(
            text: '8 أحرف على الأقل',
            done: password.length >= 8,
          ),
          PasswordRequirementItem(
            text: 'حرف كبير وصغير',
            done: password.contains(RegExp(r'[A-Z]')) &&
                password.contains(RegExp(r'[a-z]')),
          ),
          PasswordRequirementItem(
            text: 'رقم واحد على الأقل',
            done: password.contains(RegExp(r'[0-9]')),
          ),
        ],
      ),
    );
  }
}
