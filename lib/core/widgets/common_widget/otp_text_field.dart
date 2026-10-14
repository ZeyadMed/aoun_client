// import '../../helpers/helpers.dart';
// import '../../theme/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:pinput/pinput.dart';
// import 'dart:ui' as ui;

// class OtpTextField extends StatefulWidget {
//   final TextEditingController pinController;
//   const OtpTextField({super.key, required this.pinController});

//   @override
//   State<OtpTextField> createState() => _OtpTextFieldState();
// }

// class _OtpTextFieldState extends State<OtpTextField> {
//   final formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     final pinBorderColor = isDarkMode
//         ? Colors.white24
//         : const Color(0xffcfdbec);
//     final fillColor = isDarkMode ? const Color(0xFF1F1F1F) : Colors.white;
//     final pinTextColor = isDarkMode ? Colors.white : AppColors.primaryColor;

//     final defaultPinTheme = PinTheme(
//       width: 64.w,
//       height: 56.h,
//       textStyle: TextStyle(
//         fontSize: 20.sp,
//         color: pinTextColor,
//         fontWeight: FontWeight.w600,
//       ),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8.0),
//         color: fillColor,
//         border: Border.all(color: pinBorderColor, width: 1.2),
//       ),
//     );

//     return Form(
//       key: formKey,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Directionality(
//             textDirection: ui.TextDirection.ltr,
//             child: Pinput(
//               length: 4,
//               controller: widget.pinController,
//               defaultPinTheme: defaultPinTheme,
//               separatorBuilder: (index) => Gap(8.w),
//               hapticFeedbackType: HapticFeedbackType.lightImpact,
//               onCompleted: (pin) {
//                 logger('onCompleted: $pin');
//               },
//               onChanged: (value) {
//                 logger('onChanged: $value');
//               },
//               cursor: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.only(bottom: 9),
//                     width: 20.w,
//                     height: 2,
//                     color: AppColors.primaryColor,
//                   ),
//                 ],
//               ),
//               focusedPinTheme: defaultPinTheme.copyWith(
//                 decoration: BoxDecoration(
//                   color: fillColor,
//                   borderRadius: BorderRadius.circular(8.0),
//                   border: Border.all(color: AppColors.primaryColor, width: 1.6),
//                 ),
//               ),
//               submittedPinTheme: defaultPinTheme.copyWith(
//                 decoration: BoxDecoration(
//                   color: fillColor,
//                   borderRadius: BorderRadius.circular(8.0),
//                   border: Border.all(color: AppColors.primaryColor, width: 1.2),
//                 ),
//               ),
//               errorPinTheme: defaultPinTheme.copyWith(
//                 decoration: BoxDecoration(
//                   color: fillColor,
//                   borderRadius: BorderRadius.circular(8.0),
//                   border: Border.all(color: Colors.redAccent, width: 1.4),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
