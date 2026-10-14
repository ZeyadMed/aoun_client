import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../main/catalog/presentation/widget/widgets/auth_header.dart';
import 'verify_otp/presentation/screen/verify_otp_body.dart';

class OtpScreen extends StatelessWidget {
  final String phone;
  final String type;

  const OtpScreen({
    super.key,
    required this.phone,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AuthHeader(
            title: 'auth.otp_title'.tr(),
            subtitle: '${'auth.otp_subtitle'.tr()} +966 $phone',
            gradient: false,
            decorative: false,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(22.w),
              child: VerifyOtpBody(phone: phone, type: type),
            ),
          ),
        ],
      ),
    );
  }
}
