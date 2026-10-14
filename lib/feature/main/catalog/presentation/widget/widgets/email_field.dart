import 'package:flutter/material.dart';

import '../../../../../../core/helpers/validators.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/widgets.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  final bool optional;

  const EmailField({
    super.key,
    required this.controller,
    this.optional = false,
  });

  String? _validator(String? v) {
    if (optional && (v == null || v.isEmpty)) return null;
    return Validators.emailValidator(v);
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      hintText: 'example@email.com',
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      borderColor: AppColors.border,
      validator: _validator,
    );
  }
}
