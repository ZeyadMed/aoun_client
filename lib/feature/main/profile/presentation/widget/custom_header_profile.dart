import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shimmer/shimmer.dart';
import 'package:aoun_client/core/bloc/paginated_bloc/exports.dart';
import 'package:aoun_client/core/enum/status.dart';
import 'package:aoun_client/core/theme/app_colors.dart';
import 'package:aoun_client/core/theme/app_text_theme.dart';
import 'package:aoun_client/feature/auth/presentation/screens/logout/presentation/widget/logout_button.dart';
import 'package:aoun_client/feature/main/profile/model/get_profile_model.dart';
import 'package:aoun_client/feature/main/profile/presentation/logic/get_profile_cubit.dart';
import 'package:aoun_client/feature/main/profile/presentation/widget/stat_card.dart';

class CustomHeaderProfile extends StatefulWidget {
  const CustomHeaderProfile({super.key});

  @override
  State<CustomHeaderProfile> createState() => _CustomHeaderProfileState();
}

class _CustomHeaderProfileState extends State<CustomHeaderProfile> {
  @override
  void initState() {
    super.initState();
    context.read<GetProfileCubit>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetProfileCubit, BaseState<GetProfileModel>>(
      builder: (context, state) {
        if (state.status == Status.loading) {
          return const _ProfileShimmer();
        }

        if (state.status == Status.failure) {
          return Center(
            child: Padding(
              padding: EdgeInsets.only(top: 120.h),
              child: Column(
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 40.sp),
                  SizedBox(height: 10.h),
                  Text(
                    state.failure?.message ?? "حدث خطأ",
                    style: AppTextTheme.bodySmall,
                  ),
                  SizedBox(height: 14.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<GetProfileCubit>().getProfile();
                    },
                    child: const Text("إعادة المحاولة"),
                  ),
                ],
              ),
            ),
          );
        }

        final profile = state.data;

        if (profile == null) {
          return const SizedBox();
        }

        return Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.mainAppColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28.r),
                  bottomRight: Radius.circular(28.r),
                ),
              ),
              padding: EdgeInsets.fromLTRB(
                16.w,
                MediaQuery.of(context).padding.top + 14.h,
                16.w,
                28.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 70.w,
                    height: 70.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(22.r),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.person,
                        size: 34.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  SizedBox(height: 14.h),

                  Text(
                    profile.fullName,
                    style: AppTextTheme.h3.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 5.h),

                  Text(
                    profile.ratingText,
                    style: AppTextTheme.caption.copyWith(color: Colors.white70),
                  ),

                  SizedBox(height: 6.h),

                  Text(
                    '${profile.phoneNumber} · ${profile.address}',
                    style: AppTextTheme.caption.copyWith(color: Colors.white70),
                  ),

                  SizedBox(height: 16.h),

                  Row(
                    children: [
                      _ratingBadge(
                        profile.rating.toString(),
                        'profile.rating'.tr(),
                      ),

                      SizedBox(width: 8.w),

                      _ratingBadge(
                        profile.activeContractsCount.toString(),
                        "السجل التجاري",
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          'الوحدات',
                          profile.activeContractsCount.toString(),
                          AppColors.mainAppColor,
                          AppColors.mainLight,
                        ),
                      ),

                      SizedBox(width: 8.w),

                      Expanded(
                        child: StatCard(
                          'المستحقات',
                          '${profile.totalDebt} ج.م',
                          AppColors.success,
                          AppColors.successLight,
                        ),
                      ),

                      SizedBox(width: 8.w),

                      Expanded(
                        child: StatCard(
                          'مدة التعامل',
                          profile.durationText,
                          AppColors.accentTeal,
                          AppColors.tealLight,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 14.h),

                  const LogoutButton(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _ratingBadge(String val, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Text(
            val,
            style: AppTextTheme.labelMedium.copyWith(color: Colors.white),
          ),

          SizedBox(width: 4.w),

          Text(
            label,
            style: AppTextTheme.caption.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _ProfileShimmer extends StatelessWidget {
  const _ProfileShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 260.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28.r),
                bottomRight: Radius.circular(28.r),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 85.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                ),

                SizedBox(width: 8.w),

                Expanded(
                  child: Container(
                    height: 85.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                ),

                SizedBox(width: 8.w),

                Expanded(
                  child: Container(
                    height: 85.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Container(
              width: double.infinity,
              height: 55.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
