import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aoun_client/core/bloc/paginated_bloc/exports.dart';
import 'package:aoun_client/core/enum/status.dart';
import 'package:aoun_client/feature/auth/presentation/screens/verify_otp/data/data_source/verify_otp_data_source.dart';
import 'package:aoun_client/feature/auth/presentation/screens/verify_otp/presentation/logic/verify_otp_event.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, BaseState<String>> {
  final VerifyOtpDataSource _dataSource;
  VerifyOtpBloc(this._dataSource) : super(const BaseState()) {
    on<VerifyOtpEvent>(_onVerify);
  }

  FutureOr<void> _onVerify(
    VerifyOtpEvent event,
    Emitter<BaseState<String>> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    final result = await _dataSource.verifyOtp(
      phoneNumber: event.phoneNumber,
      otpCode: event.otpCode,
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
