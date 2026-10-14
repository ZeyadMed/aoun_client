import 'package:flutter/material.dart';

import '../../../../../../core/helpers/validators.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/widgets.dart';

class AddressField extends StatelessWidget {
  final TextEditingController controller;

  const AddressField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      hintText: 'الرياض، حي النرجس',
      prefixIcon: Icons.location_on_outlined,
      borderColor: AppColors.border,
      validator: Validators.cityValidator,
    );
  }
}
