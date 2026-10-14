import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../main/catalog/presentation/widget/widgets/auth_primary_button.dart';
import '../../../main/catalog/presentation/widget/widgets/success_circle_icon.dart';

class SuccessScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonLabel;
  final String nextRoute;
  final int color;

  const SuccessScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.nextRoute,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = Color(color);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SuccessCircleIcon(color: c),
              SizedBox(height: 20.h),
              Text(
                title.tr(),
                style: AppTextTheme.h1,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle.tr(),
                  textAlign: TextAlign.center,
                  style: AppTextTheme.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.7,
                  ),
                ),
              SizedBox(height: 28.h),
              AuthPrimaryButton(
                label: buttonLabel.tr(),
                onPressed: () => context.go(nextRoute),
                backgroundColor: c,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
