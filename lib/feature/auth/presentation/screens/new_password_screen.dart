import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../main/catalog/presentation/widget/widgets/auth_header.dart';
import '../../../main/catalog/presentation/widget/widgets/new_password_form.dart';

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AuthHeader(
            title: 'auth.new_password'.tr(),
            subtitle: 'اختر كلمة مرور قوية',
            gradient: false,
            decorative: false,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(22.w),
              child: const NewPasswordForm(),
            ),
          ),
        ],
      ),
    );
  }
}
