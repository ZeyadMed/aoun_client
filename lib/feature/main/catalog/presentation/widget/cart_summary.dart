part of 'widgets.dart';

class CartSummary extends StatelessWidget {
  final CartModel cart;
  final VoidCallback onCompleteOrder;

  const CartSummary({
    super.key,
    required this.cart,
    required this.onCompleteOrder,
  });

  String _format(num value) => value
      .toStringAsFixed(value.truncateToDouble() == value ? 0 : 2)
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _SummaryRow(
            label: 'عدد المنتجات',
            value: '${cart.totalItems}',
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 6.h),
          _SummaryRow(
            label: 'الإجمالي',
            value: '${_format(cart.totalAmount)} ج.م',
            isBold: true,
            color: AppColors.mainAppColor,
          ),
          if (cart.totalDownPayment > 0) ...[
            SizedBox(height: 6.h),
            _SummaryRow(
              label: 'إجمالي المقدم',
              value: '${_format(cart.totalDownPayment)} ج.م',
              color: AppColors.textSecondary,
            ),
          ],
          if (cart.totalMonthlyInstallment > 0) ...[
            SizedBox(height: 6.h),
            _SummaryRow(
              label: 'القسط الشهري',
              value: '${_format(cart.totalMonthlyInstallment)} ج.م',
              color: AppColors.accentTeal,
            ),
          ],
          SizedBox(height: 14.h),
          ElevatedButton(
            onPressed: onCompleteOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainAppColor,
              minimumSize: Size(double.infinity, 50.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            child: Text(
              'تأكيد الطلبية',
              style: AppTextTheme.button.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.color,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          style: (isBold ? AppTextTheme.h3 : AppTextTheme.labelMedium).copyWith(
            color: color ?? AppColors.textPrimary,
            fontSize: isBold ? 15.sp : 12.sp,
          ),
        ),
        Text(
          label,
          style: AppTextTheme.labelSmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
