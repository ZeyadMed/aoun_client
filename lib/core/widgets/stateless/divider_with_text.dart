part of '../widgets.dart';

class DividerWithText extends StatelessWidget {
  final String text;
  final Color? dividerColor;
  final Color? textColor;
  final double thickness;
  final double spacing;
  final double? fontSize;
  final FontWeight? fontWeight;

  const DividerWithText({
    super.key,
    this.text = 'or',
    this.dividerColor,
    this.textColor,
    this.thickness = 1,
    this.spacing = 16,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveDividerColor =
        dividerColor ?? (context.isDarkMode ? Colors.white24 : Colors.black12);
    final effectiveTextColor =
        textColor ?? (context.isDarkMode ? Colors.white54 : Colors.black45);
    final effectiveFontSize =
      fontSize ?? context.responsiveValue<double>(smallMobile: 20, mobile: 22, tablet: 24);

    return Row(
      children: [
        Expanded(
          child: Divider(
            color: effectiveDividerColor,
            thickness: thickness,
          ),
        ),
        SizedBox(width: spacing),
        LocalizedLabel(
          text: text,
          style: AppTextTheme.bodyLarge.copyWith(
            color: effectiveTextColor,
            fontSize: effectiveFontSize,
            fontWeight: fontWeight ?? FontWeight.w500,
          ),
        ),
        SizedBox(width: spacing),
        Expanded(
          child: Divider(
            color: effectiveDividerColor,
            thickness: thickness,
          ),
        ),
      ],
    );
  }
}
