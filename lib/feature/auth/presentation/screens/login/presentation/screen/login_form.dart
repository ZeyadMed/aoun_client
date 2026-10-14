import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
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
import 'package:aoun_client/feature/auth/presentation/screens/login/presentation/logic/login_bloc.dart';
import 'package:aoun_client/feature/auth/presentation/screens/login/presentation/logic/login_event.dart';
import 'package:aoun_client/core/local_storage/local_storage.dart';
import 'package:aoun_client/feature/auth/presentation/screens/register/data/models/user_token.dart';

import '../../../../../../../core/router/app_router.dart';
import '../../../../../../main/catalog/presentation/widget/widgets/auth_primary_button.dart';
import '../../../../../../main/catalog/presentation/widget/widgets/field_label.dart';
import '../../../../../../main/catalog/presentation/widget/widgets/forgot_password_link.dart';
import '../../../../../../main/catalog/presentation/widget/widgets/or_divider.dart';
import '../../../../../../main/catalog/presentation/widget/widgets/password_field.dart';
import '../../../../../../main/catalog/presentation/widget/widgets/phone_field.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (_) => getIt<LoginBloc>(),
      child: const _LoginFormView(),
    );
  }
}

class _LoginFormView extends StatefulWidget {
  const _LoginFormView();

  @override
  State<_LoginFormView> createState() => _LoginFormViewState();
}

class _LoginFormViewState extends State<_LoginFormView> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  String _platformName() {
    if (kIsWeb) return 'web';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isWindows) return 'windows';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isLinux) return 'linux';
    return 'unknown';
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final deviceId = await HiveServiceImpl.instance.getDeviceId();
    if (!mounted) return;

    context.read<LoginBloc>().add(
      LoginEvent(
        phoneNumber: _phone.text.trim(),
        password: _password.text,
        rememberMe: true,
        deviceId: deviceId,
        deviceInfo: _platformName(),
        deviceToken: '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, BaseState<UserToken>>(
      listener: (context, state) {
        if (state.status == Status.loading) {
          AppLoading.show(context, label: 'جارٍ تسجيل الدخول');
        } else if (state.status == Status.success) {
          AppLoading.hide(context);
          context.showTopSnackBar(message: 'تم تسجيل الدخول بنجاح');
          context.go(AppRouter.home);
        } else if (state.status == Status.failure) {
          AppLoading.hide(context);
          context.showTopSnackBar(
            message: state.errorMessage ?? 'حدث خطأ، حاول مرة أخرى',
            type: SnackBarType.error,
          );
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const FieldLabel('رقم الجوال'),
            PhoneField(controller: _phone),
            SizedBox(height: 14.h),
            const FieldLabel('كلمة المرور'),
            PasswordField(controller: _password),
            const ForgotPasswordLink(),
            AuthPrimaryButton(label: 'تسجيل الدخول', onPressed: _submit),
            SizedBox(height: 16.h),
            // const OrDivider(),
          ],
        ),
      ),
    );
  }
}
