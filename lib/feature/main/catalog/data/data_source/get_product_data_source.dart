import 'package:aoun_client/core/helpers/helpers.dart';
import 'package:aoun_client/core/http/either.dart';
import 'package:aoun_client/core/http/failure.dart';
import 'package:aoun_client/core/http/http.dart';
import 'package:aoun_client/core/params/params.dart';
import 'package:aoun_client/feature/main/catalog/data/model/get_product_model.dart';

abstract interface class GetProductDataSource {
  Future<Either<Failure, List<GetProductModel>>> getProduct({
    String? query,
    required PaginationParams params,
    required int categoryId,
  });
}

class GetProductDataSourceImpl implements GetProductDataSource {
  final GenericDataSource _genericDataSource;
  GetProductDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<GetProductModel>>> getProduct({
    String? query,
    required PaginationParams params,
    required int categoryId,
  }) {
    return _genericDataSource.fetchData(
      endpoint: Endpoints.getProduct,
      queryParameters: {
        'PageIndex': params.page,
        'PageSize': params.limit,
        if (query != null && query.isNotEmpty) 'search': query,
        if (categoryId > 0) 'categoryId': categoryId,
      },
      fromJson: (json) => GetProductModel.fromJson(json),
    );
  }
}
