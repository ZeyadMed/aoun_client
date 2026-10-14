part of 'widgets.dart';

class ProductsShimmer extends StatelessWidget {
  final int itemCount;
  const ProductsShimmer({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10.h,
        crossAxisSpacing: 10.w,
        mainAxisExtent: 360.h,
      ),
      itemBuilder: (_, _) => Container(
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomShimmerWidget(height: 130.h, width: double.infinity),
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomShimmerWidget(height: 12.h, width: double.infinity),
                  SizedBox(height: 4.h),
                  CustomShimmerWidget(height: 9.h, width: 80.w),
                  SizedBox(height: 6.h),
                  CustomShimmerWidget(height: 22.h, width: double.infinity),
                  SizedBox(height: 6.h),
                  CustomShimmerWidget(height: 70.h, width: double.infinity),
                  SizedBox(height: 8.h),
                  CustomShimmerWidget(height: 30.h, width: double.infinity),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
