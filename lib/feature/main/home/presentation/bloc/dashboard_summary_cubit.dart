import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aoun_client/core/bloc/paginated_bloc/exports.dart';
import 'package:aoun_client/core/enum/status.dart';
import 'package:aoun_client/feature/main/home/data/data_source/dashboard_data_source.dart';
import 'package:aoun_client/feature/main/home/data/model/dashboard_summary_model.dart';

class DashboardSummaryCubit extends Cubit<BaseState<DashboardSummaryModel>> {
  final DashboardDataSource _dashboardDataSource;

  DashboardSummaryCubit(this._dashboardDataSource) : super(const BaseState());

  Future<void> getDashboardSummary() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _dashboardDataSource.getDashboardSummary();

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
