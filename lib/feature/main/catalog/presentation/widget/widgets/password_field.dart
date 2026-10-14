import 'package:flutter/material.dart';

import '../../../../../../core/helpers/validators.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/widgets.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const PasswordField({
    super.key,
    required this.controller,
    this.hintText,
    this.validator,
    this.onChanged,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: widget.controller,
      hintText: widget.hintText ?? '8 أحرف على الأقل',
      prefixIcon: Icons.lock_outline,
      suffixIcon: _obscure ? Icons.visibility_off : Icons.visibility,
      onSuffixIconPressed: () => setState(() => _obscure = !_obscure),
      obscureText: _obscure,
      maxLines: 1,
      borderColor: AppColors.border,
      onChanged: widget.onChanged,
      validator: widget.validator ?? Validators.passwordValidator,
    );
  }
}
