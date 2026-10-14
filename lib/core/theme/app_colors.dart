import 'package:flutter/material.dart';

class AppColors {
  // ─── Main Colors ─────────────────────────────────
  static const Color mainAppColor = Color(0xff064031);   // عون logo green
  static const Color secondaryColor = Color(0xffCB942C); // عون logo gold
  static const Color accentGreen = Color(0xff3B6D11);
  static const Color accentTeal = Color(0xff0F6E56);
  static const Color accentRed = Color(0xffA32D2D);
  static const Color accentPurple = Color(0xff534AB7);

  // ─── Light variants ───────────────────────────────
  static const Color mainLight = Color(0xffE6ECEA);
  static const Color mainSoft = Color(0xffB3D1C7);
  static const Color secondaryLight = Color(0xffF7EFDF);
  static const Color greenLight = Color(0xffEAF3DE);
  static const Color tealLight = Color(0xffE1F5EE);
  static const Color redLight = Color(0xffFCEBEB);
  static const Color purpleLight = Color(0xffEEEDFE);

  // ─── Background ───────────────────────────────────
  static const Color bgPrimary = Color(0xffF8F7F5);
  static const Color bgSecondary = Color(0xffffffff);
  static const Color bgTertiary = Color(0xffF1EFE8);

  // ─── Text ─────────────────────────────────────────
  static const Color textPrimary = Color(0xff1A1A18);
  static const Color textSecondary = Color(0xff5F5E5A);
  static const Color textHint = Color(0xff888780);

  // ─── Border ───────────────────────────────────────
  static const Color border = Color(0xffE0DDD6);
  static const Color borderDark = Color(0xffC8C4BC);

  // ─── Status ───────────────────────────────────────
  static const Color success = Color(0xff3B6D11);
  static const Color successLight = Color(0xffEAF3DE);
  static const Color warning = Color(0xff854F0B);
  static const Color warningLight = Color(0xffFAEEDA);
  static const Color error = Color(0xffA32D2D);
  static const Color errorLight = Color(0xffFCEBEB);
  static const Color info = Color(0xff0C447C);
  static const Color infoLight = Color(0xffE6F1FB);

  // ─── WhatsApp ──────────────────────────────────────
  static const Color whatsapp = Color(0xff25D366);
  static const Color whatsappLight = Color(0xffE8F9F1);

  // ─── Gradients ────────────────────────────────────
  static const LinearGradient mainGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Color(0xff0A5A45), Color(0xff064031)],
  );

  // ─── Legacy aliases (text_styles compatibility) ───
  static const Color semiBlackColor = Color(0xff2D2D2D);
  static const Color darkTextColor = textPrimary;
  static const Color greyColor = Color(0xff6B7280);
  static const Color greyColor4 = Color(0xff9CA3AF);
  static const Color lightBlueColor2 = Color(0xffB5D4F4);
  static const Color orangeColor = secondaryColor;
  static const Color whiteColor = Color(0xffFFFFFF);
  static const Color primaryColor = mainAppColor;
  static const Color greenColor = success;
  static const Color blackColor = Color(0xff000000);
  static const Color lightTextColor = textHint;
  static const Color hintTextColor = textHint;
}