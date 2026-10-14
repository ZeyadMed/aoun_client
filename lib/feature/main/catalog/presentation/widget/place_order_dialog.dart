part of 'widgets.dart';

class PlaceOrderDialog extends StatefulWidget {
  final void Function(CreateOrderModel) onConfirm;

  const PlaceOrderDialog({super.key, required this.onConfirm});

  static Future<void> show({
    required BuildContext context,
    required void Function(CreateOrderModel) onConfirm,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => PlaceOrderDialog(onConfirm: onConfirm),
    );
  }

  @override
  State<PlaceOrderDialog> createState() => _PlaceOrderDialogState();
}

class _PlaceOrderDialogState extends State<PlaceOrderDialog> {
  final _formKey = GlobalKey<FormState>();
  final _notesCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _notesCtrl.dispose();
    _addressCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedDate == null) return;
    Navigator.pop(context);
    widget.onConfirm(
      CreateOrderModel(
        notes: _notesCtrl.text.trim(),
        deliveryAddress: _addressCtrl.text.trim(),
        preferredDeliveryDate: _selectedDate!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 18.h),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      color: AppColors.mainAppColor.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.receipt_long_rounded,
                      color: AppColors.mainAppColor,
                      size: 28.sp,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'تأكيد الطلبية',
                  textAlign: TextAlign.center,
                  style: AppTextTheme.h3.copyWith(
                    fontSize: 17.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'املأ بيانات التوصيل لإتمام الطلب',
                  textAlign: TextAlign.center,
                  style: AppTextTheme.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 18.h),
                _FieldLabel(label: 'عنوان التوصيل'),
                Customtextfield(
                  hintText: 'أدخل العنوان كامل',
                  textEditingController: _addressCtrl,
                  prefix: Icon(
                    Icons.location_on_outlined,
                    color: AppColors.textHint,
                    size: 18.sp,
                  ),
                  borderRadious: 12.r,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'العنوان مطلوب';
                    }
                    if (v.trim().length < 5) {
                      return 'العنوان يجب ألا يقل عن 5 أحرف';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12.h),
                _FieldLabel(label: 'تاريخ التوصيل المفضل'),
                Customtextfield(
                  hintText: 'اختر التاريخ',
                  textEditingController: _dateCtrl,
                  prefix: Icon(
                    Icons.calendar_today_rounded,
                    color: AppColors.textHint,
                    size: 18.sp,
                  ),
                  borderRadious: 12.r,
                  onDateSelected: (date) =>
                      setState(() => _selectedDate = date),
                  validator: (v) {
                    if (_selectedDate == null) return 'التاريخ مطلوب';
                    if (_selectedDate!.isBefore(
                      DateTime.now().subtract(const Duration(days: 1)),
                    )) {
                      return 'التاريخ يجب أن يكون اليوم أو بعده';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12.h),
                _FieldLabel(label: 'ملاحظات (اختياري)'),
                Customtextfield(
                  hintText: 'أي ملاحظات إضافية...',
                  textEditingController: _notesCtrl,
                  prefix: Icon(
                    Icons.note_alt_outlined,
                    color: AppColors.textHint,
                    size: 18.sp,
                  ),
                  borderRadious: 12.r,
                  maxLines: 3,
                  minLines: 2,
                ),
                SizedBox(height: 22.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.border),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          'إلغاء',
                          style: AppTextTheme.labelMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainAppColor,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          'تأكيد',
                          style: AppTextTheme.labelMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
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
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h, right: 4.w),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          label,
          style: AppTextTheme.labelSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
