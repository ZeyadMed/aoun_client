import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aoun_client/core/animation/boucing_boult_refresh_indicator.dart';
import 'package:aoun_client/core/bloc/paginated_bloc/exports.dart';
import 'package:aoun_client/core/enum/status.dart';
import 'package:aoun_client/core/service_locator/service_locator.dart';
import 'package:aoun_client/core/widgets/stateless/failure_widget.dart';
import 'package:aoun_client/feature/main/contracts/data/model/contract_model.dart';
import 'package:aoun_client/feature/main/contracts/presentation/bloc/get_contracts_cubit.dart';
import 'package:aoun_client/feature/main/contracts/presentation/widget/contarcts_cards.dart';
import 'package:aoun_client/feature/main/contracts/presentation/widget/contracts_shimmer.dart';
import 'package:aoun_client/feature/main/contracts/presentation/widget/custom_header_contatiner.dart';
import 'package:aoun_client/feature/main/contracts/presentation/widget/mock_show_row.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_theme.dart';

class ContractsScreen extends StatelessWidget {
  const ContractsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GetContractsCubit>(
      create: (_) =>
          getIt<GetContractsCubit>()..add(const LoadFirstPage<ContractModel>()),
      child: const _ContractsView(),
    );
  }
}

class _ContractsView extends StatefulWidget {
  const _ContractsView();

  @override
  State<_ContractsView> createState() => _ContractsViewState();
}

class _ContractsViewState extends State<_ContractsView> {
  int _filterIdx = 0;
  final _filters = ['all', 'active', 'completed', 'cancelled'];
  final _scroll = ScrollController();

  // الـ status حسب الـ API: Active = 1, Completed = 2, Cancelled = 3
  int? _statusFor(int idx) {
    switch (_filters[idx]) {
      case 'active':
        return 1;
      case 'completed':
        return 2;
      case 'cancelled':
        return 3;
      default:
        return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 200) {
      final cubit = context.read<GetContractsCubit>();
      final status = cubit.state.status;
      if (status != Status.isLoadingMore && status != Status.loading) {
        cubit.add(const LoadNextPage<ContractModel>());
      }
    }
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    super.dispose();
  }

  void _reload() {
    context.read<GetContractsCubit>().add(
      LoadFirstPage<ContractModel>(params: _statusFor(_filterIdx)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: BlocBuilder<GetContractsCubit, BaseState<ContractModel>>(
        builder: (context, state) {
          final contracts = state.items;
          final activeCount = contracts.where((c) => c.isActive).length;

          return Column(
            children: [
              CustomHeaderContatiner(activeCount: activeCount),
              _FilterChips(
                filters: _filters,
                selectedIdx: _filterIdx,
                onSelect: (i) {
                  setState(() => _filterIdx = i);
                  _reload();
                },
              ),
              Expanded(child: _buildBody(context, state, contracts)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    BaseState<ContractModel> state,
    List<ContractModel> filtered,
  ) {
    if (state.status == Status.loading || state.status == Status.initial) {
      return const ContractsShimmer();
    }
    if (state.status == Status.failure && state.items.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 60.h),
        child: FailureWidget(
          errorMessage: state.errorMessage ?? 'حدث خطأ ما',
          onRetry: () async => _reload(),
        ),
      );
    }
    if (filtered.isEmpty) {
      return _BouncingRefresh(
        onRefresh: () async => _reload(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: 120.h),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.note_add,
                    color: AppColors.mainAppColor,
                    weight: 30,
                  ),
                  SizedBox(height: 10.h),
                  Text('لاتوجد عقودات ', style: AppTextTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      );
    }
    final isLoadingMore = state.status == Status.isLoadingMore;
    return _BouncingRefresh(
      onRefresh: () async => _reload(),
      child: ListView.builder(
        controller: _scroll,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(12.w),
        itemCount: filtered.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (_, i) {
          if (i >= filtered.length) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const SizedBox(
                height: 60,
                child: BouncingBallRefreshIndicator(
                  progress: 1.0,
                  isRefreshing: true,
                ),
              ),
            );
          }
          return ContractCards(contract: filtered[i]);
        },
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final List<String> filters;
  final int selectedIdx;
  final ValueChanged<int> onSelect;

  const _FilterChips({
    required this.filters,
    required this.selectedIdx,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgSecondary,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: true,
        child: Row(
          children: List.generate(filters.length, (i) {
            final isActive = i == selectedIdx;
            return GestureDetector(
              onTap: () => onSelect(i),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.mainAppColor
                      : AppColors.bgSecondary,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isActive ? AppColors.mainAppColor : AppColors.border,
                  ),
                ),
                child: Text(
                  'contracts.${filters[i]}'.tr(),
                  style: AppTextTheme.labelSmall.copyWith(
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                    color: isActive ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String label;
  final Color fg, bg;
  const StatusBadge({
    super.key,
    required this.label,
    required this.fg,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(20.r),
    ),
    child: Text(label, style: AppTextTheme.captionBold.copyWith(color: fg)),
  );
}

class InfoRow extends StatelessWidget {
  final String label, value;
  final Color? valueColor;
  const InfoRow(this.label, this.value, this.valueColor, {super.key});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextTheme.bodySmall),

            Text(
              value,
              style: AppTextTheme.labelMedium.copyWith(
                color: valueColor ?? AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
      Divider(height: 1.h, color: AppColors.border),
    ],
  );
}

class ScheduleRow extends StatelessWidget {
  final MockSchedRow row;
  const ScheduleRow({required this.row, super.key});

  Color get _color {
    switch (row.status) {
      case 'done':
        return AppColors.success;
      case 'partial':
        return AppColors.warning;
      case 'late':
        return AppColors.error;
      default:
        return AppColors.mainAppColor;
    }
  }

  Color get _bg {
    switch (row.status) {
      case 'done':
        return AppColors.successLight;
      case 'partial':
        return AppColors.warningLight;
      case 'late':
        return AppColors.errorLight;
      default:
        return AppColors.mainLight;
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: 6.h),
    child: Row(
      children: [
        Text(
          '${row.remain.toStringAsFixed(0)} ج.م',
          style: AppTextTheme.labelMedium.copyWith(
            color: _color,
            fontSize: 11.sp,
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(row.date, style: AppTextTheme.labelSmall),
              Text(row.method, style: AppTextTheme.caption),
            ],
          ),
        ),
        SizedBox(width: 8.w),
        Container(
          width: 22.w,
          height: 22.h,
          decoration: BoxDecoration(
            color: _bg,
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Center(
            child: Text(
              '${row.number}',
              style: AppTextTheme.captionBold.copyWith(color: _color),
            ),
          ),
        ),
      ],
    ),
  );
}

/// Pull-to-refresh بنفس سلوك السلة — بيستخدم [BouncingBallRefreshIndicator]
/// بدل سبينر الـ Material العادي.
class _BouncingRefresh extends StatefulWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const _BouncingRefresh({required this.onRefresh, required this.child});

  @override
  State<_BouncingRefresh> createState() => _BouncingRefreshState();
}

class _BouncingRefreshState extends State<_BouncingRefresh> {
  static const double _triggerDistance = 80;

  double _drag = 0;
  bool _isRefreshing = false;

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;
    setState(() => _isRefreshing = true);
    try {
      await widget.onRefresh();
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
          _drag = 0;
        });
      }
    }
  }

  bool _onNotification(ScrollNotification n) {
    if (_isRefreshing) return false;
    if (n is OverscrollNotification && n.overscroll < 0) {
      setState(() {
        _drag = (_drag - n.overscroll).clamp(0.0, _triggerDistance * 1.6);
      });
    } else if (n is ScrollUpdateNotification) {
      if (n.metrics.pixels <= 0 && (n.dragDetails?.delta.dy ?? 0) > 0) {
        setState(() {
          _drag = (_drag + (n.dragDetails!.delta.dy)).clamp(
            0.0,
            _triggerDistance * 1.6,
          );
        });
      } else if (n.metrics.pixels > 0 && _drag > 0) {
        setState(() => _drag = 0);
      }
    } else if (n is ScrollEndNotification) {
      if (_drag >= _triggerDistance) {
        _handleRefresh();
      } else if (_drag > 0) {
        setState(() => _drag = 0);
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_drag / _triggerDistance).clamp(0.0, 1.0);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: _onNotification,
          child: widget.child,
        ),
        if (_drag > 0 || _isRefreshing)
          Positioned(
            top: 8,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 60,
              child: BouncingBallRefreshIndicator(
                progress: progress,
                isRefreshing: _isRefreshing,
              ),
            ),
          ),
      ],
    );
  }
}
