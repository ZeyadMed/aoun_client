import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aoun_client/core/bloc/paginated_bloc/exports.dart';
import 'package:aoun_client/core/enum/status.dart';
import 'package:aoun_client/feature/auth/presentation/screens/logout/data/data_source/logout_data_soutrce.dart';
import 'package:aoun_client/feature/auth/presentation/screens/logout/presentation/logic/logout_event.dart';

class LogoutBloc extends Bloc<LogoutEvent, BaseState<void>> {
  final LogoutDataSource logoutDataSource;

  LogoutBloc(this.logoutDataSource) : super(const BaseState<void>()) {
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<BaseState<void>> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    final result = await logoutDataSource.logoutAcount();
    emit(
      result.fold(
        (l) => state.copyWith(status: Status.failure, errorMessage: l.message),
        (r) => state.copyWith(status: Status.success),
      ),
    );
  }
}
