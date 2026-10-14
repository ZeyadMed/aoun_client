import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aoun_client/core/bloc/paginated_bloc/exports.dart';
import 'package:aoun_client/core/enum/status.dart';
import 'package:aoun_client/feature/auth/presentation/screens/login/data/data_source/login_data_source.dart';
import 'package:aoun_client/feature/auth/presentation/screens/login/presentation/logic/login_event.dart';
import 'package:aoun_client/feature/auth/presentation/screens/register/data/models/user_token.dart';

class LoginBloc extends Bloc<LoginEvent, BaseState<UserToken>> {
  final LoginDataSource _loginDataSource;
  LoginBloc(this._loginDataSource) : super(const BaseState()) {
    on<LoginEvent>(_onLogin);
  }

  FutureOr<void> _onLogin(
    LoginEvent event,
    Emitter<BaseState<UserToken>> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    final result = await _loginDataSource.login(
      phoneNumber: event.phoneNumber,
      password: event.password,
      rememberMe: event.rememberMe,
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
