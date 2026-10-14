import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aoun_client/core/bloc/paginated_bloc/exports.dart';
import 'package:aoun_client/core/enum/status.dart';
import 'package:aoun_client/core/service_locator/service_locator.dart';
import 'package:aoun_client/feature/main/statement/data/model/contract_product_model.dart';
import 'package:aoun_client/feature/main/statement/data/model/statements_model.dart';
import 'package:aoun_client/feature/main/statement/presentation/bloc/get_contract_products_cubit.dart';
import 'package:aoun_client/feature/main/statement/presentation/bloc/get_statement_cubit.dart';
import 'package:aoun_client/feature/main/statement/presentation/widget/statement_body.dart';
import 'package:aoun_client/feature/main/statement/presentation/widget/statement_shimmer.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_theme.dart';

class StatementScreen extends StatelessWidget {
  const StatementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetContractProductsCubit>(
          create: (_) =>
              getIt<GetContractProductsCubit>()..getContractProducts(),
        ),
        BlocProvider<GetStatementCubit>(
          create: (_) => getIt<GetStatementCubit>(),
        ),
      ],
      child: const _StatementView(),
    );
  }
}

class _StatementView extends StatefulWidget {
  const _StatementView();

  @override
  State<_StatementView> createState() => _StatementViewState();
}

class _StatementViewState extends State<_StatementView> {
  int? _selectedProductId;

  void _onProductsLoaded(List<ContractProductModel> products) {
    if (products.isEmpty) return;
    if (_selectedProductId != null) return;
    final firstId = products.first.id;
    _selectedProductId = firstId;
    context.read<GetStatementCubit>().getStatement(firstId);
  }

  void _selectProduct(int id) {
    if (_selectedProductId == id) return;
    setState(() => _selectedProductId = id);
    context.read<GetStatementCubit>().getStatement(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Column(
        children: [
          _Header(),
          Expanded(
            child:
                BlocConsumer<
                  GetContractProductsCubit,
                  BaseState<List<ContractProductModel>>
                >(
                  listener: (context, state) {
                    if (state.status == Status.success) {
                      _onProductsLoaded(state.data ?? const []);
                    }
                  },
                  builder: (context, productsState) {
                    if (productsState.status == Status.loading ||
                        productsState.status == Status.initial) {
                      return const StatementShimmer();
                    }
                    if (productsState.status == Status.failure) {
                      return _ErrorState(
                        message: productsState.errorMessage ?? 'حدث خطأ ما',
                        onRetry: () => context
                            .read<GetContractProductsCubit>()
                            .getContractProducts(),
                      );
                    }
                    final products = productsState.data ?? const [];
                    if (products.isEmpty) {
                      return const _EmptyState();
                    }
                    return ListView(
                      padding: EdgeInsets.all(12.w),
                      children: [
                        _ProductDropdown(
                          products: products,
                          selectedId: _selectedProductId,
                          onChanged: _selectProduct,
                        ),
                        SizedBox(height: 10.h),
                        BlocBuilder<
                          GetStatementCubit,
                          BaseState<StatementsModel>
                        >(
                          builder: (context, statementState) {
                            if (statementState.status == Status.loading ||
                                statementState.status == Status.initial) {
                              return const StatementShimmer(
                                showDropdown: false,
                              );
                            }
                            if (statementState.status == Status.failure) {
                              return _ErrorState(
                                message:
                                    statementState.errorMessage ?? 'حدث خطأ ما',
                                onRetry: () => context
                                    .read<GetStatementCubit>()
                                    .getStatement(_selectedProductId ?? 0),
                              );
                            }
                            final data = statementState.data;
                            if (data == null || data.statements.isEmpty) {
                              return const _NoDataState();
                            }
                            return Column(
                              children: [
                                ...List.generate(data.statements.length, (
                                  index,
                                ) {
                                  final statement = data.statements[index];
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 16.h),
                                    child: _ContractCardWrapper(
                                      contractNumber: statement.contractNumber,
                                      contractIndex: index + 1,
                                      totalContracts: data.statements.length,
                                      child: StatementBody(
                                        statement: statement,
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: 80.h),
                      ],
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.mainAppColor,
      padding: EdgeInsets.fromLTRB(
        16.w,
        MediaQuery.of(context).padding.top + 12.h,
        16.w,
        14.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'statement.title'.tr(),
            style: AppTextTheme.h3.copyWith(color: Colors.white),
          ),
          Text(
            'statement.subtitle'.tr(),
            style: AppTextTheme.caption.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _ProductDropdown extends StatelessWidget {
  final List<ContractProductModel> products;
  final int? selectedId;
  final ValueChanged<int> onChanged;

  const _ProductDropdown({
    required this.products,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = products.any((p) => p.id == selectedId)
        ? selectedId
        : null;
    return DropdownButtonFormField<int>(
      initialValue: selected,
      isExpanded: true,
      hint: Text(
        'statement.select_contract'.tr(),
        style: AppTextTheme.bodySmall,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.bgSecondary,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: AppColors.mainAppColor),
        ),
      ),
      items: products
          .map(
            (p) => DropdownMenuItem<int>(
              value: p.id,
              child: Text(p.name, style: AppTextTheme.bodySmall),
            ),
          )
          .toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}

class _ContractCardWrapper extends StatelessWidget {
  final String contractNumber;
  final int contractIndex;
  final int totalContracts;
  final Widget child;

  const _ContractCardWrapper({
    required this.contractNumber,
    required this.contractIndex,
    required this.totalContracts,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contract Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.mainAppColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14.r),
                topRight: Radius.circular(14.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contractNumber,
                      style: AppTextTheme.labelLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    '$contractIndex/$totalContracts',
                    style: AppTextTheme.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Contract Body
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.bgSecondary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(14.r),
                bottomRight: Radius.circular(14.r),
              ),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80.w,
              height: 80.h,
              decoration: const BoxDecoration(
                color: AppColors.mainLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.receipt_long_outlined,
                color: AppColors.mainAppColor,
                size: 40.sp,
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              'statement.no_contracts_title'.tr(),
              style: AppTextTheme.h4.copyWith(color: AppColors.textPrimary),
            ),
            SizedBox(height: 4.h),
            Text(
              'statement.no_contracts_sub'.tr(),
              style: AppTextTheme.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoDataState extends StatelessWidget {
  const _NoDataState();

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
            decoration: const BoxDecoration(
              color: AppColors.mainLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inbox_outlined,
              color: AppColors.mainAppColor,
              size: 32.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'statement.no_data'.tr(),
            style: AppTextTheme.labelLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: AppColors.error, size: 44.sp),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextTheme.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 12.h),
            ElevatedButton(
              onPressed: onRetry,
              child: Text('statement.retry'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
