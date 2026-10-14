import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aoun_client/core/theme/app_colors.dart';
import 'package:aoun_client/core/theme/app_text_theme.dart';

class PayRow extends StatelessWidget {
  final String name, date, amount;
  const PayRow(this.name, this.date, this.amount, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
    child: Row(
      children: [
        SizedBox(width: 10.w),
        Container(
          width: 32.w,
          height: 32.h,
          decoration: BoxDecoration(
            color: AppColors.successLight,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(Icons.check, color: AppColors.success, size: 16.sp),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: AppTextTheme.labelSmall),
            Text(date, style: AppTextTheme.caption),
          ],
        ),

        Spacer(),
        Text(
          amount,
          style: AppTextTheme.labelMedium.copyWith(color: AppColors.success),
        ),
      ],
    ),
  );
}
