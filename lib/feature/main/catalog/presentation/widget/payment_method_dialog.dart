part of 'widgets.dart';

class PaymentMethodDialog extends StatefulWidget {
  final int productId;
  final int initialQuantity;
  final int maxQuantity;
  final OrderPaymentMethod initialPaymentMethod;
  final int initialInstallmentMonths;
  final String? title;
  final Function(OrderPaymentMethod, int, int) onConfirm;

  const PaymentMethodDialog({
    super.key,
    required this.productId,
    this.initialQuantity = 1,
    required this.maxQuantity,
    this.initialPaymentMethod = OrderPaymentMethod.cash,
    this.initialInstallmentMonths = 6,
    this.title,
    required this.onConfirm,
  });

  @override
  State<PaymentMethodDialog> createState() => _PaymentMethodDialogState();
}

class _PaymentMethodDialogState extends State<PaymentMethodDialog> {
  late OrderPaymentMethod _selectedMethod;
  late int _selectedMonths;
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity.clamp(1, widget.maxQuantity);
    _selectedMethod = widget.initialPaymentMethod;
    _selectedMonths = widget.initialInstallmentMonths > 0
        ? widget.initialInstallmentMonths
        : 6;
  }

  void _increment() {
    if (_quantity < widget.maxQuantity) {
      setState(() => _quantity++);
    }
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() => _quantity--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                widget.title ?? 'طريقة الدفع',
                style: AppTextTheme.h4.copyWith(fontSize: 16.sp),
              ),
              SizedBox(height: 16.h),
              // Quantity selector
              Text(
                'الكمية',
                style: AppTextTheme.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border, width: 1.5),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _QtyButton(
                      icon: Icons.remove_rounded,
                      enabled: _quantity > 1,
                      onTap: _decrement,
                    ),
                    Text(
                      '$_quantity',
                      style: AppTextTheme.h4.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 16.sp,
                      ),
                    ),
                    _QtyButton(
                      icon: Icons.add_rounded,
                      enabled: _quantity < widget.maxQuantity,
                      onTap: _increment,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              // Cash Option
              GestureDetector(
                onTap: () {
                  setState(() => _selectedMethod = OrderPaymentMethod.cash);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _selectedMethod == OrderPaymentMethod.cash
                          ? AppColors.mainAppColor
                          : AppColors.border,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                    color: _selectedMethod == OrderPaymentMethod.cash
                        ? AppColors.mainAppColor.withValues(alpha: 0.05)
                        : Colors.transparent,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(width: 8.w),
                      Radio<OrderPaymentMethod>(
                        value: OrderPaymentMethod.cash,
                        groupValue: _selectedMethod,
                        onChanged: (value) {
                          setState(
                            () => _selectedMethod =
                                value ?? OrderPaymentMethod.cash,
                          );
                        },
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'دفع كاش',
                        style: AppTextTheme.labelSmall.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              // Installment Option
              GestureDetector(
                onTap: () {
                  setState(
                    () => _selectedMethod = OrderPaymentMethod.installment,
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _selectedMethod == OrderPaymentMethod.installment
                          ? AppColors.mainAppColor
                          : AppColors.border,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                    color: _selectedMethod == OrderPaymentMethod.installment
                        ? AppColors.mainAppColor.withValues(alpha: 0.05)
                        : Colors.transparent,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(width: 8.w),
                      Radio<OrderPaymentMethod>(
                        value: OrderPaymentMethod.installment,
                        groupValue: _selectedMethod,
                        onChanged: (value) {
                          setState(
                            () => _selectedMethod =
                                value ?? OrderPaymentMethod.installment,
                          );
                        },
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'تقسيط',
                        style: AppTextTheme.labelSmall.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_selectedMethod == OrderPaymentMethod.installment) ...[
                SizedBox(height: 16.h),
                Text(
                  'عدد الأقساط',
                  style: AppTextTheme.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _InstallmentOption(
                      label: '12 شهر',
                      isSelected: _selectedMonths == 12,
                      onTap: () => setState(() => _selectedMonths = 12),
                    ),
                    SizedBox(width: 8.w),
                    _InstallmentOption(
                      label: '6 أشهر',
                      isSelected: _selectedMonths == 6,
                      onTap: () => setState(() => _selectedMonths = 6),
                    ),
                  ],
                ),
              ],
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 40.h,
                    width: 120.w,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.bgTertiary,
                      ),
                      child: Text(
                        'إلغاء',
                        style: AppTextTheme.labelSmall.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                    width: 120.w,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        final months =
                            _selectedMethod == OrderPaymentMethod.cash
                            ? 0
                            : _selectedMonths;
                        widget.onConfirm(_selectedMethod, months, _quantity);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainAppColor,
                      ),
                      child: Text(
                        'تأكيد',
                        style: AppTextTheme.labelSmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _QtyButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        width: 36.w,
        height: 32.h,
        decoration: BoxDecoration(
          color: enabled
              ? AppColors.mainAppColor
              : AppColors.mainAppColor.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, color: Colors.white, size: 18.sp),
      ),
    );
  }
}

class _InstallmentOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _InstallmentOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.mainAppColor : AppColors.bgTertiary,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          label,
          style: AppTextTheme.labelSmall.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
