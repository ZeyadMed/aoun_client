import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_theme.dart';

class OnboardingPageOne extends StatelessWidget {
  const OnboardingPageOne({super.key});

  static const Color _bgLight = AppColors.mainLight;
  static const Color _bgDeep = AppColors.mainSoft;
  static const Color _accent = AppColors.mainAppColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      child: Column(
        children: [
          SizedBox(height: 12.h),
          _buildIllustration(),
          SizedBox(height: 32.h),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'اشتري أي شيء بالأقساط',
              style: AppTextTheme.h1.copyWith(fontSize: 20.sp),
            ),
          ),
          SizedBox(height: 12.h),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'أجهزة، أثاث، إلكترونيات — اختر ما تحتاجه من كتالوجنا ووزّع السداد على أقساط تناسبك بدون تعقيدات.',
              textAlign: TextAlign.right,
              style: AppTextTheme.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      height: 240.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_bgLight, _bgDeep],
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Center(
        child: Container(
          width: 180.w,
          height: 150.h,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLine(width: 70.w, color: _bgDeep),
                      SizedBox(height: 6.h),
                      _buildLine(width: 40.w, color: _bgDeep.withValues(alpha: 0.6)),
                    ],
                  ),
                  Container(
                    width: 34.w,
                    height: 34.h,
                    decoration: const BoxDecoration(
                      color: _accent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check, color: Colors.white, size: 20.sp),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              _buildLine(width: 60.w, color: _bgDeep),
              SizedBox(height: 8.h),
              _buildLine(width: 40.w, color: _bgDeep),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLine({required double width, required Color color}) => Container(
        width: width,
        height: 8.h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4.r),
        ),
      );
}
