import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aoun_client/core/bloc/paginated_bloc/exports.dart';
import 'package:aoun_client/core/enum/status.dart';
import 'package:aoun_client/feature/main/statement/data/data_source/statement_data_source.dart';
import 'package:aoun_client/feature/main/statement/data/model/statements_model.dart';

class GetStatementCubit extends Cubit<BaseState<StatementsModel>> {
  final StatementDataSource _dataSource;
  GetStatementCubit(this._dataSource) : super(const BaseState());

  Future<void> getStatement(int productId) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _dataSource.getStatementByProduct(productId);
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
