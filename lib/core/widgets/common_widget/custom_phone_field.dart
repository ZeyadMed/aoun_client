import 'package:easy_localization/easy_localization.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'dart:ui' as ui;

class CustomPhoneField extends StatelessWidget {
  final void Function(PhoneNumber)? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const CustomPhoneField({
    super.key,
    this.onChanged,
    this.validator,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final inputColor = isDarkMode ? Colors.white : Colors.black87;
    final hintColor = isDarkMode ? Colors.white38 : Colors.grey;
    final fillColor = isDarkMode ? const Color(0xFF1F1F1F) : Colors.white;
    final borderColor = isDarkMode ? Colors.white24 : Colors.grey.shade300;

    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: IntlPhoneField(
        controller: controller,
        initialCountryCode: 'EG',
        style: TextStyle(fontSize: 18, color: inputColor),
        dropdownTextStyle: TextStyle(fontSize: 18, color: inputColor),
        dropdownDecoration: BoxDecoration(),
        disableLengthCheck: false,
        disableAutoFillHints: false,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.phone,
        languageCode: 'ar',
        pickerDialogStyle: PickerDialogStyle(
          backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          countryNameStyle: TextStyles.blackBold16.copyWith(color: inputColor),
          countryCodeStyle: TextStyles.blackBold14.copyWith(color: inputColor),
          searchFieldPadding: const EdgeInsets.all(5),
        ),
        invalidNumberMessage: "invalidPhoneNumber".tr(),
        onChanged: onChanged,
        validator: (phone) => validator?.call(phone?.number),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
          ),
          hintText: "XXXXXXXXXXX",
          fillColor: fillColor,
          filled: true,
          hintStyle: TextStyles.greyColor2Regular14.copyWith(
            color: hintColor,
            fontSize: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primaryColor, width: 0.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 1.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.redAccent, width: 1.0),
          ),
          errorStyle: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
