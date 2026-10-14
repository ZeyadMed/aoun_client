part of 'widgets.dart';

class CatalogHeader extends StatelessWidget {
  final int cartCount;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;

  const CatalogHeader({
    super.key,
    required this.cartCount,
    required this.searchController,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.mainAppColor,
            AppColors.mainAppColor.withValues(alpha: 0.92),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        16.w,
        MediaQuery.of(context).padding.top + 12.h,
        16.w,
        16.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'تسوق بالأقساط',
                style: AppTextTheme.h3.copyWith(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              _CartIconBadge(count: cartCount),
            ],
          ),
          SizedBox(height: 12.h),
          Customtextfield(
            hintText: 'ابحث عن منتج...',
            textEditingController: searchController,
            prefix: Icon(Icons.search, color: AppColors.textHint, size: 20.sp),
            borderRadious: 14.r,
            onChanged: (value) {
              onSearchChanged(value ?? '');
              return null;
            },
          ),
        ],
      ),
    );
  }
}

class _CartIconBadge extends StatelessWidget {
  final int count;
  const _CartIconBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/catalog/cart'),
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
              size: 20.sp,
            ),
            if (count > 0)
              Positioned(
                top: -2.h,
                left: -2.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  constraints: BoxConstraints(minWidth: 18.w, minHeight: 18.w),
                  child: Text(
                    '$count',
                    textAlign: TextAlign.center,
                    style: AppTextTheme.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 9.sp,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
