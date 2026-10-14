import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/router/app_router.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_theme.dart';

class ForgotPasswordLink extends StatelessWidget {
  const ForgotPasswordLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () => context.go(AppRouter.forgetPassword),
        child: Text(
          'نسيت كلمة المرور؟',
          style: AppTextTheme.labelSmall.copyWith(
            color: AppColors.mainAppColor,
          ),
        ),
      ),
    );
  }
}
