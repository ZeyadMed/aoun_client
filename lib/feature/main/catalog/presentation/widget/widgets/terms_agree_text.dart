import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_theme.dart';
import 'terms_privacy_dialog.dart';

class TermsAgreeText extends StatelessWidget {
  const TermsAgreeText({super.key});

  @override
  Widget build(BuildContext context) {
    final linkStyle = AppTextTheme.captionBold.copyWith(
      color: AppColors.mainAppColor,
    );
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Text('أوافق على ', style: AppTextTheme.caption),
        GestureDetector(
          onTap: () => TermsPrivacyDialog.show(context),
          child: Text('شروط الاستخدام', style: linkStyle),
        ),
        Text(' و', style: AppTextTheme.caption),
        GestureDetector(
          onTap: () => TermsPrivacyDialog.show(context),
          child: Text('سياسة الخصوصية', style: linkStyle),
        ),
      ],
    );
  }
}
