import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aoun_client/core/bloc/paginated_bloc/exports.dart';
import 'package:aoun_client/core/enum/status.dart';
import 'package:aoun_client/core/service_locator/service_locator.dart';
import 'package:aoun_client/core/theme/app_colors.dart';
import 'package:aoun_client/core/theme/app_text_theme.dart';
import 'package:aoun_client/core/widgets/widgets.dart';
import 'package:aoun_client/feature/main/home/data/model/recent_payment_model.dart';
import 'package:aoun_client/feature/main/home/presentation/bloc/recent_payments_cubit.dart';
import 'package:aoun_client/feature/main/home/presentation/widget/custom_pay_row.dart';
import 'package:aoun_client/feature/main/home/presentation/widget/custom_section_tittle.dart';

class RecentPaymentsSection extends StatelessWidget {
  const RecentPaymentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RecentPaymentsCubit>()..getRecentPayments(),
      child: const _RecentPaymentsView(),
    );
  }
}

class _RecentPaymentsView extends StatelessWidget {
  const _RecentPaymentsView();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // من غير "عرض الكل"
        SectionTitle(title: 'home.recent_payments'.tr()),
        SizedBox(height: 8.h),
        BlocBuilder<RecentPaymentsCubit, BaseState<List<RecentPaymentModel>>>(
          builder: (context, state) {
            if (state.status == Status.loading ||
                state.status == Status.initial) {
              return const _RecentPaymentsShimmer();
            }

            if (state.status == Status.failure) {
              return const SizedBox.shrink();
            }

            final items = state.data ?? const <RecentPaymentModel>[];
            if (items.isEmpty) {
              return const _EmptyPaymentsCard();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int i = 0; i < items.length; i++) ...[
                  Card(
                    margin: EdgeInsets.zero,
                    child: _RecentPaymentRow(payment: items[i]),
                  ),
                  if (i != items.length - 1) SizedBox(height: 8.h),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class _RecentPaymentRow extends StatelessWidget {
  final RecentPaymentModel payment;
  const _RecentPaymentRow({required this.payment});

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
    return '${d.day} ${months[(d.month - 1).clamp(0, 11)]}';
  }

  @override
  Widget build(BuildContext context) {
    final name = payment.isFullyPaid
        ? '${payment.productName} — القسط ${payment.sequence}'
        : '${payment.productName} — دفعة جزئية';
    return PayRow(
      name,
      _formatDate(payment.paidDate),
      '${_formatNumber(payment.amount)} ج.م',
    );
  }
}

class _EmptyPaymentsCard extends StatelessWidget {
  const _EmptyPaymentsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 56.w,
            height: 56.h,
            decoration: BoxDecoration(
              color: AppColors.mainLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              color: AppColors.mainAppColor,
              size: 28.sp,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'home.no_payments'.tr(),
            style: AppTextTheme.labelMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentPaymentsShimmer extends StatelessWidget {
  const _RecentPaymentsShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(3, (i) {
        return Padding(
          padding: EdgeInsets.only(bottom: i == 2 ? 0 : 8.h),
          child: Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
              child: Row(
                children: [
                  const CustomShimmerWidget.circular(dimension: 32),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomShimmerWidget(height: 12.h, width: 140.w),
                        SizedBox(height: 6.h),
                        CustomShimmerWidget(height: 10.h, width: 80.w),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  CustomShimmerWidget(height: 14.h, width: 60.w),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
