import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_theme.dart';

class OnboardingPageTwo extends StatelessWidget {
  const OnboardingPageTwo({super.key});

  static const Color _bgLight = Color(0xFFEAF3DE);
  static const Color _bgDeep = Color(0xFFC0DD97);
  static const Color _accent = Color(0xFF3B6D11);

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
              'تتبع أقساطك بسهولة',
              style: AppTextTheme.h1.copyWith(fontSize: 20.sp),
            ),
          ),
          SizedBox(height: 12.h),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'كشف حساب تفصيلي لكل عقد، اعرف الباقي في أي وقت، وادفع جزءًا أو كامل القسط من داخل التطبيق مباشرة.',
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
          height: 160.h,
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60.w,
                height: 60.h,
                decoration: const BoxDecoration(
                  color: _accent,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: Colors.white, size: 34.sp),
              ),
              SizedBox(height: 18.h),
              Container(
                width: 100.w,
                height: 8.h,
                decoration: BoxDecoration(
                  color: _bgDeep,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
