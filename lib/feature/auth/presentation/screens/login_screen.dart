import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../main/catalog/presentation/widget/widgets/auth_header.dart';
import '../../../main/catalog/presentation/widget/widgets/auth_tab_bar.dart';
import 'login/presentation/screen/login_form.dart';
import 'register/presentation/screen/register_form.dart';
import '../../../main/catalog/presentation/widget/widgets/terms_agree_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final isLogin = _tab == 0;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AuthHeader(
              title: 'تقسيط برو',
              subtitle: isLogin ? 'auth.log_in'.tr() : 'auth.register'.tr(),
            ),
            Padding(
              padding: EdgeInsets.all(22.w),
              child: Column(
                children: [
                  AuthTabBar(
                    selectedIndex: _tab,
                    labels: const ['تسجيل الدخول', 'إنشاء حساب'],
                    onChanged: (i) => setState(() => _tab = i),
                  ),
                  SizedBox(height: 20.h),
                  isLogin ? const LoginForm() : const RegisterForm(),
                  SizedBox(height: 20.h),
                  // if (isLogin) const TermsAgreeText(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
