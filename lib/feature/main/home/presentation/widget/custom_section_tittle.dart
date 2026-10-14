import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:aoun_client/core/theme/app_colors.dart';
import 'package:aoun_client/core/theme/app_text_theme.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onMore;
  const SectionTitle({super.key, required this.title, this.onMore});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: AppTextTheme.labelLarge),
      if (onMore != null)
        GestureDetector(
          onTap: onMore,
          child: Text(
            'home.see_all'.tr(),
            style: AppTextTheme.caption.copyWith(
              color: AppColors.mainAppColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
    ],
  );
}
