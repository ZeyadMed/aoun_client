part of 'widgets.dart';

class CartEmptyState extends StatelessWidget {
  const CartEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: AppColors.bgTertiary,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              color: AppColors.mainAppColor,
              size: 36.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'السله فارغه',
            style: AppTextTheme.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
