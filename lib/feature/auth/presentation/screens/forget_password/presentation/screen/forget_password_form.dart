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

import '../../../../../../../core/router/app_router.dart';
import '../../../../../../main/catalog/presentation/widget/widgets/auth_primary_button.dart';
import '../../../../../../main/catalog/presentation/widget/widgets/field_label.dart';
import '../../../../../../main/catalog/presentation/widget/widgets/phone_field.dart';

class ForgetPasswordForm extends StatelessWidget {
  const ForgetPasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ForgetPasswordBloc>(
      create: (_) => getIt<ForgetPasswordBloc>(),
      child: const _ForgetPasswordFormView(),
    );
  }
}

class _ForgetPasswordFormView extends StatefulWidget {
  const _ForgetPasswordFormView();

  @override
  State<_ForgetPasswordFormView> createState() =>
      _ForgetPasswordFormViewState();
}

class _ForgetPasswordFormViewState extends State<_ForgetPasswordFormView> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    context.read<ForgetPasswordBloc>().add(
      ForgetPasswordEvent(phoneNumber: _phone.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgetPasswordBloc, BaseState<String>>(
      listener: (context, state) {
        if (state.status == Status.loading) {
          AppLoading.show(context, label: 'جارٍ الإرسال');
        } else if (state.status == Status.success) {
          AppLoading.hide(context);
          context.showTopSnackBar(
            message: 'تم إرسال رمز الاسترداد إلى رقم جوالك',
          );
          context.go(
            '${AppRouter.otp}?phone=${_phone.text.trim()}&type=forgot',
          );
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
            SizedBox(height: 20.h),
            const FieldLabel('رقم الجوال'),
            PhoneField(controller: _phone),
            SizedBox(height: 20.h),
            AuthPrimaryButton(label: 'إرسال رمز الاسترداد', onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
