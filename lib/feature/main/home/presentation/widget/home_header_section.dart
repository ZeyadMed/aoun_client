import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:aoun_client/core/bloc/paginated_bloc/exports.dart';
import 'package:aoun_client/core/enum/status.dart';
import 'package:aoun_client/core/router/app_router.dart';
import 'package:aoun_client/core/service_locator/service_locator.dart';
import 'package:aoun_client/core/theme/app_colors.dart';
import 'package:aoun_client/core/theme/app_text_theme.dart';
import 'package:aoun_client/feature/main/home/presentation/bloc/dashboard_summary_cubit.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({super.key});

  String _formatNumber(num value) => value
      .toStringAsFixed(value.truncateToDouble() == value ? 0 : 2)
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');

  String _formatDate(String date) {
    final parsed = DateTime.tryParse(date);
    if (parsed == null) return date;
    return DateFormat('yyyy/MM/dd').format(parsed);
  }

  Color _progressColor(int pct) {
    if (pct >= 100) return const Color(0xff22C55E);
    if (pct >= 50) return const Color(0xff86EFAC);
    if (pct > 0) return const Color(0xffF59F00);
    return const Color(0xffEF4444);
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BlocProvider(
        create: (_) => getIt<DashboardSummaryCubit>()..getDashboardSummary(),
        child: BlocBuilder<DashboardSummaryCubit, BaseState<dynamic>>(
          builder: (context, state) {
            /// 🔄 Loading
            if (state.status == Status.loading) {
              return const _LoadingHeader();
            }

            final data = state.data;

            /// ❌ Error
            if (data == null) {
              return _ErrorHeader(
                onRetry: () =>
                    context.read<DashboardSummaryCubit>().getDashboardSummary(),
              );
            }

            /// 🟢 Empty State
            if (data.totalDebt == 0 && data.totalInstallments == 0) {
              return const _EmptyHeader();
            }

            /// ✅ Normal UI
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
                  /// 👋 Header
                  Column(
                    children: [
                      Text(
                        '${'home.welcome'.tr()}، ${data.clientName} 👋',
                        style: AppTextTheme.h3.copyWith(color: Colors.white),
                      ),
                      Text(
                        _formatDate(data.today),
                        style: AppTextTheme.caption.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 14.h),

                  /// 💰 Card
                  Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'home.total_debt'.tr(),
                          style: AppTextTheme.caption.copyWith(
                            color: Colors.white70,
                          ),
                        ),

                        SizedBox(height: 4.h),

                        /// 💰 Amount
                        Row(
                          children: [
                            Text(
                              _formatNumber(data.totalDebt),
                              style: AppTextTheme.display2.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              ' ج.م',
                              style: AppTextTheme.bodyLarge.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),

                        /// 📌 Next installment
                        Text(
                          '${'home.next_installment'.tr()}: '
                          '${_formatNumber(data.nextInstallment.amount)} ج.م '
                          '(${_formatDate(data.nextInstallment.dueDate)}) — '
                          '${'home.days_left'.tr(namedArgs: {'days': '${data.nextInstallment.daysUntilDue}'})}',
                          style: AppTextTheme.caption.copyWith(
                            color: Colors.white60,
                          ),
                        ),

                        SizedBox(height: 8.h),

                        /// 📊 Progress
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.r),
                          child: LinearProgressIndicator(
                            value: data.percentPaid == 0
                                ? 1.0
                                : data.progressPct,
                            backgroundColor: _progressColor(data.percentPaid)
                                .withValues(alpha: 0.25),
                            valueColor: AlwaysStoppedAnimation(
                              _progressColor(data.percentPaid),
                            ),
                            minHeight: 6.h,
                          ),
                        ),

                        SizedBox(height: 6.h),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${data.percentPaid}% ${'home.paid_pct'.tr()}',
                              style: AppTextTheme.caption.copyWith(
                                color: _progressColor(data.percentPaid),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '${data.paidInstallments} / ${data.totalInstallments} قسط',
                              style: AppTextTheme.caption.copyWith(
                                color: Colors.white70,
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
          },
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔥 Shimmer
class _LoadingHeader extends StatelessWidget {
  const _LoadingHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.mainAppColor,
      height: 150.h,
      child: Shimmer.fromColors(
        baseColor: Colors.white24,
        highlightColor: Colors.white38,
        child: Container(color: Colors.white),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// 🟢 Empty State
class _EmptyHeader extends StatelessWidget {
  const _EmptyHeader();

  @override
  Widget build(BuildContext context) {
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
          Text(
            'مرحباً 👋',
            style: AppTextTheme.h3.copyWith(color: Colors.white),
          ),
          SizedBox(height: 20.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 40.sp,
                ),
                SizedBox(height: 10.h),
                Text(
                  'لا يوجد مديونية حالياً',
                  style: AppTextTheme.bodyLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'ابدأ التسوق أو إنشاء عقد جديد',
                  style: AppTextTheme.caption.copyWith(color: Colors.white70),
                ),
                SizedBox(height: 14.h),
                ElevatedButton(
                  onPressed: () => context.go(AppRouter.catalog),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    'ابدأ الآن',
                    style: TextStyle(color: AppColors.mainAppColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// ❌ Error
class _ErrorHeader extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorHeader({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.mainAppColor,
      padding: EdgeInsets.fromLTRB(
        16.w,
        MediaQuery.of(context).padding.top + 12.h,
        16.w,
        16.h,
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.error_outline, color: Colors.white, size: 40.sp),
            SizedBox(height: 12.h),
            Text(
              'خطأ في تحميل البيانات',
              style: AppTextTheme.bodySmall.copyWith(color: Colors.white),
            ),
            SizedBox(height: 12.h),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: Text(
                'إعادة محاولة',
                style: AppTextTheme.labelSmall.copyWith(
                  color: AppColors.mainAppColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
