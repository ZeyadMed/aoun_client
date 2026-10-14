import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:aoun_client/core/bloc/paginated_bloc/exports.dart';
import 'package:aoun_client/core/enum/snack_bar_enum.dart';
import 'package:aoun_client/core/enum/status.dart';
import 'package:aoun_client/core/extensions/extensions.dart';
import 'package:aoun_client/core/extention/custom_loading.dart';
import 'package:aoun_client/core/service_locator/service_locator.dart';
import 'package:aoun_client/feature/auth/presentation/screens/forget_password/presentation/logic/forget_password_bloc.dart';
import 'package:aoun_client/feature/auth/presentation/screens/forget_password/presentation/logic/forget_password_event.dart';
import 'package:aoun_client/feature/auth/presentation/screens/verify_otp/presentation/logic/verify_otp_bloc.dart';
import 'package:aoun_client/feature/auth/presentation/screens/verify_otp/presentation/logic/verify_otp_event.dart';

import '../../../../../../../core/router/app_router.dart';
import '../../../../../../../core/theme/app_text_theme.dart';
import '../../../../../../main/catalog/presentation/widget/widgets/auth_primary_button.dart';
import '../../../../../../main/catalog/presentation/widget/widgets/otp_info_icon.dart';
import '../../../../../../main/catalog/presentation/widget/widgets/otp_pin_field.dart';
import '../../../../../../main/catalog/presentation/widget/widgets/otp_timer_resend.dart';

class VerifyOtpBody extends StatelessWidget {
  final String phone;
  final String type;

  const VerifyOtpBody({super.key, required this.phone, required this.type});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<VerifyOtpBloc>(create: (_) => getIt<VerifyOtpBloc>()),
        BlocProvider<ForgetPasswordBloc>(
          create: (_) => getIt<ForgetPasswordBloc>(),
        ),
      ],
      child: _VerifyOtpView(phone: phone, type: type),
    );
  }
}

class _VerifyOtpView extends StatefulWidget {
  final String phone;
  final String type;

  const _VerifyOtpView({required this.phone, required this.type});

  @override
  State<_VerifyOtpView> createState() => _VerifyOtpViewState();
}

class _VerifyOtpViewState extends State<_VerifyOtpView> {
  static const int _initialSeconds = 105;
  int _seconds = _initialSeconds;
  Timer? _timer;
  final _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _seconds = _initialSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds > 0) {
        setState(() => _seconds--);
      } else {
        t.cancel();
      }
    });
  }

  void _resend() {
    context.read<ForgetPasswordBloc>().add(
      ForgetPasswordEvent(phoneNumber: widget.phone),
    );
    _startTimer();
  }

  void _verify() {
    final code = _otpController.text.trim();
    if (code.length != 6) {
      context.showTopSnackBar(
        message: 'الرجاء إدخال رمز مكون من 6 أرقام',
        type: SnackBarType.error,
      );
      return;
    }
    context.read<VerifyOtpBloc>().add(
      VerifyOtpEvent(phoneNumber: widget.phone, otpCode: code),
    );
  }

  void _onSuccess() {
    switch (widget.type) {
      case 'forgot':
        context.go(AppRouter.newPassword);
        break;
      case 'register':
      case 'login':
      default:
        context.go(AppRouter.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<VerifyOtpBloc, BaseState<String>>(
          listener: (context, state) {
            if (state.status == Status.loading) {
              AppLoading.show(context, label: 'جارٍ التحقق');
            } else if (state.status == Status.success) {
              AppLoading.hide(context);
              context.showTopSnackBar(message: 'تم التحقق بنجاح');
              _onSuccess();
            } else if (state.status == Status.failure) {
              AppLoading.hide(context);
              context.showTopSnackBar(
                message: state.errorMessage ?? 'الكود غير صحيح',
                type: SnackBarType.error,
              );
            }
          },
        ),
        BlocListener<ForgetPasswordBloc, BaseState<String>>(
          listener: (context, state) {
            if (state.status == Status.loading) {
              AppLoading.show(context, label: 'جارٍ إعادة الإرسال');
            } else if (state.status == Status.success) {
              AppLoading.hide(context);
              context.showTopSnackBar(message: 'تم إعادة إرسال الرمز');
            } else if (state.status == Status.failure) {
              AppLoading.hide(context);
              context.showTopSnackBar(
                message: state.errorMessage ?? 'تعذّر إعادة الإرسال',
                type: SnackBarType.error,
              );
            }
          },
        ),
      ],
      child: Column(
        children: [
          SizedBox(height: 14.h),
          const OtpInfoIcon(),
          SizedBox(height: 16.h),
          Text('أدخل الرمز', style: AppTextTheme.h2),
          SizedBox(height: 8.h),
          Text(
            'كود مكوّن من 6 أرقام أُرسل إلى\n+966 ${widget.phone}',
            style: AppTextTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          Align(
            alignment: Alignment.centerLeft,
            child: OtpPinField(
              controller: _otpController,
              length: 6,
              onCompleted: (_) => _verify(),
            ),
          ),
          SizedBox(height: 16.h),
          OtpTimerResend(seconds: _seconds, onResend: _resend),
          SizedBox(height: 24.h),
          AuthPrimaryButton(label: 'common.confirm'.tr(), onPressed: _verify),
        ],
      ),
    );
  }
}
