import 'package:aoun_client/core/helpers/helpers.dart';
import 'package:aoun_client/core/http/either.dart';
import 'package:aoun_client/core/http/failure.dart';
import 'package:aoun_client/core/http/http.dart';
import 'package:aoun_client/feature/main/catalog/data/model/get_category_model.dart';

abstract interface class GetCatagoryDataSource {
  Future<Either<Failure, List<GetCategoryModel>>> getcatagory();
}

class GetCatagoryDataSourceImpl implements GetCatagoryDataSource {
  final GenericDataSource _genericDataSource;
  const GetCatagoryDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<GetCategoryModel>>> getcatagory() {
    return _genericDataSource.fetchData(
      endpoint: Endpoints.catagory,
      fromJson: (json) => GetCategoryModel.fromJson(json),
    );
  }
}
