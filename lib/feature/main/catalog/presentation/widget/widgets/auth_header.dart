import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/router/app_router.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_theme.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool gradient;
  final bool showBack;
  final bool decorative;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.gradient = true,
    this.showBack = false,
    this.decorative = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        22.w,
        MediaQuery.of(context).padding.top + 22.h,
        22.w,
        26.h,
      ),
      decoration: gradient
          ? const BoxDecoration(gradient: AppColors.mainGradient)
          : const BoxDecoration(color: AppColors.mainAppColor),
      child: Stack(
        children: [
          if (decorative)
            Positioned(
              top: -40,
              right: -40,
              child: Container(
                width: 160.w,
                height: 160.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                    width: 30,
                  ),
                ),
              ),
            ),
          Row(
            children: [
              if (showBack)
                GestureDetector(
                  onTap: () => context.go(AppRouter.login),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
              if (showBack) SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          AppTextTheme.h2.copyWith(color: Colors.white),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: AppTextTheme.bodySmall.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
