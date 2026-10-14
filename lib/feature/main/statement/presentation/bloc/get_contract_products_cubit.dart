import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aoun_client/core/bloc/paginated_bloc/exports.dart';
import 'package:aoun_client/core/enum/status.dart';
import 'package:aoun_client/feature/main/statement/data/data_source/statement_data_source.dart';
import 'package:aoun_client/feature/main/statement/data/model/contract_product_model.dart';

class GetContractProductsCubit
    extends Cubit<BaseState<List<ContractProductModel>>> {
  final StatementDataSource _dataSource;
  GetContractProductsCubit(this._dataSource) : super(const BaseState());

  Future<void> getContractProducts() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _dataSource.getContractProducts();
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
