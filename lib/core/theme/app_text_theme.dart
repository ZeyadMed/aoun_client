import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aoun_client/core/theme/app_colors.dart';

abstract interface class AppTextTheme {
  static TextStyle _baseStyle(Color color) =>
      TextStyle(height: 1.5, color: color, fontFamily: 'Alexandria');

  static TextStyle get display1 =>
      _baseStyle(AppColors.textPrimary)
          .copyWith(fontSize: 32.sp, fontWeight: FontWeight.bold);

  static TextStyle get h1 =>
      _baseStyle(AppColors.textPrimary)
          .copyWith(fontSize: 24.sp, fontWeight: FontWeight.bold);

  static TextStyle get h2 =>
      _baseStyle(AppColors.textPrimary)
          .copyWith(fontSize: 20.sp, fontWeight: FontWeight.bold);

  static TextStyle get h3 =>
      _baseStyle(AppColors.textPrimary)
          .copyWith(fontSize: 18.sp, fontWeight: FontWeight.bold);

  static TextStyle get h4 =>
      _baseStyle(AppColors.textPrimary)
          .copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600);

  static TextStyle get display2 =>
      _baseStyle(AppColors.textPrimary)
          .copyWith(fontSize: 28.sp, fontWeight: FontWeight.bold);

  static TextStyle get heading1 => h1;
  static TextStyle get heading2 => h3;

  static TextStyle get button =>
      _baseStyle(Colors.white)
          .copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600);

  static TextStyle get body1 =>
      _baseStyle(AppColors.textPrimary).copyWith(fontSize: 16.sp);

  static TextStyle get body1Bold =>
      _baseStyle(AppColors.textPrimary)
          .copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold);

  static TextStyle get body2 =>
      _baseStyle(AppColors.textPrimary).copyWith(fontSize: 14.sp);

  static TextStyle get caption =>
      _baseStyle(AppColors.textSecondary).copyWith(fontSize: 12.sp);

  static TextStyle get text9 =>
      _baseStyle(AppColors.textSecondary).copyWith(fontSize: 9.sp);

  static TextStyle get captionBold =>
      _baseStyle(AppColors.textSecondary)
          .copyWith(fontSize: 12.sp, fontWeight: FontWeight.bold);

  static TextStyle get bodyLarge =>
      _baseStyle(AppColors.textPrimary).copyWith(fontSize: 30.sp);

  static TextStyle get bodyMedium =>
      _baseStyle(AppColors.textPrimary).copyWith(fontSize: 25.sp);

  static TextStyle get bodySmall =>
      _baseStyle(AppColors.textPrimary).copyWith(fontSize: 14.sp);

  static TextStyle get labelLarge =>
      _baseStyle(AppColors.textPrimary).copyWith(fontSize: 14.sp);

  static TextStyle get labelMedium =>
      _baseStyle(AppColors.textPrimary).copyWith(fontSize: 12.sp);

  static TextStyle get labelSmall =>
      _baseStyle(AppColors.textPrimary).copyWith(fontSize: 10.sp);

  static TextStyle get titleLarge =>
      _baseStyle(AppColors.textPrimary).copyWith(fontSize: 22.sp);

  static TextStyle get titleMedium =>
      _baseStyle(AppColors.textPrimary).copyWith(fontSize: 20.sp);

  static TextStyle get titleSmall =>
      _baseStyle(AppColors.textPrimary).copyWith(fontSize: 18.sp);

  static TextStyle get displayLarge =>
      _baseStyle(AppColors.textPrimary).copyWith(fontSize: 34.sp);

  static TextStyle get displayMedium =>
      _baseStyle(AppColors.textPrimary).copyWith(fontSize: 28.sp);

  static TextStyle get displaySmall =>
      _baseStyle(AppColors.textPrimary).copyWith(fontSize: 22.sp);

  static TextStyle get headlineLarge =>
      _baseStyle(AppColors.textPrimary)
          .copyWith(fontSize: 35.sp, fontWeight: FontWeight.bold);

  static TextStyle get headlineMedium =>
      _baseStyle(AppColors.textPrimary).copyWith(fontSize: 28.sp);

  static TextStyle get headlineSmall =>
      _baseStyle(AppColors.textPrimary).copyWith(fontSize: 24.sp);
}
