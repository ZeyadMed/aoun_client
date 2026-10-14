import 'package:flutter/material.dart';
import '../../../../../../core/extensions/extensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/text_styles.dart';
import '../../../../../../core/widgets/widgets.dart';

class TermsPrivacyDialog extends StatelessWidget {
  const TermsPrivacyDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => const TermsPrivacyDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;
    final colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      title: LocalizedLabel(
        text: 'termsAndCondation',
        style: TextStyles.blackBold14.copyWith(color: colorScheme.onSurface),
      ),
      content: SingleChildScrollView(
        child: Text(
          '1. باستخدام التطبيق، أنت توافق على استخدامه بشكل قانوني ومسؤول.\n\n'
          '2. يتم جمع بعض البيانات الأساسية لتحسين تجربة الاستخدام وتقديم الخدمة.\n\n'
          '3. نحافظ على خصوصية بياناتك ولا نشاركها مع أي طرف ثالث إلا عند الضرورة القانونية.\n\n'
          '4. يحق لنا تحديث هذه الأحكام من وقت لآخر، ويعتبر استمرارك في الاستخدام موافقة على التحديثات.\n\n'
          '5. في حالة وجود أي استفسار بخصوص الخصوصية أو الأحكام، يمكنك التواصل مع فريق الدعم.',
          textAlign: TextAlign.start,
          style: TextStyles.blackRegular12.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.85),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: LocalizedLabel(
            text: 'close',
            style: TextStyles.blackRegular14.copyWith(
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
