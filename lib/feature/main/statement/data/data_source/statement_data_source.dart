import 'package:aoun_client/core/helpers/helpers.dart';
import 'package:aoun_client/core/http/either.dart';
import 'package:aoun_client/core/http/failure.dart';
import 'package:aoun_client/core/http/http.dart';
import 'package:aoun_client/feature/main/statement/data/model/contract_product_model.dart';
import 'package:aoun_client/feature/main/statement/data/model/statement_model.dart';
import 'package:aoun_client/feature/main/statement/data/model/statements_model.dart';

abstract interface class StatementDataSource {
  Future<Either<Failure, List<ContractProductModel>>> getContractProducts();
  Future<Either<Failure, StatementsModel>> getStatementByProduct(int productId);
}

class StatementDataSourceImpl implements StatementDataSource {
  final GenericDataSource _genericDataSource;
  const StatementDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<ContractProductModel>>> getContractProducts() {
    return _genericDataSource.fetchData(
      endpoint: Endpoints.contractProducts,
      fromJson: (json) =>
          ContractProductModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Either<Failure, StatementsModel>> getStatementByProduct(
    int productId,
  ) async {
    final result = await _genericDataSource.fetchData<StatementModel>(
      endpoint: Endpoints.statementByProduct(productId),
      fromJson: (json) => StatementModel.fromJson(json as Map<String, dynamic>),
    );

    return result.fold(
      (failure) => Left(failure),
      (statements) => Right(StatementsModel(statements: statements)),
    );
  }
}
