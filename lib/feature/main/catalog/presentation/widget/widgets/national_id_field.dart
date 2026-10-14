import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aoun_client/core/helpers/validators.dart';
import 'package:aoun_client/core/theme/app_colors.dart';
import 'package:aoun_client/core/widgets/widgets.dart';

class NationalIdField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? Function(String?)? validator;

  const NationalIdField({
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
        LengthLimitingTextInputFormatter(14),
      ],
      validator: validator ?? Validators.nationalIdValidator,
    );
  }
}
