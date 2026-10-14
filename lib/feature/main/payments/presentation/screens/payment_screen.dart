import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_theme.dart';

class PaymentScreen extends StatefulWidget {
  final int? contractId;
  const PaymentScreen({super.key, this.contractId});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _amtCtrl = TextEditingController(text: '400');
  int _method = 0;
  static const double _due = 800, _prevPaid = 400;
  final _methods = ['payments.mada', 'payments.transfer', 'payments.stc_pay', 'payments.cash'];
  final _methodIcons = [Icons.credit_card, Icons.account_balance, Icons.payment, Icons.money];

  double get _amount => double.tryParse(_amtCtrl.text) ?? 0;
  double get _remain => (_due - _prevPaid - _amount).clamp(0, _due);

  @override
  void dispose() { _amtCtrl.dispose(); super.dispose(); }

  void _submit() {
    context.go('/payment/success');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Column(children: [
        Container(
          color: AppColors.accentTeal,
          padding: EdgeInsets.fromLTRB(16.w, MediaQuery.of(context).padding.top + 12.h, 16.w, 14.h),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            GestureDetector(onTap: () => context.pop(), child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18.sp)),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('payments.title'.tr(), style: AppTextTheme.h3.copyWith(color: Colors.white)),
              Text('payments.partial_allowed'.tr(), style: AppTextTheme.caption.copyWith(color: Colors.white70)),
            ]),
          ]),
        ),
        Expanded(child: ListView(padding: EdgeInsets.all(12.w), children: [
          // Contract selector
          Card(child: Padding(padding: EdgeInsets.all(12.w), child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('payments.select_contract'.tr(), style: AppTextTheme.labelSmall),
            SizedBox(height: 8.h),
            DropdownButtonFormField<int>(
              initialValue: 0,
              decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h)),
              items: [
                DropdownMenuItem(value: 0, child: Text('Samsung S25 — 5/12 (800 ج.م)', style: AppTextTheme.bodySmall)),
                DropdownMenuItem(value: 1, child: Text('ثلاجة LG — 8/24 (450 ج.م)', style: AppTextTheme.bodySmall)),
              ],
              onChanged: (_) {},
            ),
            SizedBox(height: 10.h),
            Row(children: [
              _miniStat('400 ج.م', 'payments.prev_paid'.tr(), AppColors.warning, AppColors.warningLight),
              SizedBox(width: 8.w),
              _miniStat('400 ج.م', 'payments.remaining'.tr(), AppColors.error, AppColors.errorLight),
            ]),
          ]))),
          SizedBox(height: 8.h),
          // Amount input
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.bgSecondary,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.accentTeal, width: 2),
            ),
            child: Column(children: [
              Text('payments.amount_label'.tr(), style: AppTextTheme.labelSmall),
              SizedBox(height: 8.h),
              TextField(
                controller: _amtCtrl,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                onChanged: (_) => setState(() {}),
                style: AppTextTheme.display1,
                decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.zero),
              ),
              Text(
                _remain == 0 ? 'payments.will_complete'.tr() : 'payments.will_remain'.tr(namedArgs: {'amount': _remain.toStringAsFixed(0)}),
                style: AppTextTheme.caption.copyWith(color: _remain == 0 ? AppColors.accentTeal : AppColors.textHint),
              ),
            ]),
          ),
          SizedBox(height: 8.h),
          // Summary
          Card(child: Padding(padding: EdgeInsets.all(12.w), child: Column(children: [
            _sumRow('payments.due'.tr(), '800 ج.م', null),
            _sumRow('payments.prev_paid'.tr(), '400 ج.م', AppColors.success),
            _sumRow('payments.current_payment'.tr(), '${_amount.toStringAsFixed(0)} ج.م', null),
            _sumRow('payments.remaining'.tr(), '${_remain.toStringAsFixed(0)} ج.م', _remain == 0 ? AppColors.success : AppColors.error),
            Divider(color: AppColors.border, height: 8.h),
            _sumRow('payments.total_due'.tr(), '4,800 ج.م', AppColors.error, bold: true),
          ]))),
          SizedBox(height: 10.h),
          Align(alignment: Alignment.centerRight, child: Text('payments.payment_method'.tr(), style: AppTextTheme.labelMedium)),
          SizedBox(height: 8.h),
          Row(children: List.generate(_methods.length, (i) => Expanded(child: GestureDetector(
            onTap: () => setState(() => _method = i),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 3.w),
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                color: i == _method ? AppColors.mainLight : AppColors.bgSecondary,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: i == _method ? AppColors.mainAppColor : AppColors.border, width: 1.5),
              ),
              child: Column(children: [
                Icon(_methodIcons[i], size: 20.sp, color: i == _method ? AppColors.mainAppColor : AppColors.textHint),
                SizedBox(height: 4.h),
                Text(_methods[i].tr(), style: AppTextTheme.caption.copyWith(fontWeight: i == _method ? FontWeight.w700 : FontWeight.w400, color: i == _method ? AppColors.info : AppColors.textSecondary)),
              ]),
            ),
          )))),
          SizedBox(height: 12.h),
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentTeal, minimumSize: Size(double.infinity, 50.h), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r))),
            child: Text('payments.confirm_payment'.tr(), style: AppTextTheme.button),
          ),
          SizedBox(height: 80.h),
        ])),
      ]),
    );
  }

  Widget _miniStat(String val, String lbl, Color col, Color bg) => Expanded(child: Container(
    padding: EdgeInsets.all(8.w),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8.r)),
    child: Column(children: [Text(val, style: AppTextTheme.labelMedium.copyWith(color: col)), Text(lbl, style: AppTextTheme.caption)]),
  ));

  Widget _sumRow(String lbl, String val, Color? col, {bool bold = false}) => Padding(
    padding: EdgeInsets.symmetric(vertical: 5.h),
    child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(val, style: bold ? AppTextTheme.labelLarge.copyWith(color: col ?? AppColors.textPrimary) : AppTextTheme.bodySmall.copyWith(color: col ?? AppColors.textPrimary)),
        Text(lbl, style: bold ? AppTextTheme.labelMedium : AppTextTheme.bodySmall),
      ]),
      if (!bold) Divider(color: AppColors.border, height: 8.h),
    ]),
  );
}

// ─── Payment Success ──────────────────────────────────────────
class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: Padding(padding: EdgeInsets.all(22.w), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(width: 90.w, height: 90.h, decoration: const BoxDecoration(color: AppColors.tealLight, shape: BoxShape.circle), child: Icon(Icons.check_circle_outline, color: AppColors.accentTeal, size: 44.sp)),
        SizedBox(height: 18.h),
        Text('payments.success_title'.tr(), style: AppTextTheme.h1),
        SizedBox(height: 10.h),
        Text('payments.success_amount'.tr(namedArgs: {'amount': '400'}), style: AppTextTheme.bodyMedium.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
        SizedBox(height: 20.h),
        Container(padding: EdgeInsets.all(14.w), width: double.infinity, decoration: BoxDecoration(color: AppColors.bgTertiary, borderRadius: BorderRadius.circular(14.r)), child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('payments.receipt_no'.tr(), style: AppTextTheme.caption),
          SizedBox(height: 2.h),
          Text('#RCP-2025-04-0892', style: AppTextTheme.labelLarge),
          SizedBox(height: 8.h),
          Text('payments.receipt_date'.tr(), style: AppTextTheme.caption),
          SizedBox(height: 2.h),
          Text('8 أبريل 2025 — 10:24 ص', style: AppTextTheme.labelMedium),
        ])),
        SizedBox(height: 14.h),
        Container(padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h), decoration: BoxDecoration(color: AppColors.whatsappLight, borderRadius: BorderRadius.circular(12.r)), child: Row(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('payments.whatsapp_sent'.tr(), style: AppTextTheme.labelSmall.copyWith(color: const Color(0xFF1A5E32))),
            Text('+966 501234567', style: AppTextTheme.caption.copyWith(color: const Color(0xFF2E7D32))),
          ]),
          const Spacer(),
          Container(width: 36.w, height: 36.h, decoration: BoxDecoration(color: AppColors.whatsapp, borderRadius: BorderRadius.circular(10.r)), child: Icon(Icons.message, color: Colors.white, size: 18.sp)),
        ])),
        SizedBox(height: 20.h),
        ElevatedButton(
          onPressed: () => context.go('/home'),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentTeal, minimumSize: Size(double.infinity, 50.h), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r))),
          child: Text('payments.return_home'.tr(), style: AppTextTheme.button),
        ),
        SizedBox(height: 8.h),
        OutlinedButton(
          onPressed: () => context.go('/statement'),
          style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.accentTeal), minimumSize: Size(double.infinity, 50.h), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r))),
          child: Text('payments.view_statement'.tr(), style: AppTextTheme.button.copyWith(color: AppColors.accentTeal)),
        ),
      ]))),
    );
  }
}
