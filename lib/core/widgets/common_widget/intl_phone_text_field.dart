
import '../../helpers/helpers.dart';
import '../../theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class IntelPhoneTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? hintText;
  final String? initialValue;
  final Function(String)? onPhoneChanged; // Callback لتمرير الرقم الكامل

  const IntelPhoneTextField({
    super.key,
    this.controller,
    this.validator,
    this.hintText,
    this.onPhoneChanged,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      decoration: InputDecoration(
        hintText: hintText ?? '01xxxxxxxxx',
        hintStyle: TextStyle(
          color: AppColors.hintTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      initialValue: initialValue?? '',
      controller: controller,
      disableAutoFillHints: false,
      initialCountryCode: 'EG',
      languageCode:
          Localizations.localeOf(context).languageCode == 'ar' ? 'ar' : 'en',
      onChanged: (phone) {
        logger(phone.completeNumber); // للـ debugging
        if (onPhoneChanged != null) {
          onPhoneChanged!(phone.completeNumber); // تمرير الرقم الكامل
        }
      },
      onCountryChanged: (country) {
        logger('Country changed to: ${country.name}');
        if (controller != null) {
          controller!.clear(); // تنظيف الـ controller عند تغيير البلد
        }
      },
    );
  }
}
