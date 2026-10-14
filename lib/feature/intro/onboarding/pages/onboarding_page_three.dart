import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_theme.dart';

class OnboardingPageThree extends StatelessWidget {
  const OnboardingPageThree({super.key});

  static const Color _bgLight = Color(0xFFE8F9F1);
  static const Color _bgDeep = Color(0xFF9FE1CB);
  static const Color _accent = Color(0xFF0F6E56);

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
            child: RichText(
              textAlign: TextAlign.right,
              text: TextSpan(
                style: AppTextTheme.h1.copyWith(fontSize: 20.sp),
                children: [
                  TextSpan(
                    text: 'إشعارات ',
                    style: AppTextTheme.h1.copyWith(fontSize: 20.sp),
                  ),
                  TextSpan(
                    text: 'WhatsApp',
                    style: AppTextTheme.h1.copyWith(
                      fontSize: 20.sp,
                      color: AppColors.whatsapp,
                    ),
                  ),
                  TextSpan(
                    text: ' فورية',
                    style: AppTextTheme.h1.copyWith(fontSize: 20.sp),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'تذكيرات آلية قبل موعد كل قسط، إيصال فوري بعد كل دفعة، وإشعار عند أي تغيير على عقدك.',
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
        child: SizedBox(
          width: 200.w,
          height: 160.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                right: 20.w,
                top: 20.h,
                child: _buildCard(width: 70.w, height: 110.h),
              ),
              Positioned(
                left: 20.w,
                top: 30.h,
                child: _buildCardWithCheck(width: 80.w, height: 100.h),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required double width, required double height}) => Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: _bgDeep,
                borderRadius: BorderRadius.circular(3.r),
              ),
            ),
          ],
        ),
      );

  Widget _buildCardWithCheck({required double width, required double height}) =>
      Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: _bgDeep,
                borderRadius: BorderRadius.circular(3.r),
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 32.w,
                height: 32.h,
                decoration: const BoxDecoration(
                  color: _accent,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: Colors.white, size: 18.sp),
              ),
            ),
          ],
        ),
      );
}
