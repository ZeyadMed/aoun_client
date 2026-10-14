import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aoun_client/core/bloc/paginated_bloc/exports.dart';
import 'package:aoun_client/core/enum/status.dart';
import 'package:aoun_client/feature/main/contracts/data/data_source/get_contracts_data_source.dart';
import 'package:aoun_client/feature/main/contracts/data/model/contract_model.dart';

class GetRecentContractsCubit extends Cubit<BaseState<List<ContractModel>>> {
  final GetContractsDataSource _dataSource;
  GetRecentContractsCubit(this._dataSource) : super(const BaseState());

  Future<void> getRecentContracts() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _dataSource.getRecentContracts();
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
