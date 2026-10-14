import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aoun_client/core/bloc/paginated_bloc/exports.dart';
import 'package:aoun_client/core/enum/status.dart';
import 'package:aoun_client/feature/auth/presentation/screens/register/data/data_source/register_data_source.dart';
import 'package:aoun_client/feature/auth/presentation/screens/register/data/models/user_token.dart';
import 'package:aoun_client/feature/auth/presentation/screens/register/presentation/logic/register_event.dart';

class RegisterBloc extends Bloc<RegisterEvent, BaseState<UserToken>> {
  final RegisterDataSource _registerDataSource;
  RegisterBloc(this._registerDataSource) : super(const BaseState()) {
    on<RegisterEvent>(_onRegister);
  }

  FutureOr<void> _onRegister(
    RegisterEvent event,
    Emitter<BaseState<UserToken>> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    final result = await _registerDataSource.register(
      email: event.email,
      password: event.password,
      fullname: event.fullname,
      whatsappNumber: event.whatsappNumber,
      nationalId: event.nationalId,
      rememberMe: event.rememberMe,
      address: event.address,
      phoneNumber: event.phoneNumber,
      deviceId: event.deviceId,
      deviceInfo: event.deviceInfo,
      deviceToken: event.deviceToken,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          failure: failure,
          errorMessage: failure.message,
        ),
      ),
      (data) => emit(state.copyWith(status: Status.success, data: data)),
    );
  }
}
