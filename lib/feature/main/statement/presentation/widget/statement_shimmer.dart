import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aoun_client/core/theme/app_colors.dart';
import 'package:aoun_client/core/widgets/widgets.dart';

class StatementShimmer extends StatelessWidget {
  final bool showDropdown;
  const StatementShimmer({super.key, this.showDropdown = true});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: showDropdown ? EdgeInsets.all(12.w) : EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showDropdown) ...[
            CustomShimmerWidget(height: 50.h),
            SizedBox(height: 12.h),
          ],
          Row(
            children: [
              Expanded(child: CustomShimmerWidget(height: 60.h)),
              SizedBox(width: 8.w),
              Expanded(child: CustomShimmerWidget(height: 60.h)),
              SizedBox(width: 8.w),
              Expanded(child: CustomShimmerWidget(height: 60.h)),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.bgSecondary,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomShimmerWidget(height: 14.h, width: 40.w),
                    CustomShimmerWidget(height: 14.h, width: 80.w),
                  ],
                ),
                SizedBox(height: 10.h),
                CustomShimmerWidget(height: 4.h),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomShimmerWidget(height: 10.h, width: 120.w),
                    CustomShimmerWidget(height: 10.h, width: 80.w),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.bgSecondary,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: List.generate(5, (i) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.h),
                  child: Row(
                    children: [
                      CustomShimmerWidget(height: 20.h, width: 20.w),
                      SizedBox(width: 10.w),
                      Expanded(child: CustomShimmerWidget(height: 14.h)),
                      SizedBox(width: 10.w),
                      CustomShimmerWidget(height: 14.h, width: 60.w),
                      SizedBox(width: 10.w),
                      CustomShimmerWidget(height: 20.h, width: 50.w),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
