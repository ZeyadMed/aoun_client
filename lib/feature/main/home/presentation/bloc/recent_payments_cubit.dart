import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aoun_client/core/bloc/paginated_bloc/exports.dart';
import 'package:aoun_client/core/enum/status.dart';
import 'package:aoun_client/feature/main/home/data/data_source/dashboard_data_source.dart';
import 'package:aoun_client/feature/main/home/data/model/recent_payment_model.dart';

class RecentPaymentsCubit extends Cubit<BaseState<List<RecentPaymentModel>>> {
  final DashboardDataSource _dataSource;
  RecentPaymentsCubit(this._dataSource) : super(const BaseState());

  Future<void> getRecentPayments() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _dataSource.getRecentPayments();
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
