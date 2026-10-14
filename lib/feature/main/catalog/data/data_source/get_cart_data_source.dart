import 'package:aoun_client/core/helpers/helpers.dart';
import 'package:aoun_client/core/http/either.dart';
import 'package:aoun_client/core/http/failure.dart';
import 'package:aoun_client/core/http/http.dart';
import 'package:aoun_client/feature/main/catalog/data/model/add_to_cart_model.dart';
import 'package:aoun_client/feature/main/catalog/data/model/cart_model.dart';
import 'package:aoun_client/feature/main/catalog/data/model/update_cart_item_model.dart';

abstract interface class GetCartDataSource {
  Future<Either<Failure, CartModel>> getCart();
  Future<Either<Failure, Null>> addToCart(AddToCartModel request);
  Future<Either<Failure, Null>> updateItem(
    int cartItemId,
    UpdateCartItemModel request,
  );
  Future<Either<Failure, Null>> deleteItem(int cartItemId);
  Future<Either<Failure, Null>> clearCart();
}

class GetCartDataSourceImpl implements GetCartDataSource {
  final GenericDataSource _genericDataSource;
  const GetCartDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, CartModel>> getCart() {
    return _genericDataSource.fetchResult<CartModel>(
      endpoint: Endpoints.getCart,
      fromJson: (json) => CartModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Either<Failure, Null>> addToCart(AddToCartModel request) {
    return _genericDataSource.postData<Null>(
      endpoint: Endpoints.addToCart,
      data: request.toJson(),
    );
  }

  @override
  Future<Either<Failure, Null>> updateItem(
    int cartItemId,
    UpdateCartItemModel request,
  ) {
    return _genericDataSource.updateData<Null>(
      endpoint: Endpoints.updateCartItem(cartItemId),
      data: request.toJson(),
    );
  }

  @override
  Future<Either<Failure, Null>> deleteItem(int cartItemId) {
    return _genericDataSource.deleteData<Null>(
      endpoint: Endpoints.deleteCartItem(cartItemId),
    );
  }

  @override
  Future<Either<Failure, Null>> clearCart() {
    return _genericDataSource.deleteData<Null>(endpoint: Endpoints.clearCart);
  }
}
