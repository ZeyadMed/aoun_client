part of 'widgets.dart';

class CartItemTile extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CartItemTile({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  String _format(num value) => value
      .toStringAsFixed(value.truncateToDouble() == value ? 0 : 2)
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CartItemThumbnail(imageUrl: item.imageUrl),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _CartItemHeader(
                  productName: item.productName,
                  onEdit: onEdit,
                  onDelete: onDelete,
                ),
                SizedBox(height: 4.h),
                _CartItemMeta(
                  isInstallment: item.isInstallment,
                  installmentMonths: item.installmentMonths,
                  quantity: item.quantity,
                ),
                SizedBox(height: 6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_format(item.unitPrice)} ج.م',
                      style: AppTextTheme.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10.sp,
                      ),
                    ),
                    Text(
                      '${_format(item.lineTotal)} ج.م',
                      style: AppTextTheme.h3.copyWith(
                        color: AppColors.mainAppColor,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
                if (item.isInstallment &&
                    item.monthlyInstallment != null &&
                    item.installmentMonths != null) ...[
                  SizedBox(height: 4.h),
                  _InstallmentBreakdown(
                    downPayment: item.downPayment,
                    monthlyInstallment: item.monthlyInstallment!,
                    format: _format,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItemThumbnail extends StatelessWidget {
  final String? imageUrl;
  const _CartItemThumbnail({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: SizedBox(
        width: 70.w,
        height: 70.h,
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(
                  color: AppColors.bgTertiary,
                  child: Center(
                    child: SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.mainAppColor.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
                errorWidget: (_, _, _) => _ThumbnailPlaceholder(),
              )
            : _ThumbnailPlaceholder(),
      ),
    );
  }
}

class _ThumbnailPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgTertiary,
      child: Icon(
        Icons.image_outlined,
        color: AppColors.mainAppColor.withValues(alpha: 0.4),
        size: 28.sp,
      ),
    );
  }
}

class _CartItemHeader extends StatelessWidget {
  final String productName;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CartItemHeader({
    required this.productName,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ActionIcon(
          icon: Icons.delete_outline_rounded,
          color: AppColors.error,
          onTap: onDelete,
        ),
        SizedBox(width: 6.w),
        _ActionIcon(
          icon: Icons.edit_outlined,
          color: AppColors.mainAppColor,
          onTap: onEdit,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            productName,
            style: AppTextTheme.h4.copyWith(
              fontSize: 13.sp,
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionIcon({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, color: color, size: 16.sp),
      ),
    );
  }
}

class _CartItemMeta extends StatelessWidget {
  final bool isInstallment;
  final int? installmentMonths;
  final int quantity;

  const _CartItemMeta({
    required this.isInstallment,
    required this.installmentMonths,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: isInstallment
                ? AppColors.accentTeal.withValues(alpha: 0.12)
                : AppColors.mainLight.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Text(
            isInstallment
                ? 'تقسيط ${installmentMonths ?? 0} شهر'
                : 'كاش',
            style: AppTextTheme.captionBold.copyWith(
              color: isInstallment
                  ? AppColors.accentTeal
                  : AppColors.mainAppColor,
              fontSize: 9.sp,
            ),
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          'الكمية: $quantity',
          style: AppTextTheme.caption.copyWith(
            color: AppColors.textSecondary,
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }
}

class _InstallmentBreakdown extends StatelessWidget {
  final num? downPayment;
  final num monthlyInstallment;
  final String Function(num) format;

  const _InstallmentBreakdown({
    required this.downPayment,
    required this.monthlyInstallment,
    required this.format,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.mainLight.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (downPayment != null)
            Text(
              'مقدم: ${format(downPayment!)}',
              style: AppTextTheme.caption.copyWith(
                color: AppColors.textSecondary,
                fontSize: 9.sp,
              ),
            )
          else
            const SizedBox.shrink(),
          Text(
            '${format(monthlyInstallment)} / شهر',
            style: AppTextTheme.captionBold.copyWith(
              color: AppColors.mainAppColor,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}
