import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:aoun_client/core/bloc/paginated_bloc/exports.dart';
import 'package:aoun_client/core/enum/status.dart';
import 'package:aoun_client/core/service_locator/service_locator.dart';
import 'package:aoun_client/core/theme/app_text_theme.dart';
import 'package:aoun_client/core/widgets/stateless/failure_widget.dart';
import 'package:aoun_client/feature/main/contracts/data/model/contract_installment_model.dart';
import 'package:aoun_client/feature/main/contracts/data/model/contract_model.dart';
import 'package:aoun_client/feature/main/contracts/presentation/bloc/get_contract_installments_cubit.dart';
import 'package:aoun_client/feature/main/contracts/presentation/widget/header_state.dart';
import 'package:aoun_client/feature/main/contracts/presentation/widget/installments_shimmer.dart';

import '../../../../../core/theme/app_colors.dart';
import 'contracts_screen.dart' show InfoRow;

class ContractDetailScreen extends StatelessWidget {
  final int id;
  final ContractModel? contract;
  const ContractDetailScreen({super.key, required this.id, this.contract});

  @override
  Widget build(BuildContext context) {
    if (contract == null) {
      return Scaffold(
        backgroundColor: AppColors.bgPrimary,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Text(
                'common.no_data'.tr(),
                style: AppTextTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    }
    return BlocProvider<GetContractInstallmentsCubit>(
      create: (_) => getIt<GetContractInstallmentsCubit>()..getInstallments(id),
      child: _ContractDetailView(contract: contract!),
    );
  }
}

class _ContractDetailView extends StatelessWidget {
  final ContractModel contract;
  const _ContractDetailView({required this.contract});

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
    return '${d.day} ${months[(d.month - 1).clamp(0, 11)]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final c = contract;
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Column(
        children: [
          _Header(contract: c, formatDate: _formatDate),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(12.w),
              children: [
                _DetailsCard(contract: c, formatNumber: _formatNumber),
                SizedBox(height: 10.h),
                _ScheduleCard(formatNumber: _formatNumber),
                SizedBox(height: 12.h),
                // ElevatedButton(
                //   onPressed: () => context.push('/payment?contract=${c.id}'),
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: AppColors.accentTeal,
                //     minimumSize: Size(double.infinity, 50.h),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(14.r),
                //     ),
                //   ),
                //   child: Text(
                //     'contracts.pay_next'.tr(),
                //     style: AppTextTheme.button,
                //   ),
                // ),
                // SizedBox(height: 8.h),
                // OutlinedButton(
                //   onPressed: () {},
                //   style: OutlinedButton.styleFrom(
                //     side: const BorderSide(color: AppColors.mainAppColor),
                //     minimumSize: Size(double.infinity, 50.h),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(14.r),
                //     ),
                //   ),
                //   child: Text(
                //     'contracts.request_delay'.tr(),
                //     style: AppTextTheme.button.copyWith(
                //       color: AppColors.mainAppColor,
                //     ),
                //   ),
                // ),
                SizedBox(height: 80.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final ContractModel contract;
  final String Function(DateTime?) formatDate;
  const _Header({required this.contract, required this.formatDate});

  @override
  Widget build(BuildContext context) {
    final c = contract;
    return Container(
      color: AppColors.mainAppColor,
      padding: EdgeInsets.fromLTRB(
        16.w,
        MediaQuery.of(context).padding.top + 12.h,
        16.w,
        16.h,
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 50),

              Text(
                c.productName,
                style: AppTextTheme.h3.copyWith(color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          Row(
            children: [
              HeaderStat(
                c.totalContractAmount.toStringAsFixed(0),
                'contracts.total'.tr(),
                Colors.white,
              ),
              HeaderStat(
                c.totalPaid.toStringAsFixed(0),
                'contracts.paid'.tr(),
                const Color(0xFF9FE1CB),
              ),
              HeaderStat(
                c.remainingAmount.toStringAsFixed(0),
                'contracts.remain'.tr(),
                const Color(0xFFF09595),
              ),
              HeaderStat(
                '${c.paidInstallments}/${c.installmentsCount}',
                'contracts.progress'.tr(),
                Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final ContractModel contract;
  final String Function(num) formatNumber;
  const _DetailsCard({required this.contract, required this.formatNumber});

  @override
  Widget build(BuildContext context) {
    final c = contract;
    return Card(
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('contracts.detail_title'.tr(), style: AppTextTheme.h4),
            SizedBox(height: 10.h),
            InfoRow(
              'contracts.sale_price'.tr(),
              '${formatNumber(c.cashPrice)} ج.م',
              null,
            ),
            InfoRow(
              'contracts.down_payment'.tr(),
              '${formatNumber(c.downPayment)} ج.م',
              AppColors.success,
            ),
            InfoRow(
              'contracts.total_installments'.tr(),
              '${formatNumber(c.totalContractAmount)} ج.م',
              AppColors.mainAppColor,
            ),
            InfoRow(
              'contracts.monthly_installment'.tr(),
              '${formatNumber(c.installmentAmount)} ج.م',
              AppColors.accentTeal,
            ),
            InfoRow(
              'contracts.installments_count'.tr(),
              '${c.installmentsCount}',
              null,
            ),
            InfoRow('contracts.quantity'.tr(), '${c.quantity}', null),
          ],
        ),
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final String Function(num) formatNumber;
  const _ScheduleCard({required this.formatNumber});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.mainAppColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.calendar_today,
                    color: AppColors.mainAppColor,
                    size: 18.sp,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  'جدول الأقساط'.tr(),
                  style: AppTextTheme.h4.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            BlocBuilder<
              GetContractInstallmentsCubit,
              BaseState<List<ContractInstallmentModel>>
            >(
              builder: (context, state) {
                if (state.status == Status.loading ||
                    state.status == Status.initial) {
                  return const InstallmentsShimmer();
                }
                if (state.status == Status.failure) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: FailureWidget(
                      errorMessage: state.errorMessage ?? 'حدث خطأ ما',
                      onRetry: () async {
                        final state = context
                            .findAncestorWidgetOfExactType<
                              _ContractDetailView
                            >();
                        final id = state?.contract.id ?? 0;
                        await context
                            .read<GetContractInstallmentsCubit>()
                            .getInstallments(id);
                      },
                    ),
                  );
                }
                final items = state.data ?? const <ContractInstallmentModel>[];
                if (items.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Center(
                      child: Text(
                        'لا يوجد اقساط',
                        style: AppTextTheme.bodySmall,
                      ),
                    ),
                  );
                }
                return Column(
                  children: items
                      .map(
                        (i) => _InstallmentRow(
                          installment: i,
                          formatNumber: formatNumber,
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _InstallmentRow extends StatelessWidget {
  final ContractInstallmentModel installment;
  final String Function(num) formatNumber;
  const _InstallmentRow({
    required this.installment,
    required this.formatNumber,
  });

  Color get _color {
    switch (installment.status) {
      case InstallmentStatus.paid:
        return AppColors.success;
      case InstallmentStatus.partial:
        return AppColors.warning;
      case InstallmentStatus.late:
        return AppColors.error;
      case InstallmentStatus.upcoming:
        return AppColors.mainAppColor;
    }
  }

  Color get _bg {
    switch (installment.status) {
      case InstallmentStatus.paid:
        return AppColors.successLight;
      case InstallmentStatus.partial:
        return AppColors.warningLight;
      case InstallmentStatus.late:
        return AppColors.errorLight;
      case InstallmentStatus.upcoming:
        return AppColors.mainLight;
    }
  }

  IconData get _statusIcon {
    switch (installment.status) {
      case InstallmentStatus.paid:
        return Icons.check_circle;
      case InstallmentStatus.partial:
        return Icons.schedule;
      case InstallmentStatus.late:
        return Icons.error;
      case InstallmentStatus.upcoming:
        return Icons.access_time;
    }
  }

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
    return '${d.day} ${months[(d.month - 1).clamp(0, 11)]}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Container(
        decoration: BoxDecoration(
          color: _bg,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: _color.withValues(alpha: 0.3), width: 1.5),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            children: [
              // Status Icon
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: _color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(_statusIcon, color: _color, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'القسط ${installment.sequence}',
                          style: AppTextTheme.labelSmall.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      _formatDate(installment.dueDate),
                      style: AppTextTheme.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              // Amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${formatNumber(installment.remaining)} ج.م',
                    style: AppTextTheme.labelSmall.copyWith(
                      color: _color,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.sp,
                    ),
                  ),
                  if (installment.status == InstallmentStatus.partial)
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: Text(
                        'متأخر',
                        style: AppTextTheme.caption.copyWith(
                          color: AppColors.error,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w600,
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
