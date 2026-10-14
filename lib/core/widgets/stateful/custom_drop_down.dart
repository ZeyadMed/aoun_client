import 'package:easy_localization/easy_localization.dart';
import '../../theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class CustomDropdown<T> extends StatelessWidget {
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?) onChanged;

  const CustomDropdown({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color hintColor = isDarkMode ? Colors.white38 : Colors.grey;
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;
    final Color iconColor = isDarkMode ? Colors.white70 : Colors.grey;
    final Color fillColor = isDarkMode   ? const Color(0xFF1F1F1F)   : Colors.white;
    final Color borderColor = isDarkMode
        ? Colors.white24
        : Colors.grey.shade300;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
        color: fillColor,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          value: value,
          hint: Text(
            tr(hint),
            style: TextStyles.darkBold16.copyWith(color: hintColor),
            textDirection: ui.TextDirection.rtl,
          ),
          icon: Icon(Icons.keyboard_arrow_down, color: iconColor),
          items: items,
          onChanged: onChanged,
          style: TextStyles.darkBold16.copyWith(color: textColor),
          dropdownColor: fillColor,
        ),
      ),
    );
  }
}
