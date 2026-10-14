import 'package:flutter/material.dart';

import '../../../../../../core/helpers/validators.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/widgets.dart';

class NameField extends StatelessWidget {
  final TextEditingController controller;

  const NameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      hintText: 'محمد عبدالله',
      prefixIcon: Icons.person_outline,
      borderColor: AppColors.border,
      validator: Validators.displayNameValidator,
    );
  }
}
