import '../../extensions/extensions.dart';
import '../../style/assets.dart';
import '../../theme/text_styles.dart';
import '../../theme/theme_mode_controller.dart';
import '../stateless/flexiable_image.dart';
import '../widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AuthHead extends StatelessWidget {
  final String title;
  final String subTitle;
  final bool toggleTheme;
  const AuthHead({
    super.key,
    required this.title,
    required this.subTitle,
    required this.toggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final fieldIconColor = colorScheme.onSurface.withValues(alpha: 0.7);
    final titleColor = colorScheme.onSurface;
    final subTitleColor = colorScheme.onSurface.withValues(alpha: 0.8);
    final isDarkMode = context.isDarkMode;
    final sectionGap = context.responsiveValue<double>(
      smallMobile: 16,
      mobile: 20,
      tablet: 24,
    );
    final logoSize = context.responsiveValue<double>(
      smallMobile: 70,
      mobile: 86,
      tablet: 120,
    );
    final welcomeFontSize = context.responsiveValue<double>(
      smallMobile: 26,
      mobile: 32,
      tablet: 42,
    );
    final subtitleFontSize = context.responsiveValue<double>(
      smallMobile: 15,
      mobile: 18,
      tablet: 24,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FlexibleImage(
          source: Assets.assetsImagesAounLogo,
          width: logoSize,
          height: logoSize,
        ),
        toggleTheme == true
            ? Align(
                alignment: AlignmentDirectional.centerEnd,
                child: IconButton(
                  tooltip: 'Toggle theme',
                  onPressed: ThemeModeController.toggleTheme,
                  icon: Icon(
                    isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    color: fieldIconColor,
                  ),
                ),
              )
            : SizedBox.shrink(),
        Gap(sectionGap),
        LocalizedLabel(
          text: title,
          style: TextStyles.blackBold32.copyWith(
            color: titleColor,
            fontSize: welcomeFontSize,
          ),
        ),
        Gap(10.h),
        LocalizedLabel(
          text: subTitle,
          style: TextStyles.blackRegular18.copyWith(
            color: subTitleColor,
            fontSize: subtitleFontSize,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
