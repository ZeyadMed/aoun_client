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
import 'package:aoun_client/feature/auth/presentation/screens/register/data/models/user_token.dart';
import 'package:aoun_client/feature/auth/presentation/screens/register/presentation/logic/register_bloc.dart';
import 'package:aoun_client/feature/auth/presentation/screens/register/presentation/logic/register_event.dart';
import 'package:aoun_client/core/local_storage/local_storage.dart';
import 'package:aoun_client/feature/main/catalog/presentation/widget/widgets/national_id_field.dart';

import '../../../../../../../core/router/app_router.dart';
import '../../../../../../main/catalog/presentation/widget/widgets/address_field.dart';
import '../../../../../../main/catalog/presentation/widget/widgets/agree_terms_checkbox.dart';
import '../../../../../../main/catalog/presentation/widget/widgets/auth_primary_button.dart';
import '../../../../../../main/catalog/presentation/widget/widgets/email_field.dart';
import '../../../../../../main/catalog/presentation/widget/widgets/field_label.dart';
import '../../../../../../main/catalog/presentation/widget/widgets/name_field.dart';
import '../../../../../../main/catalog/presentation/widget/widgets/password_field.dart';
import '../../../../../../main/catalog/presentation/widget/widgets/phone_field.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterBloc>(
      create: (_) => getIt<RegisterBloc>(),
      child: const _RegisterFormView(),
    );
  }
}

class _RegisterFormView extends StatefulWidget {
  const _RegisterFormView();

  @override
  State<_RegisterFormView> createState() => _RegisterFormViewState();
}

class _RegisterFormViewState extends State<_RegisterFormView> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _whatsapp = TextEditingController();
  final _nationalId = TextEditingController();
  bool _agreed = true;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    _email.dispose();
    _password.dispose();
    _whatsapp.dispose();
    _nationalId.dispose();
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
    if (!_formKey.currentState!.validate() || !_agreed) return;

    final deviceId = await HiveServiceImpl.instance.getDeviceId();
    if (!mounted) return;

    context.read<RegisterBloc>().add(
      RegisterEvent(
        fullname: _name.text.trim(),
        email: _email.text.trim(),
        phoneNumber: _phone.text.trim(),
        password: _password.text,
        whatsappNumber: _whatsapp.text.trim(),
        nationalId: _nationalId.text.trim(),
        rememberMe: true,
        address: _address.text.trim(),
        deviceId: deviceId,
        deviceInfo: _platformName(),
        deviceToken: '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, BaseState<UserToken>>(
      listener: (context, state) {
        if (state.status == Status.loading) {
          AppLoading.show(context, label: 'جارٍ إنشاء الحساب');
        } else if (state.status == Status.success) {
          AppLoading.hide(context);
          context.showTopSnackBar(message: 'تم إنشاء الحساب بنجاح');
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
            const FieldLabel('الاسم بالكامل'),
            NameField(controller: _name),
            SizedBox(height: 14.h),
            const FieldLabel('رقم الجوال'),
            PhoneField(controller: _phone),
            SizedBox(height: 14.h),
            const FieldLabel('العنوان (المدينة والحي)'),
            AddressField(controller: _address),
            SizedBox(height: 14.h),
            const FieldLabel("الرقم الهويه"),
            NationalIdField(controller: _nationalId),
            const FieldLabel('البريد الإلكتروني (اختياري)'),
            EmailField(controller: _email, optional: true),
            SizedBox(height: 14.h),
            const FieldLabel('كلمة المرور'),
            PasswordField(controller: _password),
            SizedBox(height: 14.h),
            const FieldLabel('رقم WhatsApp للإشعارات'),
            PhoneField(controller: _whatsapp),
            SizedBox(height: 14.h),
            AgreeTermsCheckbox(
              value: _agreed,
              onChanged: (v) => setState(() => _agreed = v),
            ),
            SizedBox(height: 18.h),
            AuthPrimaryButton(
              label: 'إنشاء الحساب',
              onPressed: _agreed ? _submit : null,
            ),
          ],
        ),
      ),
    );
  }
}
