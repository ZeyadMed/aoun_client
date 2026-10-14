import 'package:easy_localization/easy_localization.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';
import '../widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Customtextfield extends StatefulWidget {
  const Customtextfield({
    super.key,
    required this.hintText,
    required this.textEditingController,
    // final VoidCallback? onTap,
    this.prefix,
    this.suffix,
    this.obscureText = false,
    this.readOnly = false,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.onSubmitted,
    this.decoration,
    this.maxLines,
    this.maxLength,
    this.borderRadious,
    this.style,
    this.minLines,
    this.labelText,
    this.hieght,
    this.onDateSelected,
    this.onTap,
  });
  final String hintText;
  final TextEditingController textEditingController;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final double? borderRadious;
  final dynamic prefix;
  final dynamic suffix;
  final bool obscureText;
  final bool readOnly;
  final InputDecoration? decoration;
  final String? Function(String?)? onChanged;
  final Function(DateTime?)? onDateSelected;
  final VoidCallback? onTap;
  // ignore: prefer_typing_uninitialized_variables
  final TextInputType? keyboardType;
  final String? Function(String?)? onSubmitted;
  final String? Function(String?)? validator;
  final TextStyle? style;
  final String? labelText;
  final num? hieght;

  @override
  State<Customtextfield> createState() => _CustomtextfieldState();
}

class _CustomtextfieldState extends State<Customtextfield> {
  late bool hidden;

  Widget? _buildDecorationIcon(dynamic icon) {
    if (icon == null) return null;
    if (icon is Widget) return icon;
    if (icon is IconData) return Icon(icon);
    return null;
  }

  @override
  void initState() {
    super.initState();
    hidden = widget.obscureText;
  }

  @override
  void didUpdateWidget(covariant Customtextfield oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the parent changed the obscureText prop, update internal hidden state
    if (oldWidget.obscureText != widget.obscureText) {
      hidden = widget.obscureText;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(primary: AppColors.primaryColor),
          ),
          child: child!,
        );
      },
      lastDate: DateTime(2200),
    );

    if (pickedDate != null) {
      final day = pickedDate.day.toString().padLeft(2, '0');
      final month = pickedDate.month.toString().padLeft(2, '0');
      final year = pickedDate.year.toString();
      // Format as DD/MM/YYYY with leading zeros for day and month
      widget.textEditingController.text = '$day-$month-$year';
      if (widget.onDateSelected != null) {
        widget.onDateSelected!(pickedDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDarkMode ? Colors.white70 : Colors.black87;
    final inputColor = isDarkMode ? Colors.white : Colors.black87;
    final hintColor = isDarkMode ? Colors.white38 : Colors.grey;
    final fillColor = isDarkMode ? const Color(0xFF1F1F1F) : Colors.white;
    final borderColor = isDarkMode ? Colors.white24 : Colors.grey.shade300;

    return Column(
      children: [
        widget.labelText != null
            ? Padding(
                padding: const EdgeInsetsDirectional.only(start: 6),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: LocalizedLabel(
                    text: widget.labelText ?? '',
                    style: (widget.style ?? TextStyles.blackBold14).copyWith(
                      color: labelColor,
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
        SizedBox(height: 5.h),
        TextFormField(
          readOnly: widget.onDateSelected != null ? true : widget.readOnly,
          maxLength: widget.maxLength,
          maxLines: widget.maxLines ?? 1,
          minLines: widget.minLines,
          onFieldSubmitted: widget.onSubmitted,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          controller: widget.textEditingController,
          onChanged: widget.onChanged,
          obscureText: hidden,
          style: (widget.style ?? TextStyles.darkRegular16).copyWith(
            color: inputColor,
          ),
          onTap:
              widget.onTap ??
              () {
                if (widget.onDateSelected != null) {
                  _selectDate(context);
                }
              },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: (widget.hieght ?? 10.h).toDouble(),
              horizontal: 10.w,
            ),
            hintText: widget.hintText.tr(),
            fillColor: fillColor,
            filled: true,
            //counterStyle: TextStyles.darkRegular16,
            hintStyle: TextStyles.greyColor2Regular14.copyWith(
              color: hintColor,
              fontSize: 14.sp,
            ),
            prefixIcon: _buildDecorationIcon(widget.prefix),
            suffixIcon: _buildDecorationIcon(widget.suffix),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: borderColor, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadious ?? 9.r),
              borderSide: BorderSide(color: borderColor, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadious ?? 9.r),
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
                width: 0.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadious ?? 9.r),
              borderSide: const BorderSide(color: Colors.red, width: 1.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadious ?? 9.r),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.0),
            ),
            errorStyle: const TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
