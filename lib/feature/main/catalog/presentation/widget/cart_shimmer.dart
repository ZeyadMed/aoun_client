part of 'widgets.dart';


class CartShimmer extends StatelessWidget {
  final int itemCount;
  const CartShimmer({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(12.w),
      itemCount: itemCount,
      separatorBuilder: (_, _) => SizedBox(height: 10.h),
      itemBuilder: (_, _) => Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            CustomShimmerWidget(height: 70.h, width: 70.w),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomShimmerWidget(height: 12.h, width: double.infinity),
                  SizedBox(height: 6.h),
                  CustomShimmerWidget(height: 10.h, width: 120.w),
                  SizedBox(height: 8.h),
                  CustomShimmerWidget(height: 14.h, width: 90.w),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
