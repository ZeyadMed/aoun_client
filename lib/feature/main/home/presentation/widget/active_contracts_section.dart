import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:aoun_client/core/bloc/paginated_bloc/exports.dart';
import 'package:aoun_client/core/enum/status.dart';
import 'package:aoun_client/core/router/app_router.dart';
import 'package:aoun_client/core/service_locator/service_locator.dart';
import 'package:aoun_client/core/theme/app_colors.dart';
import 'package:aoun_client/core/theme/app_text_theme.dart';
import 'package:aoun_client/core/widgets/widgets.dart';
import 'package:aoun_client/feature/main/contracts/data/model/contract_model.dart';
import 'package:aoun_client/feature/main/contracts/presentation/bloc/get_recent_contracts_cubit.dart';
import 'package:aoun_client/feature/main/home/presentation/widget/custom_section_tittle.dart';
import 'package:aoun_client/feature/main/home/presentation/widget/main_contract_card.dart';

class ActiveContractsSection extends StatelessWidget {
  const ActiveContractsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GetRecentContractsCubit>()..getRecentContracts(),
      child: const _ActiveContractsView(),
    );
  }
}

class _ActiveContractsView extends StatelessWidget {
  const _ActiveContractsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetRecentContractsCubit, BaseState<List<ContractModel>>>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionTitle(
              title: 'home.active_contracts'.tr(),
              onMore: () => context.go(AppRouter.contracts),
            ),
            SizedBox(height: 8.h),
            _buildBody(context, state),
          ],
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    BaseState<List<ContractModel>> state,
  ) {
    if (state.status == Status.loading || state.status == Status.initial) {
      return const _ActiveContractsShimmer();
    }
    if (state.status == Status.failure) {
      return _ErrorBox(
        message: state.errorMessage ?? 'حدث خطأ ما',
        onRetry: () =>
            context.read<GetRecentContractsCubit>().getRecentContracts(),
      );
    }

    final contracts = state.data ?? const <ContractModel>[];
    if (contracts.isEmpty) {
      return const _EmptyBox();
    }

    return Column(
      children: contracts
          .map(
            (c) => _RecentContractCard(
              contract: c,
              onTap: () => context.push('/contracts/${c.id}', extra: c),
            ),
          )
          .toList(),
    );
  }
}

class _RecentContractCard extends StatelessWidget {
  final ContractModel contract;
  final VoidCallback onTap;
  const _RecentContractCard({required this.contract, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isLate = contract.isLate;
    final isEnded = contract.isEnded;

    final color = isLate
        ? AppColors.error
        : isEnded
        ? AppColors.textHint
        : AppColors.mainAppColor;

    final statusFg = isLate
        ? AppColors.error
        : isEnded
        ? AppColors.textHint
        : AppColors.success;

    final statusBg = isLate
        ? AppColors.errorLight
        : isEnded
        ? AppColors.bgTertiary
        : AppColors.successLight;

    final statusLabel = isLate
        ? 'متأخر'
        : isEnded
        ? 'contracts.ended'.tr()
        : 'منتظم';

    return MiniContractCard(
      name: contract.productName,
      id: contract.contractNo,
      type: 'شهري',
      progress: '${contract.paidInstallments}/${contract.installmentsCount}',
      pct: contract.progressPct,
      color: color,
      statusLabel: statusLabel,
      statusFg: statusFg,
      statusBg: statusBg,
      installment: contract.installmentAmount.round(),
      onTap: onTap,
    );
  }
}

class _ActiveContractsShimmer extends StatelessWidget {
  const _ActiveContractsShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(2, (_) {
        return Container(
          margin: EdgeInsets.only(bottom: 8.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColors.bgSecondary,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomShimmerWidget(height: 14.h, width: 140.w),
                      SizedBox(height: 6.h),
                      CustomShimmerWidget(height: 10.h, width: 90.w),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomShimmerWidget(height: 14.h, width: 70.w),
                      SizedBox(height: 6.h),
                      CustomShimmerWidget(height: 10.h, width: 60.w),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              CustomShimmerWidget(height: 4.h),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomShimmerWidget(height: 10.h, width: 60.w),
                  CustomShimmerWidget(height: 18.h, width: 60.w),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _EmptyBox extends StatelessWidget {
  const _EmptyBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 64.w,
            height: 64.h,
            decoration: BoxDecoration(
              color: AppColors.mainLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.description_outlined,
              color: AppColors.mainAppColor,
              size: 32.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'لا توجد عقود نشطة',
            style: AppTextTheme.labelLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'لم يتم إنشاء أي عقد حتى الآن',
            style: AppTextTheme.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorBox({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppColors.error, size: 22.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              message,
              style: AppTextTheme.bodySmall.copyWith(color: AppColors.error),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: Text(
              'إعادة محاولة',
              style: AppTextTheme.labelSmall.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
