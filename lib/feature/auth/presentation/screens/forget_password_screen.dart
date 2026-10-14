import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../main/catalog/presentation/widget/widgets/auth_header.dart';
import 'forget_password/presentation/screen/forget_password_form.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AuthHeader(
            title: 'استعادة كلمة المرور',
            subtitle: 'أدخل رقم جوالك المسجل',
            gradient: false,
            showBack: true,
            decorative: false,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(22.w),
              child: const ForgetPasswordForm(),
            ),
          ),
        ],
      ),
    );
  }
}
