part of 'widgets.dart';

class ProductCard extends StatelessWidget {
  final GetProductModel item;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const ProductCard({
    super.key,
    required this.item,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  bool get inCart => quantity > 0;

  String? _resolveImage() {
    final path = item.imageUrl;
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http')) return path;
    final base = Endpoints.baseUrl.endsWith('/')
        ? Endpoints.baseUrl.substring(0, Endpoints.baseUrl.length - 1)
        : Endpoints.baseUrl;
    return path.startsWith('/') ? '$base$path' : '$base/$path';
  }

  String _formatNumber(num value) => value
      .toStringAsFixed(value.truncateToDouble() == value ? 0 : 2)
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');

  @override
  Widget build(BuildContext context) {
    final imageUrl = _resolveImage();
    final stock = item.availableQuantity;
    final isOut = stock <= 0;
    final isLow = stock > 0 && stock <= 2;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: inCart
              ? AppColors.mainAppColor
              : AppColors.border.withValues(alpha: 0.6),
          width: inCart ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ProductImage(
            imageUrl: imageUrl,
            stockBadge: _StockBadge(isOut: isOut, isLow: isLow, stock: stock),
            profitRatePercent: item.profitRatePercent,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.name,
                  style: AppTextTheme.h4.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.description.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    item.description,
                    style: AppTextTheme.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 9.sp,
                      height: 1.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                SizedBox(height: 6.h),
                _PriceTag(price: _formatNumber(item.cashPrice)),
                if (item.installmentPlans.isNotEmpty) ...[
                  SizedBox(height: 6.h),
                  _InstallmentPlans(plans: item.installmentPlans),
                ],
                SizedBox(height: 8.h),
                SizedBox(
                  height: 30.h,
                  width: double.infinity,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    transitionBuilder: (child, anim) =>
                        ScaleTransition(scale: anim, child: child),
                    child: isOut
                        ? _DisabledButton(key: const ValueKey('out'))
                        : inCart
                            ? _QuantitySelector(
                                key: const ValueKey('qty'),
                                quantity: quantity,
                                maxQuantity: stock,
                                onIncrement: onIncrement,
                                onDecrement: onDecrement,
                              )
                            : _AddToCartButton(
                                key: const ValueKey('add'),
                                onTap: onIncrement,
                              ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddToCartButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddToCartButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(
        Icons.add_shopping_cart_rounded,
        size: 13.sp,
        color: Colors.white,
      ),
      label: Text(
        'catalog.add_to_cart'.tr(),
        style: AppTextTheme.captionBold.copyWith(
          color: Colors.white,
          fontSize: 11.sp,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.mainAppColor,
        elevation: 2,
        shadowColor: AppColors.mainAppColor.withValues(alpha: 0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class _DisabledButton extends StatelessWidget {
  const _DisabledButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: null,
      style: ElevatedButton.styleFrom(
        disabledBackgroundColor: AppColors.textHint.withValues(alpha: 0.35),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: EdgeInsets.zero,
      ),
      child: Text(
        'غير متوفر',
        style: AppTextTheme.captionBold.copyWith(
          color: Colors.white,
          fontSize: 11.sp,
        ),
      ),
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  final int quantity;
  final int maxQuantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _QuantitySelector({
    super.key,
    required this.quantity,
    required this.maxQuantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final canIncrement = quantity < maxQuantity;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.mainAppColor,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.mainAppColor.withValues(alpha: 0.35),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _QtyIconButton(
            icon: Icons.remove_rounded,
            onTap: onDecrement,
          ),
          Text(
            '$quantity',
            style: AppTextTheme.h4.copyWith(
              color: Colors.white,
              fontSize: 13.sp,
            ),
          ),
          _QtyIconButton(
            icon: Icons.add_rounded,
            onTap: canIncrement ? onIncrement : null,
            disabled: !canIncrement,
          ),
        ],
      ),
    );
  }
}

class _QtyIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool disabled;

  const _QtyIconButton({
    required this.icon,
    required this.onTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: SizedBox(
        width: 36.w,
        height: 30.h,
        child: Icon(
          icon,
          color: disabled ? Colors.white38 : Colors.white,
          size: 18.sp,
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String? imageUrl;
  final Widget stockBadge;
  final num profitRatePercent;

  const _ProductImage({
    required this.imageUrl,
    required this.stockBadge,
    required this.profitRatePercent,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14.r),
            topRight: Radius.circular(14.r),
          ),
          child: Container(
            width: double.infinity,
            height: 130.h,

            decoration: BoxDecoration(
              color: Colors.white,
       
            ),
            padding: EdgeInsets.all(8.w),
            child: imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.contain,
                    placeholder: (_, _) => Center(
                      child: SizedBox(
                        width: 22.w,
                        height: 22.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.mainAppColor.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    errorWidget: (_, _, _) => _PlaceholderIcon(),
                  )
                : _PlaceholderIcon(),
          ),
        ),
        Positioned(top: 6.h, right: 6.w, child: stockBadge),
        if (profitRatePercent > 0)
          Positioned(
            top: 6.h,
            left: 6.w,
            child: _Badge(
              label: 'ربح ${profitRatePercent.toStringAsFixed(0)}%',
              color: Colors.white,
              background: AppColors.accentTeal,
            ),
          ),
      ],
    );
  }
}

class _PlaceholderIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.image_outlined,
        size: 38.sp,
        color: AppColors.mainAppColor.withValues(alpha: 0.35),
      ),
    );
  }
}

class _PriceTag extends StatelessWidget {
  final String price;
  const _PriceTag({required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.mainAppColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'نقداً',
            style: AppTextTheme.caption.copyWith(
              color: AppColors.textSecondary,
              fontSize: 9.sp,
            ),
          ),
          Text(
            '$price ج.م',
            style: AppTextTheme.h3.copyWith(
              color: AppColors.mainAppColor,
              fontSize: 13.sp,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _StockBadge extends StatelessWidget {
  final bool isOut;
  final bool isLow;
  final int stock;

  const _StockBadge({
    required this.isOut,
    required this.isLow,
    required this.stock,
  });

  @override
  Widget build(BuildContext context) {
    final (bg, fg, label) = isOut
        ? (AppColors.error, Colors.white, 'نفذت')
        : isLow
        ? (AppColors.warning, Colors.white, '$stock فقط')
        : (AppColors.success, Colors.white, '$stock متاح');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: bg.withValues(alpha: 0.4),
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        label,
        style: AppTextTheme.caption.copyWith(
          color: fg,
          fontWeight: FontWeight.w800,
          fontSize: 8.sp,
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final Color background;

  const _Badge({
    required this.label,
    required this.color,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: AppTextTheme.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 8.sp,
        ),
      ),
    );
  }
}

class _InstallmentPlans extends StatelessWidget {
  final List<InstallmentPlanModel> plans;
  const _InstallmentPlans({required this.plans});

  String _format(num value) => value
      .toStringAsFixed(value.truncateToDouble() == value ? 0 : 2)
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');

  @override
  Widget build(BuildContext context) {
    final firstDown = plans.first.downPayment;
    final allSameDown = plans.every((p) => p.downPayment == firstDown);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppColors.mainLight.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.mainAppColor.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (allSameDown)
                Text(
                  'مقدم ${_format(firstDown)}',
                  style: AppTextTheme.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 8.sp,
                  ),
                )
              else
                const SizedBox.shrink(),
              Row(
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    size: 10.sp,
                    color: AppColors.mainAppColor,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'تقسيط',
                    style: AppTextTheme.captionBold.copyWith(
                      color: AppColors.mainAppColor,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 4.h),
          ...List.generate(plans.length, (i) {
            final p = plans[i];
            return Padding(
              padding: EdgeInsets.only(bottom: i == plans.length - 1 ? 0 : 3.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              _format(p.monthlyInstallment),
                              style: AppTextTheme.h4.copyWith(
                                color: AppColors.mainAppColor,
                                fontSize: 10.sp,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            '/شهر',
                            style: AppTextTheme.caption.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 8.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.mainAppColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        '${p.months}ش',
                        style: AppTextTheme.captionBold.copyWith(
                          color: AppColors.mainAppColor,
                          fontSize: 9.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
