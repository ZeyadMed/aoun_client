import 'package:aoun_client/core/bloc/paginated_bloc/exports.dart';
import 'package:aoun_client/core/params/params.dart';
import 'package:aoun_client/feature/main/contracts/data/data_source/get_contracts_data_source.dart';
import 'package:aoun_client/feature/main/contracts/data/model/contract_model.dart';

class GetContractsCubit extends PaginatedBloc<ContractModel> {
  GetContractsCubit(GetContractsDataSource dataSource)
    : super(
        pageSize: 15,
        fetchPage: (page, limit, query, params) {
          final status = params is int ? params : null;
          return dataSource.getContracts(
            params: PaginationParams(page: page, limit: limit),
            status: status,
          );
        },
        cacheKeyBuilder: (params, query) {
          final status = params is int ? params : 0;
          return 'get_contracts_$status';
        },
      );
}
