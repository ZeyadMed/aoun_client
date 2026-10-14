import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../core/bloc/paginated_bloc/exports.dart';
import '../../../../../../../core/enum/snack_bar_enum.dart';
import '../../../../../../../core/enum/status.dart';
import '../../../../../../../core/extensions/extensions.dart';
import '../../../../../../../core/extention/custom_loading.dart';
import '../../../../../../../core/router/app_router.dart';
import '../../../../../../../core/service_locator/service_locator.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/app_text_theme.dart';
import '../logic/logout_bloc.dart';
import '../logic/logout_event.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LogoutBloc>(
      create: (_) => getIt<LogoutBloc>(),
      child: const _LogoutButtonView(),
    );
  }
}

class _LogoutButtonView extends StatefulWidget {
  const _LogoutButtonView();

  @override
  State<_LogoutButtonView> createState() => _LogoutButtonViewState();
}

class _LogoutButtonViewState extends State<_LogoutButtonView> {
  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: AppColors.error,
                  size: 32.sp,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'تسجيل الخروج',
                style: AppTextTheme.h3.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'هل أنت متأكد أنك تريد تسجيل الخروج؟',
                textAlign: TextAlign.center,
                style: AppTextTheme.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 13.sp,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44.h,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.border, width: 1.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          'إلغاء',
                          style: AppTextTheme.button.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: SizedBox(
                      height: 44.h,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          'تأكيد',
                          style: AppTextTheme.button.copyWith(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
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

    if (!mounted) return;
    if (confirmed == true) {
      context.read<LogoutBloc>().add(LogoutEvent());
    }
  }

  void _clearAndNavigate() {
    getIt<Dio>().options.headers.remove('Authorization');
    context.go(AppRouter.login);
  }

  void _showSnackOnLogin({
    required String message,
    required SnackBarType type,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx =
          AppRouter.router.routerDelegate.navigatorKey.currentContext;
      ctx?.showTopSnackBar(message: message, type: type);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutBloc, BaseState<void>>(
      listener: (context, state) {
        if (state.status == Status.loading) {
          AppLoading.show(context, label: 'جاري تسجيل الخروج');
        } else if (state.status == Status.success) {
          AppLoading.hide(context);
          _clearAndNavigate();
          _showSnackOnLogin(
            message: 'تم تسجيل الخروج بنجاح',
            type: SnackBarType.success,
          );
        } else if (state.status == Status.failure) {
          AppLoading.hide(context);
          _clearAndNavigate();
          _showSnackOnLogin(
            message: state.errorMessage ?? 'فشل تسجيل الخروج',
            type: SnackBarType.error,
          );
        }
      },
      child: SizedBox(
        height: 48.h,
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: _confirmLogout,
          icon: Icon(Icons.logout, size: 18.sp, color: AppColors.error),
          label: Text(
            'profile.log_out'.tr(),
            style: AppTextTheme.labelLarge.copyWith(color: AppColors.error),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.errorLight, width: 1.5),
            backgroundColor: AppColors.errorLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      ),
    );
  }
}
