import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_theme.dart';

class OrDivider extends StatelessWidget {
  final String label;

  const OrDivider({super.key, this.label = 'أو'});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Text(label, style: AppTextTheme.caption),
        ),
        const Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }
}
