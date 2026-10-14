import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aoun_client/core/theme/app_colors.dart';
import 'package:aoun_client/core/theme/app_text_theme.dart';

class MiniContractCard extends StatelessWidget {
  final String name, id, type, progress, statusLabel;
  final double pct;
  final Color color, statusFg, statusBg;
  final int installment;
  final VoidCallback onTap;
  const MiniContractCard({
    super.key,
    required this.name,
    required this.id,
    required this.type,
    required this.progress,
    required this.pct,
    required this.color,
    required this.statusLabel,
    required this.statusFg,
    required this.statusBg,
    required this.installment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Card(
      margin: EdgeInsets.only(bottom: 8.h),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTextTheme.labelLarge.copyWith(fontSize: 12.sp),
                    ),
                    Text('$id · $type', style: AppTextTheme.caption),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$installment ج.م',
                      style: AppTextTheme.labelLarge.copyWith(
                        color: color,
                        fontSize: 13.sp,
                      ),
                    ),
                    Text('القسط الشهري', style: AppTextTheme.caption),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: LinearProgressIndicator(
                value: pct,
                backgroundColor: AppColors.bgTertiary,
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 4.h,
              ),
            ),
            SizedBox(height: 6.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$progress قسط', style: AppTextTheme.caption),

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 3.h,
                  ),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    statusLabel,
                    style: AppTextTheme.captionBold.copyWith(color: statusFg),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
