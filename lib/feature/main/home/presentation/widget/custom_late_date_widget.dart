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
import 'package:aoun_client/feature/main/contracts/data/model/overdue_installment_model.dart';
import 'package:aoun_client/feature/main/contracts/presentation/bloc/get_overdue_installments_cubit.dart';

class CustomLateDateWidget extends StatelessWidget {
  const CustomLateDateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<GetOverdueInstallmentsCubit>()..getOverdueInstallments(),
      child: const _OverdueView(),
    );
  }
}

class _OverdueView extends StatelessWidget {
  const _OverdueView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      GetOverdueInstallmentsCubit,
      BaseState<List<OverdueInstallmentModel>>
    >(
      builder: (context, state) {
        if (state.status == Status.loading || state.status == Status.initial) {
          return const _OverdueShimmer();
        }

        // لو فيه خطأ أو مفيش أقساط متأخرة بنخفي البلوك خالص
        // وبكده تظهر "عقودي النشطة" على طول من غير أي رسالة
        if (state.status == Status.failure) {
          return const SizedBox.shrink();
        }

        final items = state.data ?? const <OverdueInstallmentModel>[];
        if (items.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (int i = 0; i < items.length; i++) ...[
              _OverdueAlertCard(installment: items[i]),
              if (i != items.length - 1) SizedBox(height: 8.h),
            ],
            SizedBox(height: 12.h),
          ],
        );
      },
    );
  }
}

class _OverdueAlertCard extends StatelessWidget {
  final OverdueInstallmentModel installment;
  const _OverdueAlertCard({required this.installment});

  String _formatNumber(num value) => value
      .toStringAsFixed(value.truncateToDouble() == value ? 0 : 2)
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (installment.productName.isNotEmpty)
                  Text(
                    installment.productName,
                    style: AppTextTheme.labelSmall.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                Text(
                  'home.late_alert'.tr(
                    namedArgs: {
                      'days': '${installment.daysOverdue}',
                      'amount': _formatNumber(installment.remaining),
                    },
                  ),
                  style: AppTextTheme.caption.copyWith(color: AppColors.error),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OverdueShimmer extends StatelessWidget {
  const _OverdueShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: AppColors.errorLight,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            children: [
              const CustomShimmerWidget.circular(dimension: 16),
              SizedBox(width: 8.w),
              Expanded(child: CustomShimmerWidget(height: 14.h)),
            ],
          ),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }
}
