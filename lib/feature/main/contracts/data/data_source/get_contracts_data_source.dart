import 'package:aoun_client/core/helpers/helpers.dart';
import 'package:aoun_client/core/http/either.dart';
import 'package:aoun_client/core/http/failure.dart';
import 'package:aoun_client/core/http/http.dart';
import 'package:aoun_client/core/params/params.dart';
import 'package:aoun_client/feature/main/contracts/data/model/contract_installment_model.dart';
import 'package:aoun_client/feature/main/contracts/data/model/contract_model.dart';
import 'package:aoun_client/feature/main/contracts/data/model/overdue_installment_model.dart';

abstract interface class GetContractsDataSource {
  Future<Either<Failure, List<ContractModel>>> getContracts({
    required PaginationParams params,
    int? status,
  });
  Future<Either<Failure, List<ContractModel>>> getRecentContracts();
  Future<Either<Failure, List<ContractInstallmentModel>>> getInstallments(
    int contractId,
  );
  Future<Either<Failure, List<OverdueInstallmentModel>>>
  getOverdueInstallments();
}

class GetContractsDataSourceImpl implements GetContractsDataSource {
  final GenericDataSource _genericDataSource;
  const GetContractsDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<ContractModel>>> getContracts({
    required PaginationParams params,
    int? status,
  }) {
    return _genericDataSource.fetchData(
      endpoint: Endpoints.getContracts,
      queryParameters: {
        'PageIndex': params.page,
        'PageSize': params.limit,
        'status': ?status,
      },
      fromJson: (json) => ContractModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Either<Failure, List<ContractModel>>> getRecentContracts() {
    return _genericDataSource.fetchData(
      endpoint: Endpoints.getRecentContracts,
      fromJson: (json) => ContractModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Either<Failure, List<ContractInstallmentModel>>> getInstallments(
    int contractId,
  ) {
    return _genericDataSource.fetchData(
      endpoint: Endpoints.getContractInstallments(contractId),
      fromJson: (json) =>
          ContractInstallmentModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Either<Failure, List<OverdueInstallmentModel>>>
  getOverdueInstallments() {
    return _genericDataSource.fetchData(
      endpoint: Endpoints.overdueInstallments,
      fromJson: (json) =>
          OverdueInstallmentModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
