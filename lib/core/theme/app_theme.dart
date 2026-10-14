import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aoun_client/core/theme/app_colors.dart';
import 'package:aoun_client/core/theme/app_text_theme.dart';

mixin AppThemeData on ThemeData {
  static ThemeData light(BuildContext context) => ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.mainAppColor,
    colorScheme: ColorScheme.light(
      primary: AppColors.mainAppColor,
      secondary: AppColors.secondaryColor,
      surface: Colors.white,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textPrimary,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.bgPrimary,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.mainAppColor,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      titleTextStyle: AppTextTheme.h3.copyWith(color: Colors.white),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    fontFamily: 'Alexandria',
    textTheme: TextTheme(
      bodyLarge: AppTextTheme.bodyLarge,
      bodyMedium: AppTextTheme.bodyMedium,
      bodySmall: AppTextTheme.bodySmall,
      labelLarge: AppTextTheme.labelLarge,
      labelMedium: AppTextTheme.labelMedium,
      labelSmall: AppTextTheme.labelSmall,
      titleLarge: AppTextTheme.titleLarge,
      titleMedium: AppTextTheme.titleMedium,
      titleSmall: AppTextTheme.titleSmall,
      displayLarge: AppTextTheme.displayLarge,
      displayMedium: AppTextTheme.displayMedium,
      displaySmall: AppTextTheme.displaySmall,
      headlineLarge: AppTextTheme.headlineLarge,
      headlineMedium: AppTextTheme.headlineMedium,
      headlineSmall: AppTextTheme.headlineSmall,
    ),
    inputDecorationTheme: InputDecorationTheme(
      errorStyle: AppTextTheme.bodyMedium.copyWith(
        color: AppColors.error,
        fontSize: 12.sp,
      ),
      hintStyle: AppTextTheme.caption.copyWith(color: AppColors.textHint),
    ),
    iconTheme: const IconThemeData(color: AppColors.textPrimary),
  );

  static CupertinoThemeData cupertinoLight(BuildContext context) =>
      CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.mainAppColor,
        scaffoldBackgroundColor: AppColors.bgPrimary,
        barBackgroundColor: Colors.white,
      );

  static ThemeData dark(BuildContext context) => ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.mainAppColor,
    colorScheme: ColorScheme.dark(
      primary: AppColors.mainAppColor,
      secondary: AppColors.secondaryColor,
      surface: const Color(0xFF1E1E1E),
      error: AppColors.error,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1E1E1E),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      titleTextStyle: AppTextTheme.h3.copyWith(color: Colors.white),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    fontFamily: 'Alexandria',
    iconTheme: const IconThemeData(color: Colors.white),
  );

  static CupertinoThemeData cupertinoDark(BuildContext context) =>
      CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.mainAppColor,
        scaffoldBackgroundColor: const Color(0xFF121212),
        barBackgroundColor: const Color(0xFF1E1E1E),
      );
}
