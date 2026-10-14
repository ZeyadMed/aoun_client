import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:aoun_client/core/theme/app_colors.dart';
import 'package:aoun_client/core/theme/app_text_theme.dart';
import 'package:aoun_client/feature/main/statement/data/model/statement_model.dart';

class StatementBody extends StatelessWidget {
  final StatementModel statement;
  const StatementBody({super.key, required this.statement});

  String _formatNumber(num value) => value
      .toStringAsFixed(value.truncateToDouble() == value ? 0 : 2)
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');

  String _formatDate(DateTime? d) {
    if (d == null) return '—';
    const months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    final m = months[(d.month - 1).clamp(0, 11)];
    return '${d.day} $m ${d.year}';
  }

  Color _progressColor(num percent, {required bool isLate}) {
    if (isLate) return AppColors.error;
    final pct = percent.round();
    if (pct >= 100) return const Color(0xff22C55E);
    if (pct >= 50) return const Color(0xff86EFAC);
    if (pct > 0) return const Color(0xffF59F00);
    return const Color(0xffEF4444);
  }

  @override
  Widget build(BuildContext context) {
    final c = statement;
    final isLate = c.isLate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _Stat(
              'statement.total'.tr(),
              '${_formatNumber(c.totalContractAmount)} ج.م',
              AppColors.mainAppColor,
              AppColors.mainLight,
            ),
            SizedBox(width: 8.w),
            _Stat(
              'statement.paid'.tr(),
              '${_formatNumber(c.totalPaid)} ج.م',
              AppColors.success,
              AppColors.successLight,
            ),
            SizedBox(width: 8.w),
            _Stat(
              'statement.remain'.tr(),
              '${_formatNumber(c.remainingAmount)} ج.م',
              isLate ? AppColors.error : AppColors.warning,
              isLate ? AppColors.errorLight : AppColors.warningLight,
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Card(
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Builder(
                  builder: (_) {
                    final progressColor = _progressColor(
                      c.progress.percent,
                      isLate: isLate,
                    );
                    final percentInt = c.progress.percent.round();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${c.progress.paidInstallmentsCount}/${c.progress.totalInstallmentsCount} ${'statement.progress'.tr()}',
                              style: AppTextTheme.bodySmall,
                            ),
                            Text(
                              '$percentInt%',
                              style: AppTextTheme.labelMedium.copyWith(
                                color: progressColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.r),
                          child: LinearProgressIndicator(
                            value: percentInt == 0 ? 1.0 : c.progress.pct,
                            backgroundColor: progressColor.withValues(
                              alpha: 0.25,
                            ),
                            valueColor: AlwaysStoppedAnimation(progressColor),
                            minHeight: 6.h,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                if (c.nextInstallment != null) ...[
                  SizedBox(height: 6.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${'statement.next_installment'.tr()}: ${_formatNumber(c.nextInstallment!.amount)} ج.م',
                        style: AppTextTheme.caption,
                      ),
                      Text(
                        _formatDate(c.nextInstallment!.dueDate),
                        style: AppTextTheme.caption,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
        if (isLate) ...[
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.errorLight,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.error,
                  size: 16.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'statement.late_alert'.tr(
                      namedArgs: {'amount': _formatNumber(c.remainingAmount)},
                    ),
                    style: AppTextTheme.labelSmall.copyWith(
                      color: AppColors.error,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ],
        SizedBox(height: 10.h),
        _ScheduleTable(statement: c, formatNumber: _formatNumber),
        SizedBox(height: 12.h),
        // SizedBox(
        //   height: 50.h,
        //   width: double.infinity,
        //   child: ElevatedButton.icon(
        //     onPressed: () {},
        //     icon: const Icon(Icons.message, size: 18),
        //     label: Text(
        //       'statement.whatsapp_request'.tr(),
        //       style: AppTextTheme.button,
        //     ),
        //     style: ElevatedButton.styleFrom(
        //       backgroundColor: AppColors.whatsapp,
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(12.r),
        //       ),
        //     ),
        //   ),
        // ),
        SizedBox(height: 8.h),
        // ElevatedButton(
        //   onPressed: () => context.go('/payment?contract=${c.contractId}'),
        //   style: ElevatedButton.styleFrom(
        //     minimumSize: Size(double.infinity, 50.h),
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(14.r),
        //     ),
        //   ),
        //   child: Text('contracts.pay_next'.tr(), style: AppTextTheme.button),
        // ),
      ],
    );
  }
}

class _ScheduleTable extends StatelessWidget {
  final StatementModel statement;
  final String Function(num) formatNumber;
  const _ScheduleTable({required this.statement, required this.formatNumber});

  (Color, Color, String) _statusStyle(StatementInstallmentStatus s) {
    switch (s) {
      case StatementInstallmentStatus.paid:
        return (
          AppColors.success,
          AppColors.successLight,
          'statement.paid_status'.tr(),
        );
      case StatementInstallmentStatus.partial:
        return (
          AppColors.warning,
          AppColors.warningLight,
          'statement.partial_status'.tr(),
        );
      case StatementInstallmentStatus.late:
        return (
          AppColors.error,
          AppColors.errorLight,
          'statement.late_status'.tr(),
        );
      case StatementInstallmentStatus.upcoming:
        return (
          AppColors.mainAppColor,
          AppColors.mainLight,
          'statement.upcoming_status'.tr(),
        );
    }
  }

  Widget _legend(Color c, String label) => Row(
    children: [
      Container(
        width: 8.w,
        height: 8.h,
        decoration: BoxDecoration(
          color: c.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: c),
        ),
      ),
      SizedBox(width: 4.w),
      Text(
        label,
        style: AppTextTheme.caption.copyWith(
          color: c,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );

  String _shortDate(DateTime? d) {
    if (d == null) return '—';
    const months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return '${d.day} ${months[(d.month - 1).clamp(0, 11)]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    if (statement.installments.isEmpty) return const SizedBox.shrink();

    final totalDue = statement.installments.fold<num>(
      0,
      (s, r) => s + r.amount,
    );
    final totalPaid = statement.installments.fold<num>(
      0,
      (s, r) => s + r.paidAmount,
    );
    final totalRemain = statement.installments.fold<num>(
      0,
      (s, r) => s + r.remaining,
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('statement.schedule_title'.tr(), style: AppTextTheme.h4),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 4.h,
                  children: [
                    _legend(AppColors.success, 'statement.paid_status'.tr()),
                    _legend(AppColors.warning, 'statement.partial_status'.tr()),
                    _legend(AppColors.error, 'statement.late_status'.tr()),
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 1.h, color: AppColors.border),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            itemCount: statement.installments.length,
            separatorBuilder: (_, _) => SizedBox(height: 8.h),
            itemBuilder: (_, i) => _InstallmentTile(
              row: statement.installments[i],
              formatNumber: formatNumber,
              statusStyle: _statusStyle,
              shortDate: _shortDate,
            ),
          ),
          Divider(height: 1.h, color: AppColors.border),
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'statement.totals'.tr(),
                      style: AppTextTheme.labelLarge,
                    ),
                    Text(
                      '${formatNumber(totalDue)} ج.م',
                      style: AppTextTheme.labelMedium.copyWith(
                        color: AppColors.mainAppColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('statement.paid'.tr(), style: AppTextTheme.caption),
                    Text(
                      '${formatNumber(totalPaid)} ج.م',
                      style: AppTextTheme.labelSmall.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('statement.remain'.tr(), style: AppTextTheme.caption),
                    Text(
                      '${formatNumber(totalRemain)} ج.م',
                      style: AppTextTheme.labelSmall.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InstallmentTile extends StatelessWidget {
  final StatementInstallment row;
  final String Function(num) formatNumber;
  final (Color, Color, String) Function(StatementInstallmentStatus) statusStyle;
  final String Function(DateTime?) shortDate;

  const _InstallmentTile({
    required this.row,
    required this.formatNumber,
    required this.statusStyle,
    required this.shortDate,
  });

  @override
  Widget build(BuildContext context) {
    final st = statusStyle(row.statusEnum);
    final remainColor = row.remaining == 0
        ? AppColors.success
        : row.statusEnum == StatementInstallmentStatus.late
        ? AppColors.error
        : AppColors.warning;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.h,
                decoration: BoxDecoration(
                  color: st.$2,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Text(
                    '${row.sequence}',
                    style: AppTextTheme.labelMedium.copyWith(
                      color: st.$1,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shortDate(row.dueDate),
                      style: AppTextTheme.labelMedium,
                    ),
                    if (row.paidDate != null)
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Text(
                          '${'statement.paid_status'.tr()}: ${shortDate(row.paidDate)}',
                          style: AppTextTheme.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: st.$2,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  st.$3,
                  style: AppTextTheme.captionBold.copyWith(color: st.$1),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  label: 'statement.col_due'.tr(),
                  value: '${formatNumber(row.amount)} ج.م',
                  color: AppColors.textPrimary,
                ),
              ),
              Container(width: 1, height: 28.h, color: AppColors.border),
              Expanded(
                child: _MiniStat(
                  label: 'statement.col_paid'.tr(),
                  value: '${formatNumber(row.paidAmount)} ج.م',
                  color: AppColors.success,
                ),
              ),
              Container(width: 1, height: 28.h, color: AppColors.border),
              Expanded(
                child: _MiniStat(
                  label: 'statement.col_remain'.tr(),
                  value: '${formatNumber(row.remaining)} ج.م',
                  color: remainColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextTheme.caption.copyWith(color: AppColors.textSecondary),
        ),
        SizedBox(height: 2.h),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: AppTextTheme.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  final String label, value;
  final Color color, bg;
  const _Stat(this.label, this.value, this.color, this.bg);

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          Text(value, style: AppTextTheme.labelMedium.copyWith(color: color)),
          SizedBox(height: 2.h),
          Text(label, style: AppTextTheme.caption),
        ],
      ),
    ),
  );
}
