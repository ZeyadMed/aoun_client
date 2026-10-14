import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/helpers/validators.dart';
import '../../../../../../core/router/app_router.dart';
import 'auth_primary_button.dart';
import 'field_label.dart';
import 'password_field.dart';
import 'password_requirements_box.dart';

class NewPasswordForm extends StatefulWidget {
  const NewPasswordForm({super.key});

  @override
  State<NewPasswordForm> createState() => _NewPasswordFormState();
}

class _NewPasswordFormState extends State<NewPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _p1 = TextEditingController();
  final _p2 = TextEditingController();

  @override
  void dispose() {
    _p1.dispose();
    _p2.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.go(AppRouter.successPassword);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 16.h),
          const FieldLabel('كلمة المرور الجديدة'),
          PasswordField(
            controller: _p1,
            onChanged: (_) => setState(() {}),
          ),
          SizedBox(height: 14.h),
          const FieldLabel('تأكيد كلمة المرور'),
          PasswordField(
            controller: _p2,
            validator: (v) => Validators.repeatPasswordValidator(
              value: v,
              Password: _p1.text,
            ),
          ),
          SizedBox(height: 16.h),
          PasswordRequirementsBox(password: _p1.text),
          SizedBox(height: 20.h),
          AuthPrimaryButton(
            label: 'تحديث كلمة المرور',
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
