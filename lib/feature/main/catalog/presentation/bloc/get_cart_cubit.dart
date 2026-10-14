import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aoun_client/core/bloc/paginated_bloc/exports.dart';
import 'package:aoun_client/core/enum/status.dart';
import 'package:aoun_client/core/http/either.dart';
import 'package:aoun_client/core/http/failure.dart';
import 'package:aoun_client/feature/main/catalog/data/data_source/get_cart_data_source.dart';
import 'package:aoun_client/feature/main/catalog/data/model/add_to_cart_model.dart';
import 'package:aoun_client/feature/main/catalog/data/model/cart_model.dart';
import 'package:aoun_client/feature/main/catalog/data/model/update_cart_item_model.dart';

class GetCartCubit extends Cubit<BaseState<CartModel>> {
  final GetCartDataSource _getCartDataSource;
  GetCartCubit(this._getCartDataSource) : super(const BaseState());

  Future<void> getCart() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _getCartDataSource.getCart();
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

  Future<Either<Failure, Null>> addToCart(AddToCartModel request) async {
    final result = await _getCartDataSource.addToCart(request);
    result.fold((_) => null, (_) => getCart());
    return result;
  }

  Future<Either<Failure, Null>> updateItem(
    int cartItemId,
    UpdateCartItemModel request,
  ) async {
    final result = await _getCartDataSource.updateItem(cartItemId, request);
    result.fold((_) => null, (_) => getCart());
    return result;
  }

  Future<Either<Failure, Null>> deleteItem(int cartItemId) async {
    final result = await _getCartDataSource.deleteItem(cartItemId);
    result.fold((_) => null, (_) => getCart());
    return result;
  }

  Future<Either<Failure, Null>> clearCart() async {
    final result = await _getCartDataSource.clearCart();
    result.fold((_) => null, (_) => getCart());
    return result;
  }
}
