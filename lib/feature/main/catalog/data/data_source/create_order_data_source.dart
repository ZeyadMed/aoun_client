import 'package:aoun_client/core/helpers/helpers.dart';
import 'package:aoun_client/core/http/either.dart';
import 'package:aoun_client/core/http/failure.dart';
import 'package:aoun_client/core/http/http.dart';
import 'package:aoun_client/feature/main/catalog/data/model/create_order_model.dart';

abstract interface class CreateOrderDataSource {
  Future<Either<Failure, Null>> createOrder(CreateOrderModel request);
}

class CreateOrderDataSourceImpl implements CreateOrderDataSource {
  final GenericDataSource _genericDataSource;
  const CreateOrderDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, Null>> createOrder(CreateOrderModel request) {
    return _genericDataSource.postData<Null>(
      endpoint: Endpoints.createOrder,
      data: request.toJson(),
    );
  }
}
