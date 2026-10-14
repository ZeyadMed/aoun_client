import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:aoun_client/core/theme/app_colors.dart';
import 'package:aoun_client/core/theme/app_text_theme.dart';
import 'package:aoun_client/feature/main/contracts/data/model/contract_model.dart';
import 'package:aoun_client/feature/main/contracts/presentation/screens/contracts_screen.dart';
import 'package:aoun_client/feature/main/contracts/presentation/widget/stack_box.dart';

class ContractCards extends StatelessWidget {
  final ContractModel contract;
  const ContractCards({super.key, required this.contract});

  String _formatNumber(num value) => value
      .toStringAsFixed(value.truncateToDouble() == value ? 0 : 2)
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');

  String _formatStartDate() {
    final d = contract.purchaseDate;
    if (d == null) return '';
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

  String _statusKey() {
    switch (contract.status) {
      case ContractStatus.active:
        return 'active';
      case ContractStatus.late:
        return 'late';
      case ContractStatus.ended:
        return 'ended';
    }
  }

  @override
  Widget build(BuildContext context) {
    final barColor = contract.isLate
        ? AppColors.error
        : contract.isEnded
        ? AppColors.textHint
        : AppColors.mainAppColor;
    final statusColor = contract.isLate ? AppColors.error : AppColors.success;
    final statusBg = contract.isLate
        ? AppColors.errorLight
        : AppColors.successLight;
    final statusLabel = 'contracts.${_statusKey()}'.tr();

    return GestureDetector(
      onTap: () => context.push('/contracts/${contract.id}', extra: contract),
      child: Card(
        margin: EdgeInsets.only(bottom: 10.h),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contract.productName,
                        style: AppTextTheme.labelLarge,
                      ),
                      Text(
                        '${contract.contractNo} · ${'contracts.started'.tr()} ${_formatStartDate()}',
                        style: AppTextTheme.caption,
                      ),
                    ],
                  ),
                  StatusBadge(
                    label: statusLabel,
                    fg: statusColor,
                    bg: statusBg,
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  StatBox(
                    label: 'contracts.total'.tr(),
                    value: '${_formatNumber(contract.totalContractAmount)} ج.م',
                    color: AppColors.mainAppColor,
                    bg: AppColors.mainLight,
                  ),
                  SizedBox(width: 6.w),
                  StatBox(
                    label: 'contracts.paid'.tr(),
                    value: '${_formatNumber(contract.totalPaid)} ج.م',
                    color: AppColors.success,
                    bg: AppColors.successLight,
                  ),
                  SizedBox(width: 6.w),
                  StatBox(
                    label: 'contracts.remain'.tr(),
                    value: '${_formatNumber(contract.remainingAmount)} ج.م',
                    color: contract.isLate
                        ? AppColors.error
                        : AppColors.warning,
                    bg: contract.isLate
                        ? AppColors.errorLight
                        : AppColors.warningLight,
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: LinearProgressIndicator(
                  value: contract.progressPct,
                  backgroundColor: AppColors.bgTertiary,
                  valueColor: AlwaysStoppedAnimation(barColor),
                  minHeight: 4.h,
                ),
              ),
              SizedBox(height: 6.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${'contracts.progress'.tr()}: ${contract.paidInstallments}/${contract.installmentsCount}',
                      style: AppTextTheme.caption,
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
