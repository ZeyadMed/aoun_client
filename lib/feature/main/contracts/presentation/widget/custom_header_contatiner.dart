import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aoun_client/core/theme/app_colors.dart';
import 'package:aoun_client/core/theme/app_text_theme.dart';

class CustomHeaderContatiner extends StatelessWidget {
  final int activeCount;
  const CustomHeaderContatiner({super.key, required this.activeCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.mainAppColor,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        16.w,
        MediaQuery.of(context).padding.top + 12.h,
        16.w,
        14.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'contracts.title'.tr(),
            style: AppTextTheme.h3.copyWith(color: Colors.white),
          ),
          Text(
            'contracts.active_count'.tr(namedArgs: {'count': '$activeCount'}),
            style: AppTextTheme.caption.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
