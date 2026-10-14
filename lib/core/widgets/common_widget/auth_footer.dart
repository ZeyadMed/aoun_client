import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';
import '../widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AuthFooter extends StatelessWidget {
  final String text;
  final String textButton;
  final void Function()? onTap;
  const AuthFooter({
    super.key,
    required this.text,
    required this.textButton,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bodyTextColor = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.8);
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        LocalizedLabel(
          text: text,
          style: TextStyles.blackRegular14.copyWith(color: bodyTextColor),
        ),
        Gap(5.w),
        GestureDetector(
          onTap: onTap,
          child: LocalizedLabel(
            text: textButton,
            style: TextStyles.blackRegular14.copyWith(
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
