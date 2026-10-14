import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aoun_client/core/theme/app_colors.dart';
import 'package:aoun_client/core/widgets/widgets.dart';

class ContractsShimmer extends StatelessWidget {
  final int itemCount;
  const ContractsShimmer({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(12.w),
      itemCount: itemCount,
      separatorBuilder: (_, _) => SizedBox(height: 10.h),
      itemBuilder: (_, _) => Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomShimmerWidget(height: 20.h, width: 60.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomShimmerWidget(height: 14.h, width: 140.w),
                    SizedBox(height: 4.h),
                    CustomShimmerWidget(height: 10.h, width: 100.w),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(child: CustomShimmerWidget(height: 50.h)),
                SizedBox(width: 6.w),
                Expanded(child: CustomShimmerWidget(height: 50.h)),
                SizedBox(width: 6.w),
                Expanded(child: CustomShimmerWidget(height: 50.h)),
              ],
            ),
            SizedBox(height: 10.h),
            CustomShimmerWidget(height: 4.h, width: double.infinity),
            SizedBox(height: 6.h),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: CustomShimmerWidget(height: 10.h, width: 100.w),
            ),
          ],
        ),
      ),
    );
  }
}
