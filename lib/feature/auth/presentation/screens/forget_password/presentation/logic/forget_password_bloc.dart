import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aoun_client/core/bloc/paginated_bloc/exports.dart';
import 'package:aoun_client/core/enum/status.dart';
import 'package:aoun_client/feature/auth/presentation/screens/forget_password/data/data_source/forget_password_data_source.dart';
import 'package:aoun_client/feature/auth/presentation/screens/forget_password/presentation/logic/forget_password_event.dart';

class ForgetPasswordBloc extends Bloc<ForgetPasswordEvent, BaseState<String>> {
  final ForgetPasswordDataSource _dataSource;
  ForgetPasswordBloc(this._dataSource) : super(const BaseState()) {
    on<ForgetPasswordEvent>(_onSubmit);
  }

  FutureOr<void> _onSubmit(
    ForgetPasswordEvent event,
    Emitter<BaseState<String>> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    final result = await _dataSource.forgetPassword(
      phoneNumber: event.phoneNumber,
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
