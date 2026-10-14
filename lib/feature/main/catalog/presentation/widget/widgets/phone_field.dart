import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../core/helpers/validators.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/widgets.dart';

class PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? Function(String?)? validator;

  const PhoneField({
    super.key,
    required this.controller,
    this.hintText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      hintText: hintText ?? '05xxxxxxxxx',
      prefixIcon: Icons.phone_android,
      keyboardType: TextInputType.phone,
      borderColor: AppColors.border,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(11),
      ],
      validator: validator ?? Validators.phoneNumberValidator,
    );
  }
}
