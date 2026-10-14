import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aoun_client/core/widgets/widgets.dart';

class InstallmentsShimmer extends StatelessWidget {
  final int itemCount;
  const InstallmentsShimmer({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(
        itemCount,
        (_) => Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: Row(
            children: [
              CustomShimmerWidget(height: 14.h, width: 80.w),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomShimmerWidget(height: 12.h, width: 90.w),
                  SizedBox(height: 4.h),
                  CustomShimmerWidget(height: 10.h, width: 60.w),
                ],
              ),
              SizedBox(width: 8.w),
              CustomShimmerWidget(height: 22.h, width: 22.w),
            ],
          ),
        ),
      ),
    );
  }
}
